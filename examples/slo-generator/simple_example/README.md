# Simple Example

This example illustrates how to use the `slo-generator` module, with a simple 
config (backend is Cloud Monitoring, and exporter is also Cloud Monitoring).

## Prerequisites

To run this example, you'll need:

- a GCP project (see an example definition [here](../../test/setup/main.tf).
- the IAM role `roles/owner` on the project for the service account running the Terraform.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name         | Description                        | Type     | Default         | Required |
| ------------ | ---------------------------------- | -------- | --------------- | :------: |
| bq\_location | Location of BQ dataset             | `string` | `"US"`          |    no    |
| labels       | Project labels                     | `map`    | `{}`            |    no    |
| project\_id  | Project id                         | `any`    | n/a             |   yes    |
| region       | Region                             | `string` | `"us-east1"`    |    no    |
| schedule     | Cron-like Cloud Scheduler schedule | `string` | `"* * * * */1"` |    no    |
| secrets      | slo-generator secrets              | `map`    | `{}`            |    no    |

## Outputs

| Name          | Description |
| ------------- | ----------- |
| slo-generator | n/a         |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
