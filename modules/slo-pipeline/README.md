## SLO Pipeline

The SLO pipeline submodule creates:

* A Pub/Sub topic that will receive each SLO report
* A Cloud Function that will process each SLO report and send them to a
  destination (BigQuery / Stackdriver Monitoring)
* A JSON configuration file for the Cloud Function, indicating what exporters
  will be configured.
* A JSON configuration file for the Cloud Function, indicating burn rates
  definitions.
