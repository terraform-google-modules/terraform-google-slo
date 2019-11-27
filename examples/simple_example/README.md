# Simple Example

This example illustrates how to use the `slo` module.

The example will create the following resources:

- A new project to host the SLO pipeline
- An [SLO pipeline](../../modules/slo-pipeline) that export SLO results to BigQuery, Stackdriver Monitoring
- A sample [SLO](../../modules/slo) that computes the number of exported Pub/Sub messages over the total number of Pub/Sub messages

## Prerequisites

To run this example, you'll need:

- a GCP project (see an example definition [here](../../test/setup/main.tf).
- the IAM role `roles/owner` on the project for the service account running the Terraform.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket\_name | GCS bucket name to create | string | n/a | yes |
| function\_name | Name of the Cloud Function running the SLO pipeline | string | `"slo-shared-export"` | no |
| labels | Project labels | map | `<map>` | no |
| project\_id | Project id | string | n/a | yes |
| region | Region | string | `"us-east1"` | no |
| schedule | Cron-like Cloud Scheduler schedule | string | `"* * * * */1"` | no |
| stackdriver\_host\_project\_id | Stackdriver host project id | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| slo | SLO outputs |
| slo\_pipeline | SLO pipeline outputs |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
