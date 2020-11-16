# Upgrading to terraform-google-slo v1.0

The v1.0 release is a backward incompatible release of the `slo` module:
`slo-generator` upgrade to version `1.4.0` adds a field `metadata` to specify
additional metadata for metrics labels and exporters.

Since Terraform does not support optional variables, the `metadata` field is now
a required variable. However, it can be set to `{}` if no additional metadata is
wanted.

To migrate to `terraform-google-slo/modules/slo` version `v1.0`:

- Add a `metadata` field to all of your SLO configs. See [commit example](https://github.com/terraform-google-modules/terraform-google-slo/pull/73/commits/272deb39e3794ffc17f9fe42d88f61f2d7d1edfa).

- Upgrade the module version to `v1.0`.

- Run `terraform plan` and `terraform apply`.
