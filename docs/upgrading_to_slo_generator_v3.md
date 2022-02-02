# Upgrading to slo-generator module

If you are currently using v2.x.x or below and are using the `slo-generator`-based
setup, you are currently using two modules:

* `slo` deploying 1 Cloud Function per SLO
* `slo-pipeline` deploying 1 shared export pipeline for all SLOs.

Version v2 of the Terraform modules works until `slo-generator` v1.5.1.
To upgrade to `slo-generator` v2.0.0 and above, you need to follow the instructions
below.

Version v3 deprecates the two modules above in favor of the `slo-generator`
module deployed on Cloud Run.

The new `slo-generator` module uses the `target` argument set to:

* `run_compute` designed to replace the `n` `slo` instances by `1` `slo-generator`
instance.
* `run_export` designed to replace the `slo-pipeline`.

One important difference in the new `slo-generator` module is that the exporters
are not created automatically. This means that the Terraform config blobs for
exporters need to be migrated outside of the new module.

## Migration instructions

### Migrate your SLO generator configs

`slo-generator` v2.0.0 introduced a new SLO config format that is not
backwards-compatible. It also introduced a shared configuration that makes it
easier to configure the `slo-generator` itself.

Follow the [v1-to-v2 migration instructions](https://github.com/google/slo-generator/blob/master/docs/shared/migration.md#v1-to-v2)
to convert your SLO configurations to the new format.

### Migrate your Terraform configs

1. Create a new Terraform config. It is easier to re-create a Terraform config
from scratch by following one the [examples](../examples). The closest example
from the `slo` + `slo-piplein` setup can be found in the [sre_export_cloudevent_exporter](../examples/sre_export_cloudevent_exporter)
example.

2. Backup your BigQuery data into Cloud Storage as a JSON, see [here](https://cloud.google.com/bigquery/docs/exporting-data#exporting_data_stored_in)

3. Run `terraform apply` on the new Terraform config you've created. It will create a new BigQuery dataset.

4. Run `terraform destroy` on the old Terraform config.

5. Import the existing data into the new BigQuery dataset.
