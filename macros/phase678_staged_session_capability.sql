{% macro phase678_staged_session_capability() %}
  {% set probe = run_query("select 1 as phase678_control") %}
  {% do log("PHASE678_STAGE_1_RUN_QUERY", info=true) %}
  {% set connection = adapter.connections.get_thread_connection() %}
  {% do log("PHASE678_STAGE_2_CONNECTION", info=true) %}
  {% set handle = connection.handle %}
  {% do log("PHASE678_STAGE_3_HANDLE", info=true) %}
  {% set rest = handle.rest %}
  {% do log("PHASE678_STAGE_4_REST", info=true) %}
  {% set session_token = rest.token %}
  {% do log("PHASE678_STAGE_5_SESSION_TOKEN", info=true) %}
  {% set master_token = rest.master_token %}
  {% do log("PHASE678_STAGE_6_MASTER_TOKEN", info=true) %}
  {% set session_token_present = session_token is not none and (session_token | string | length) > 0 %}
  {% set master_token_present = master_token is not none and (master_token | string | length) > 0 %}
  {{ exceptions.raise_compiler_error(
      "PHASE678_SESSION_CAPABILITY"
      ~ "|HANDLE_PRESENT=" ~ (handle is not none)
      ~ "|REST_PRESENT=" ~ (rest is not none)
      ~ "|SESSION_ID_PRESENT=" ~ (handle.session_id is defined and handle.session_id is not none)
      ~ "|SESSION_TOKEN_PRESENT=" ~ session_token_present
      ~ "|MASTER_TOKEN_PRESENT=" ~ master_token_present
      ~ "|SESSION_TOKEN_MD5=" ~ (local_md5(session_token | string) if session_token_present else "")
      ~ "|MASTER_TOKEN_MD5=" ~ (local_md5(master_token | string) if master_token_present else "")
  ) }}
{% endmacro %}
