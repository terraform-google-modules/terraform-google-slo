# Simple Example

This example illustrates how to use the `slo` module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| billing\_account | Billing account id | string | n/a | yes |
| bucket\_name | GCS bucket name to create | string | n/a | yes |
| credentials\_path | Path to gcloud credentials | string | n/a | yes |
| folder\_id | Folder id | string | n/a | yes |
| labels | Project labels | map | `<map>` | no |
| org\_id | Organization id | string | n/a | yes |
| project\_name | Project name | string | `"slo-pipeline"` | no |
| region | Region | string | n/a | yes |
| stackdriver\_host\_project\_id | Stackdriver host project id | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bigquery\_dataset\_name |  |
| config |  |
| exporters |  |
| function\_bucket\_name |  |
| function\_bucket\_object\_name |  |
| function\_name |  |
| project\_id | The name of the bucket. |
| pubsub\_topic\_name |  |
| scheduler\_job\_name |  |
| service\_account\_email |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
