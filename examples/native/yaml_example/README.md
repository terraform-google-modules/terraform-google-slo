# Advanced Example

This example illustrates how to use the `slo-native` module using SLO YAML
definitions as input. Keeping a folder with your SLO definitions helps with
maintaining an SLO repository and simplifies writing new SLOs.

The example will create the following resources:

- A set of [SLO](../../../modules/slo-native) defined in the [templates/](./templates)
folder.

## Prerequisites

To run this example, you'll need:

- a GCP project (see an example definition [here](../../../test/setup/main.tf).
- the IAM role `roles/owner` on the project for the service account running the Terraform.
- An App Engine application running

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app\_engine\_project\_id | App Engine project id | string | n/a | yes |
| project\_id | Project id | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| slo-cass-latency5ms-window |  |
| slo-gae-latency500ms |  |
| slo-gcp-latency400ms |  |
| slo-gcp-latency500ms-window |  |
| slo-uptime-latency500ms |  |
| slo-uptime-pass |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply -target module.slos` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
