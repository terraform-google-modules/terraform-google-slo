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

from slo_generator import compute
import json
import base64

import google.cloud.storage


def main(data, context):
    exporters = download_gcs("${exporters_url}")
    data = json.loads(base64.b64decode(data['data']))
    compute.export(data, exporters)

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
