# terraform-google-slo

This module deploys the [`slo-generator`](https://github.com/GoogleCloudPlatform/professional-services/tree/master/tools/slo-generator) in Cloud Functions in order to compute
and export SLOs on a schedule.

## Architecture

This module is split into two submodules:

* `slo-pipeline`: This submodule handles exporting SLO reports to different
destinations (Cloud Pub/Sub, BigQuery, Stackdriver Monitoring). The
infrastructure is shared by all SLOs.

* `slo`: This submodule deploys the infrastructure needed to compute **one** SLO.
Users should use one invocation of this submodule by SLO. Once the SLO report
is computed, the result is fed to the shared Pub/Sub topic created by the
`slo-pipeline` module.

![Architecture](./diagram.png)


## Usage

First, deploy the SLO pipeline:

```hcl
module "slo-pipeline" {
  source                      = "terraform-google-modules/slo/google//modules/slo-pipeline"
  function_name               = "slo-export"
  region                      = "us-east"
  project_id                  = "test-project"
  bigquery_project_id         = "test-project"
  bigquery_dataset_name       = "slo_reports"
  stackdriver_host_project_id = "sd-host"
}
```

Now, deploy an SLO definition:

```hcl
module "slo-definition-1" {
  source             = "terraform-google-modules/slo/google//modules/slo"
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

Additional information, including description of the Inputes / Outputs is
available in [`modules/slo-pipeline/README.md`](./modules/slo-pipeline/README.md) and [`modules/slo/README.md`](./modules/slo/README.md).

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html
