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
import logging
import pprint
import time
from datetime import datetime
from urllib.parse import urlparse

import google.cloud.storage
from slo_generator import compute

LOGGER = logging.getLogger(__name__)

def main(data, context):
    LOGGER.info("Downloading configs from GCS")
    error_budget_policy = download_gcs("${error_budget_policy_url}")
    slo_config = download_gcs("${slo_config_url}")
    LOGGER.info("Running SLO computations:")
    LOGGER.info("SLO Config: %s", pprint.pformat(slo_config))
    LOGGER.info("Error Budget Policy: %s",
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


def decode_gcs_url(url):
    """Decode GCS URL.

    Args:
        url (str): GCS URL.

    Returns:
        tuple: (bucket_name, file_path)
    """
    split_url = url.split('/')
    bucket_name = split_url[2]
    file_path = '/'.join(split_url[3:])
    return (bucket_name, file_path)

def download_gcs(url):
    """Download config from GCS and load it with json module.

    Args:
        url: Config URL.

    Returns:
        dict: Loaded configuration.
    """
    storage_client = google.cloud.storage.Client()
    bucket, filepath = decode_gcs_url(url)
    bucket = storage_client.get_bucket(bucket)
    blob = bucket.blob(filepath)
    data = json.loads(blob.download_as_string(client=None))
    return data
