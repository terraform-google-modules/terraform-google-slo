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
| bucket\_force\_destroy | When deleting the GCS bucket containing the cloud function, delete all objects in the bucket first. | string | `"true"` | no |
| config | SLO Configuration | object | n/a | yes |
| error\_budget\_policy | Error budget policy config | object | `<list>` | no |
| function\_environment\_variables | A set of key/value environment variable pairs to assign to the function. | map(string) | `<map>` | no |
| function\_labels | A set of key/value label pairs to assign to the function. | map(string) | `<map>` | no |
| function\_source\_archive\_bucket\_labels | A set of key/value label pairs to assign to the function source archive bucket. | map(string) | `<map>` | no |
| function\_source\_directory | The contents of this directory will be archived and used as the function source. (defaults to standard SLO generator code) | string | `""` | no |
| function\_timeout\_s | The amount of time in seconds allotted for the execution of the function. | number | `"60"` | no |
| grant\_iam\_roles | Grant IAM roles to created service accounts | string | `"true"` | no |
| labels | Labels to apply to all resources created | map | `<map>` | no |
| message\_data | The data to send in the topic message. | string | `"dGVzdA=="` | no |
| project\_id | SLO project id | string | n/a | yes |
| pubsub\_trigger | The topic name of the pubsub (in the same project) to trigg the slo compute. | string | n/a | yes |
| region | Region to deploy the Cloud Function in | string | `"us-east1"` | no |
| schedule | Cron-like schedule for Cloud Scheduler (ignored if use_custom_pubsub_trigger is true) | string | `"* * * * */1"` | no |
| service\_account\_email | Service account email (optional) | string | `""` | no |
| service\_account\_name | Service account name (in case the generated one is too long) | string | `""` | no |
| slo\_generator\_version | SLO generator library version | string | `"1.0.1"` | no |
| time\_zone | The timezone to use in scheduler | string | `"Etc/UTC"` | no |
| use\_custom\_pubsub\_trigger | Use a custom pubsub trigger (pass pubsub_trigger if true) | bool | `"false"` | no |
| use\_custom\_service\_account | Use a custom service account (pass service_account_email if true) | bool | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| config | SLO Config |
| function\_zip\_output\_path | Cloud Function zip output path |
| project\_id | Project id |
| scheduler\_job\_name | Cloud Scheduler job name |
| service\_account\_email | Service account email used to run the Cloud Function |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
