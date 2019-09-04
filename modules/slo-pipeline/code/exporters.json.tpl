{
  "exporters": [
    {
      "class": "Stackdriver",
      "project_id": "${stackdriver_host_project_id}"
    },
    {
      "class": "BigQuery",
      "project_id": "${bigquery_project_id}",
      "dataset_id": "${bigquery_dataset_name}",
      "table_id": "${bigquery_table_name}"
    }
  ]
}
