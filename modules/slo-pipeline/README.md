## SLO Pipeline

The SLO pipeline submodule creates the following resources:

* A **Pub/Sub topic** that will receive each SLO report
* A **Cloud Function** that will process each SLO report and send them to a
  destination (BigQuery / Stackdriver Monitoring)
* A **JSON configuration file** (needed by the `slo-generator`), indicating what
  export destinations will be configured (`exporters.json`).
* A **JSON configuration file** (needed by the `slo-generator`), describing
  which error budgets to calculate (`error-budget-policy.json`).

![Architecture](./diagram.png)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bigquery\_dataset\_name | BigQuery dataset name (optional) | string | `"slo"` | no |
| bigquery\_project\_id | BigQuery host project id (to write BQ tables) | string | n/a | yes |
| bigquery\_table\_name | BigQuery table name (optional) | string | `"reports"` | no |
| bucket\_name | Name of the bucket to create | string | n/a | yes |
| function\_memory | Memory in MB for the Cloud Function (increases with no. of SLOs) | string | `"128"` | no |
| function\_name | Cloud Function name | string | `"slo-exporter"` | no |
| project\_id | Project id to create SLO infrastructure | string | n/a | yes |
| region | Region for the App Engine app | string | `"us-west"` | no |
| stackdriver\_host\_project\_id | Stackdriver host project id (to write custom metrics) | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bigquery\_dataset\_self\_link | BigQuery dataset self link |
| exporters | Rendered exporters configuration for `slo-exporter` |
| function\_bucket\_name | Cloud Function bucket name |
| function\_bucket\_object\_name | Cloud Function code GCS object name |
| function\_name | Cloud Function name |
| project\_id | Project id |
| pubsub\_topic\_name | PubSub topic between Cloud Scheduler and Cloud Function |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
