{
  "slo_name": "${name}",
  "slo_target": "${target}",
  "slo_description": "${description}",
  "service_name": "${service_name}",
  "feature_name": "${feature_name}",
  "exporters": [
    {
      "class": "PubSub",
      "project_id": "${pubsub_project_id}",
      "topic_name": "${pubsub_topic_name}"
    }
  ],
  "backend": {
      "class": "${backend_class}",
      "project_id": "${backend_project_id}",
      "method": "${backend_method}",
      "measurement": ${backend_measurement}
  }
}
