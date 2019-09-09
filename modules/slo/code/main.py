# Copyright 2019 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#            http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from slo_generator import compute
import json
import pprint

with open("error_budget_policy.json") as f:
    error_budget_policy = json.load(f)

with open("slo_config.json") as f:
    slo_config = json.load(f)


def main(data, context):
    print("Running SLO computations:")
    print("SLO Config: %s" % pprint.pformat(slo_config))
    print("Error Budget Policy: %s" % pprint.pformat(error_budget_policy))
    compute.compute(
        slo_config,
        error_budget_policy,
        timestamp=None,
        client=None,
        do_export=True)
