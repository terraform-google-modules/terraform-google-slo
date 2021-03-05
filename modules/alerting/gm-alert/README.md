## Google Monitoring SLO alerts

The gm-alert submodule deploys google_monitoring_alert_policy based on an
SLO definition.

The submodule creates the following resources:

* **Google Monitoring Alert Policy**, for each setps, defined on error_budget_policy file definition + 1 other about NO_DATA.
NO_DATA is when Google Monitoring is no longer receiving metrics/data from the SLO-Generator (based on the metric `custom.googleapis.com/error_budget_burn_rate`)

## Pre-requisites
To use this module, you will need:

- A **GCP project** with the following APIs enabled:
  - Cloud Monitoring API: `monitoring.googleapis.com`

- optional: 2 **Google Monitoring Notification Channel** created on this project, 1 for urgent notification, the second for non-urgent notification

- The following **IAM roles** on the project, for the service account running the Terraform:
  - Cloud Scheduler Admin (`roles/monitoring.alertPolicyEditor`)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alert\_enabled | Enable SLI alerts | `bool` | `true` | no |
| config | SLO Configuration | <pre>object({<br>    slo_name        = string<br>    slo_target      = number<br>    slo_description = string<br>    service_name    = string<br>    feature_name    = string<br>    metadata        = map(string)<br>    backend         = any<br>    exporters       = any<br>  })</pre> | n/a | yes |
| error\_budget\_policy | Error budget policy config | <pre>list(object({<br>    error_budget_policy_step_name  = string<br>    measurement_window_seconds     = number<br>    alerting_burn_rate_threshold   = number<br>    urgent_notification            = bool<br>    overburned_consequence_message = string<br>    achieved_consequence_message   = string<br>  }))</pre> | n/a | yes |
| no\_data\_alert\_enabled | Enable NO\_DATA alerts | `bool` | `true` | no |
| no\_data\_threshold\_duration\_time | The amount of time that no data are compute by SLO-Generator to be considered failing. Currently, only values that are a multiple of a minute--e.g. 60s, 120s, or 300s --are supported. | `string` | `"600s"` | no |
| non\_urgent\_notification\_channel | non urgent notification channel for alerting burn rate is gt threshold | `list(string)` | `null` | no |
| project\_id | Project id | `string` | n/a | yes |
| urgent\_notification\_channel | urgent notification channel for alerting burn rate is gt threshold | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| config | SLO Config |
| error\_budget\_policy | Error budget policy config |
| no\_data\_alert | google monitoring alert policy for NO\_DATA |
| project\_id | Project id |
| slo\_alerts | All google monitoring alerts policy for SLO |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
