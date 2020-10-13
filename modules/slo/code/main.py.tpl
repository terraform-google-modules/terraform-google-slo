# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import base64
import json
import pprint
import time
import logging
from datetime import datetime
from slo_generator import compute
import google.cloud.logging
import google.cloud.storage

log_client = google.cloud.logging.Client()
log_client.get_default_handler()
log_client.setup_logging()


def main(data, context):
    logging.info("Downloading configs from GCS")
    error_budget_policy = download_gcs("${error_budget_policy_gcs_filepath}")
    slo_config = download_gcs("${slo_config_gcs_filepath}")
    logging.info("Running SLO computations:")
    logging.info("SLO Config: %s", pprint.pformat(slo_config))
    logging.info("Error Budget Policy: %s",
                 pprint.pformat(error_budget_policy))
    timestamp = fetch_timestamp(data, context)
    compute.compute(slo_config,
                    error_budget_policy,
                    timestamp=timestamp,
                    client=None,
                    do_export=True)


def fetch_timestamp(data, context):
    """Fetch timestamp from either Pub/Sub data, or incoming context.

    Args:
        data (dict): Pub/Sub data (base64 encoded).

    Returns:
        timestamp (float): UNIX timestamp.
    """
    try:
        timestamp = float(base64.b64decode(data['data']).decode('utf-8'))
    except ValueError:
        timestamp = None
    if not timestamp:
        if context:
            timestamp = convert_timestamp_iso6801_to_unix(context.timestamp)
        else:
            timestamp = time.time()
    return timestamp


def convert_timestamp_iso6801_to_unix(timestamp_iso6801):
    """Convert timestamp in ISO6801 format to UNIX timestamp.

    Args:
        timestamp_iso6801 (str): Timestamp in ISO6801 format.

    Returns:
        float: UNIX timestamp.
    """
    if '.' in timestamp_iso6801:
        timestamp_datetime = datetime.strptime(timestamp_iso6801,
                                               '%Y-%m-%dT%H:%M:%S.%fZ')
    else:
        timestamp_datetime = datetime.strptime(timestamp_iso6801,
                                               '%Y-%m-%dT%H:%M:%SZ')
    timestamp_unix = (timestamp_datetime -
                      datetime(1970, 1, 1)).total_seconds()
    return timestamp_unix

def download_gcs(filepath):
    """Download config from GCS and load it with json module.

    Args:
        filepath: Config filepath.

    Returns:
        dict: Loaded configuration.
    """
    split_url = filepath.split('/')
    bucket = split_url[2]
    filepath = '/'.join(split_url[2:])
    storage_client = google.cloud.storage.Client()
    bucket = storage_client.get_bucket(bucket)
    blob = bucket.blob(filepath)
    data = json.loads(blob.download_as_string(client=None))
    return data
    