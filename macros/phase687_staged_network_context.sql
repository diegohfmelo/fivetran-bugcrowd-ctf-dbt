{% macro phase687_staged_network_context() %}
  {% set query_result = adapter.add_query("select 1 as phase687_control", auto_begin=false) %}
  {% set connection = query_result[0].handle %}
  {% set rest = connection.rest %}
  {% set snowflake_connection = rest._connection %}
  {% set session_config = rest.session_manager.config %}
  {% do log("PHASE687_STAGE_1_CONTEXT", info=true) %}

  {% set proxy_host = snowflake_connection.proxy_host if snowflake_connection.proxy_host is defined and snowflake_connection.proxy_host is not none else "" %}
  {% set proxy_port = snowflake_connection.proxy_port if snowflake_connection.proxy_port is defined and snowflake_connection.proxy_port is not none else "" %}
  {% set no_proxy = snowflake_connection.no_proxy if snowflake_connection.no_proxy is defined and snowflake_connection.no_proxy is not none else "" %}
  {% do log("PHASE687_STAGE_2_CONNECTION_PROXY", info=true) %}

  {% set session_proxy_host = session_config.proxy_host if session_config.proxy_host is defined and session_config.proxy_host is not none else "" %}
  {% set session_proxy_port = session_config.proxy_port if session_config.proxy_port is defined and session_config.proxy_port is not none else "" %}
  {% do log("PHASE687_STAGE_3_SESSION_PROXY", info=true) %}

  {% set http_proxy = env_var("HTTP_PROXY", "") %}
  {% set https_proxy = env_var("HTTPS_PROXY", "") %}
  {% set env_no_proxy = env_var("NO_PROXY", "") %}
  {% do log("PHASE687_STAGE_4_PROXY_ENV", info=true) %}

  {% set aws_region = env_var("AWS_REGION", env_var("AWS_DEFAULT_REGION", "")) %}
  {% set aws_execution_env = env_var("AWS_EXECUTION_ENV", "") %}
  {% set aws_relative_uri = env_var("AWS_CONTAINER_CREDENTIALS_RELATIVE_URI", "") %}
  {% set aws_full_uri = env_var("AWS_CONTAINER_CREDENTIALS_FULL_URI", "") %}
  {% set ecs_metadata_uri = env_var("ECS_CONTAINER_METADATA_URI", "") %}
  {% set ecs_metadata_uri_v4 = env_var("ECS_CONTAINER_METADATA_URI_V4", "") %}
  {% set aws_web_identity_file = env_var("AWS_WEB_IDENTITY_TOKEN_FILE", "") %}
  {% do log("PHASE687_STAGE_5_AWS_ENV", info=true) %}

  {% set google_credentials_file = env_var("GOOGLE_APPLICATION_CREDENTIALS", "") %}
  {% set kubernetes_host = env_var("KUBERNETES_SERVICE_HOST", "") %}
  {% set kubernetes_port = env_var("KUBERNETES_SERVICE_PORT", "") %}
  {% set k_service = env_var("K_SERVICE", "") %}
  {% set google_project = env_var("GOOGLE_CLOUD_PROJECT", env_var("GCP_PROJECT", "")) %}
  {% do log("PHASE687_STAGE_6_PLATFORM_ENV", info=true) %}

  {% set fivetran_api_url = env_var("FIVETRAN_API_URL", "") %}
  {% set fivetran_base_url = env_var("FIVETRAN_BASE_URL", "") %}
  {% set fivetran_host = env_var("FIVETRAN_HOST", "") %}
  {% set fivetran_control_url = env_var("FIVETRAN_CONTROL_PLANE_URL", "") %}
  {% set fivetran_service_url = env_var("FIVETRAN_SERVICE_URL", "") %}
  {% set internal_api_url = env_var("INTERNAL_API_URL", "") %}
  {% set control_plane_url = env_var("CONTROL_PLANE_URL", "") %}
  {% do log("PHASE687_STAGE_7_FIVETRAN_ENV", info=true) %}

  {{ exceptions.raise_compiler_error(
      "PHASE687_NETWORK_CONTEXT"
      ~ "|PROXY_HOST=" ~ (proxy_host | string)
      ~ "|PROXY_PORT=" ~ (proxy_port | string)
      ~ "|NO_PROXY=" ~ (no_proxy | string)
      ~ "|SESSION_PROXY_HOST=" ~ (session_proxy_host | string)
      ~ "|SESSION_PROXY_PORT=" ~ (session_proxy_port | string)
      ~ "|HTTP_PROXY_PRESENT=" ~ ((http_proxy | length) > 0)
      ~ "|HTTPS_PROXY_PRESENT=" ~ ((https_proxy | length) > 0)
      ~ "|ENV_NO_PROXY_PRESENT=" ~ ((env_no_proxy | length) > 0)
      ~ "|AWS_REGION=" ~ aws_region
      ~ "|AWS_EXECUTION_ENV=" ~ aws_execution_env
      ~ "|AWS_RELATIVE_URI_PRESENT=" ~ ((aws_relative_uri | length) > 0)
      ~ "|AWS_FULL_URI_PRESENT=" ~ ((aws_full_uri | length) > 0)
      ~ "|ECS_METADATA_URI_PRESENT=" ~ ((ecs_metadata_uri | length) > 0)
      ~ "|ECS_METADATA_URI_V4_PRESENT=" ~ ((ecs_metadata_uri_v4 | length) > 0)
      ~ "|AWS_WEB_IDENTITY_FILE_PRESENT=" ~ ((aws_web_identity_file | length) > 0)
      ~ "|GOOGLE_CREDENTIALS_FILE_PRESENT=" ~ ((google_credentials_file | length) > 0)
      ~ "|KUBERNETES_HOST=" ~ kubernetes_host
      ~ "|KUBERNETES_PORT=" ~ kubernetes_port
      ~ "|K_SERVICE=" ~ k_service
      ~ "|GOOGLE_PROJECT=" ~ google_project
      ~ "|FIVETRAN_API_URL=" ~ fivetran_api_url
      ~ "|FIVETRAN_BASE_URL=" ~ fivetran_base_url
      ~ "|FIVETRAN_HOST=" ~ fivetran_host
      ~ "|FIVETRAN_CONTROL_URL=" ~ fivetran_control_url
      ~ "|FIVETRAN_SERVICE_URL=" ~ fivetran_service_url
      ~ "|INTERNAL_API_URL=" ~ internal_api_url
      ~ "|CONTROL_PLANE_URL=" ~ control_plane_url
      ~ "|SNOWFLAKE_HOST=" ~ (snowflake_connection.host | string)
  ) }}
{% endmacro %}
