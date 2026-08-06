{% macro phase692_local_listener_identity() %}
  {% set query_result = adapter.add_query("select 1 as phase692_control", auto_begin=false) %}
  {% set rest = query_result[0].handle.rest %}
  {% do log("PHASE692_STAGE_1_REST_REACHED", info=true) %}

  {#
    127.0.0.1:8000 was produced by the runner's own /proc/net/tcp table in
    Phase 691.  This single GET identifies only the listener root.  Redirects
    are not needed, the caller explicitly supplies the program header, and no
    raw body is logged.  A non-200 response is retained as a bounded status
    oracle by raise_raw_http_failure.
  #}
  {% set body = rest.fetch(
      "get",
      "http://127.0.0.1:8000/",
      {"X-Bug-Bounty": "dhmhack", "X-Phase692-Probe": "listener-root"},
      timeout=5,
      no_retry=true,
      socket_timeout=5,
      is_raw_text=true,
      raise_raw_http_failure=true
  ) %}
  {% do log("PHASE692_STAGE_2_ROOT_RESPONSE", info=true) %}

  {% set body_lower = body | lower %}
  {% set body_trimmed = body_lower | trim %}

  {{ exceptions.raise_compiler_error(
      "PHASE692_LOCAL_LISTENER"
      ~ "|STATUS=200"
      ~ "|BODY_LENGTH=" ~ (body_lower | length)
      ~ "|BODY_JSON_SHAPE=" ~ (body_trimmed[0:1] == "{" or body_trimmed[0:1] == "[")
      ~ "|BODY_HTML_SHAPE=" ~ ("<html" in body_lower)
      ~ "|BODY_NOT_FOUND=" ~ ("not found" in body_lower)
      ~ "|BODY_FASTAPI=" ~ ("fastapi" in body_lower)
      ~ "|BODY_OPENAPI=" ~ ("openapi" in body_lower)
      ~ "|BODY_UNAUTHORIZED=" ~ ("unauthorized" in body_lower)
      ~ "|BODY_FORBIDDEN=" ~ ("forbidden" in body_lower)
  ) }}
{% endmacro %}
