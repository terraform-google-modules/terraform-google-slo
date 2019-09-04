# terraform-google-slo

This module deploys the `slo-generator` to compute SLOs on a schedule using
a Cloud Scheduler, a Cloud Function and exporters.

The resources/services/activations/deletions that this module will create/trigger are:

- Create a GCS bucket with the provided name

## Usage

Basic usage of this module is as follows:

```hcl
module "slo-pipeline" {
  source                      = "terraform-google-modules/slo/"
  function_name               = "slo-export"
  region                      = "us-east"
  project_id                  = "test-project"
  bigquery_project_id         = "test-project"
  bigquery_dataset_name       = "slo_reports"
  stackdriver_host_project_id = "sd-host"
}

module "slo-definition-1" {
  source             = "../../modules/slo"
  name               = "slo-pubsub-ack"
  region             = "us-east1"
  description        = "Acked Pub/Sub messages over total number of Pub/Sub messages"
  service_name       = "test"
  feature_name       = "test"
  target             = "0.9"
  backend_class      = "Stackdriver"
  backend_project_id = "sd-host"
  backend_method     = "good_bad_ratio"
  backend_measurement = {
    filter_good = "project=\"${module.slo-pipeline.project_id}\" AND metric.type=\"pubsub.googleapis.com/subscription/ack_message_count\"",
    filter_bad  = "project=\"${module.slo-pipeline.project_id}\" AND metric.type=\"pubsub.googleapis.com/subscription/ack_message_count\""
  }
  schedule          = "* * * * */1"
  project_id        = module.slo-project.project_id
  pubsub_project_id = module.slo-pipeline.project_id
  pubsub_topic_name = module.slo-pipeline.pubsub_topic_name
  labels            = var.labels
}
```

Functional examples are included in the
[examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket\_name | The name of the bucket to create | string | n/a | yes |
| project\_id | The project ID to deploy to | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_name |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.12
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v2.0

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- Storage Admin: `roles/storage.admin`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Google Cloud Storage JSON API: `storage-api.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html
