## SLO

The SLO submodule deploys the `slo-generator` on a Cloud Function, triggered at a
regular interval by a Cloud Scheduler.

The submodule creates the following GCP resources:

* A Cloud Function
* A JSON configuration file for the Cloud Function, indicating which backends
  to query, and the method to compute the SLO
* A Cloud Scheduler that will trigger the Cloud Function at a pre-defined interval
