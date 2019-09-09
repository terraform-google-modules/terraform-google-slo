## SLO

The SLO submodule deploys infrastructure for computing SLO reports based on an
SLO definition.

![Architecture](./diagram.png)

The submodule creates the following resources:

* A **Cloud Function** which computes SLO reports using the `slo-generator`
* A **Cloud Pub/Sub** topic which bridges the Cloud Scheduler and the Cloud
  Function.
* A **Cloud Scheduler** job that will trigger the Cloud Function at a pre-defined
  interval through the Cloud Pub/Sub topic.
* A **JSON configuration file**, 1:1 mapping with the `slo-generator`
  configuration, indicating which backend to query metrics from, the method to
  compute the SLO, and other information. More documentation on backend types
  and compute methods is available in the `slo-generator` documentation.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| backend\_class | SLO backend class | string | `"Stackdriver"` | no |
| backend\_measurement | SLO measurement config | map(string) | n/a | yes |
| backend\_method | SLO computation method | string | n/a | yes |
| backend\_project\_id | Project id for the metrics backend | string | n/a | yes |
| description | SLO description | string | n/a | yes |
| feature\_name | Name of monitored feature | string | n/a | yes |
| labels | Labels to apply to all resources created | string | n/a | yes |
| name | SLO name | string | n/a | yes |
| project\_id | SLO project id | string | n/a | yes |
| pubsub\_project\_id | Pub/Sub project id to send results to | string | n/a | yes |
| pubsub\_topic\_name | Pub/Sub topic name to send results to | string | n/a | yes |
| region | Region | string | n/a | yes |
| schedule | Cron-like schedule | string | `"* * * * */1"` | no |
| service\_name | Name of monitored service | string | n/a | yes |
| target | Target for this SLO | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| config | Rendered SLO configuration for `slo-exporter` |
| scheduler\_job\_name | Cloud Scheduler job name |
| service\_account\_email | Service account email used to run the Cloud Function |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
