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

## Pre-requisites
To use this module, you will need:

- A **GCP project** dedicated to the SLO pipeline, with the following APIs enabled:
  - App Engine API: `appengine.googleapis.com`
  - Cloud Functions API: `cloudfunctions.googleapis.com`
  - Cloud Scheduler API: `cloudscheduler.googleapis.com`
  - Monitoring API: `monitoring.googleapis.com`
  - Logging API: `logging.googleapis.com`
  - Pub/Sub API: `pubsub.googleapis.com`
  - BigQuery API: `bigquery-json.googleapis.com`

- An **App Engine application** enabled on this project.

See the [fixture project](../../test/setup/main.tf) for an example to create this project and enable the App Engine application using Terraform and the [Project Factory module](https://github.com/terraform-google-modules/terraform-google-project-factory).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket\_name | Name of the bucket to create | string | n/a | yes |
| exporters | SLO export destinations config | object | n/a | yes |
| function\_memory | Memory in MB for the Cloud Function (increases with no. of SLOs) | string | `"128"` | no |
| function\_name | Cloud Function name | string | `"slo-exporter"` | no |
| project\_id | Project id to create SLO infrastructure | string | n/a | yes |
| pubsub\_topic\_name | Pub/Sub topic name | string | `"slo-export-topic"` | no |
| region | Region for the App Engine app | string | `"us-east1"` | no |
| service\_account\_name | Name of the service account to create | string | `"slo-exporter"` | no |

## Outputs

| Name | Description |
|------|-------------|
| exporters | Exporter config |
| function\_bucket\_name | Cloud Function bucket name |
| function\_bucket\_object\_name | Cloud Function code GCS object name |
| function\_name | Cloud Function name |
| project\_id | Project id |
| pubsub\_topic\_name | Ingress PubSub topic to SLO pipeline |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
