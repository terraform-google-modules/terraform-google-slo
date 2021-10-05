# 0.2.0 (09/16/2020) [RELEASED]
-   [x] Add ability to support multiple SLOs for `slo/` module.
-   [x] Add native SLO module `slo-native` using `google_service_monitoring_slo` resource as the main module
-   [x] Add Cloud Build API to list of required APIs (needed to create Cloud Functions)
-   [x] Restructure SLO examples:
    -   [x] `slo_generator/` --> Allows to support more backends and have options for reporting
        -   [x] `simple_example` --> Simple example with Cloud Monitoring service metrics
        -   [x] `yaml_example` --> Deploy multiple SLOs of different types based on YAML definitions + SLO dashboard + SLO alerts + sample BigQuery queries + Sample Datastudio template
    -   [x] `native/`
        -   [x] `simple_example`
        -   [x] `yaml_example` --> Full example: pipeline + app with 3 SLOs (availability / latency) - see sre-training repo

# 0.2.1 (09/22/2020)
-   [x] Fix IAM issue with Stackdriver Service Monitoring - grant `monitoring.servicesViewer` and `monitoring.servicesEditor`
-   [x] Fix project_id validation for other backends than Stackdriver

# 0.3.0 (09/30/2020)
-   [ ] Shared SLO Infra:
    -   [ ] Shared Cloud Scheduler
    -   [ ] Shared PubSub topic
-   [ ] Support for new field `config_file_path` in YAML or JSON (not only `config`) and `config_vars` for automatic template replacement
-   [ ] Add Cloud Monitoring Alert submodule `slo-alert` / flag to create Cloud Monitoring alerts
-   [ ] Add end-to-end tests for slo-generator arch
-   [ ] Custom backends
-   [ ] Add `custom-backend` example with customization of Cloud Function

# 1.0.0
-   [ ] Upload / Pull SLO configs from GCS instead of uploading them in the Cloud Function - allows to update SLOs without re-deploying the Cloud Functions

# 2.0.0
-   [ ] Add support for Terraform 0.13

# 3.0.0
-   [ ] Support for v2 YAML format
-   [ ] Deprecate 'Stackdriver' naming in favor of 'Cloud Monitoring'
-   [ ] Deprecate 'Stackdriver Service Monitoring' naming in favor of 'Service Monitoring'
