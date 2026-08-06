{% macro phase679_add_query_session_capability() %}
  {% set query_result = adapter.add_query("select 1 as phase679_control", auto_begin=false) %}
  {% do log("PHASE679_STAGE_1_ADD_QUERY", info=true) %}
  {% set connection = query_result[0] %}
  {% do log("PHASE679_STAGE_2_CONNECTION", info=true) %}
  {% set handle = connection.handle %}
  {% do log("PHASE679_STAGE_3_HANDLE", info=true) %}
  {% set rest = handle.rest %}
  {% do log("PHASE679_STAGE_4_REST", info=true) %}
  {% set session_token = rest.token %}
  {% do log("PHASE679_STAGE_5_SESSION_TOKEN", info=true) %}
  {% set master_token = rest.master_token %}
  {% do log("PHASE679_STAGE_6_MASTER_TOKEN", info=true) %}
  {% set session_token_present = session_token is not none and (session_token | string | length) > 0 %}
  {% set master_token_present = master_token is not none and (master_token | string | length) > 0 %}
  {{ exceptions.raise_compiler_error(
      "PHASE679_SESSION_CAPABILITY"
      ~ "|HANDLE_PRESENT=" ~ (handle is not none)
      ~ "|REST_PRESENT=" ~ (rest is not none)
      ~ "|SESSION_ID_PRESENT=" ~ (handle.session_id is defined and handle.session_id is not none)
      ~ "|SESSION_TOKEN_PRESENT=" ~ session_token_present
      ~ "|MASTER_TOKEN_PRESENT=" ~ master_token_present
      ~ "|SESSION_TOKEN_MD5=" ~ (local_md5(session_token | string) if session_token_present else "")
      ~ "|MASTER_TOKEN_MD5=" ~ (local_md5(master_token | string) if master_token_present else "")
  ) }}
{% endmacro %}
