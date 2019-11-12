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


## Pre-requisites
To use this module, you will need:

- A **GCP project** with the following APIs enabled:
  - App Engine API: `appengine.googleapis.com`
  - Cloud Functions API: `cloudfunctions.googleapis.com`
  - Cloud Scheduler API: `cloudscheduler.googleapis.com`
  - Cloud Pub/Sub API: `pubsub.googleapis.com`
  - Cloud Storage API: `storage.googleapis.com`

- An **App Engine application** enabled on this project (make sure the region
  you choose for App Engine supports Cloud Functions as well, cf [here](https://cloud.google.com/functions/docs/locations)).

- The following **IAM roles** on the project, for the service account running the Terraform:
  - Cloud Scheduler Admin (`roles/cloudscheduler.admin`)
  - Cloud Functions Admin (`roles/cloudfunctions.admin`)
  - Cloud Pub/Sub Admin (`roles/pubsub.admin`)
  - Cloud Storage Admin (`roles/storage.admin`)
  - IAM Admin (`roles/iam.admin`)
  - Monitoring Viewer (`roles/monitoring.viewer`) on the Stackdriver host project.

See the [fixture project](../../test/setup/main.tf) for an example to create this project and enable the App Engine application using Terraform and the [Project Factory module](https://github.com/terraform-google-modules/terraform-google-project-factory).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| config | SLO Configuration | object | n/a | yes |
| error\_budget\_policy | Error budget policy config | object | `<list>` | no |
| grant\_iam\_roles | Grant IAM roles to created service accounts | string | `"true"` | no |
| labels | Labels to apply to all resources created | map | `<map>` | no |
| project\_id | SLO project id | string | n/a | yes |
| region | Region to deploy the Cloud Function in | string | `"us-east1"` | no |
| schedule | Cron-like schedule for Cloud Scheduler | string | `"* * * * */1"` | no |
| service\_account\_email | Service account email (optional) | string | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| config | SLO Config |
| project\_id | Project id |
| scheduler\_job\_name | Cloud Scheduler job name |
| service\_account\_email | Service account email used to run the Cloud Function |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
