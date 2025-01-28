# Upgrading to terraform-google-slo v4.0

The v4.0 release of the `slo` module is a backward incompatible release.

### Google Cloud Platform Provider upgrade
The `slo` module now requires version v6.12+ of the Google Cloud Platform Providers.  See the [Terraform Google Provider 6.0.0 Upgrade Guide](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/version_6_upgrade) for more details.

### Terraform upgrade
The `slo` module now requires version v1.3+ of Terraform.

### slo-generator image

The use of a custom `slo-generator` image now requires the `slo_generator_remote` and `slo_generator_image` variables, rather than `gcr_project_id`.

```diff
module "slo-generator" {
  source  = "terraform-google-modules/slo/google//modules/slo-generator"
-  version = "~> 3.0"
+  version = "~> 4.0"

-  gcr_project_id        = "slo-generator-ci-a2b4"
-  slo_generator_version = "latest"
+  slo_generator_remote  = "ghcr.io"
+  slo_generator_image   = "google/slo-generator"
+  slo_generator_version = "master"
}
```
