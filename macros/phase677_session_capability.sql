{% macro phase677_session_capability() %}
  {% set probe = run_query("select 1 as phase677_control") %}
  {% set connection = adapter.connections.get_thread_connection() %}
  {% set handle = connection.handle %}
  {% set rest = handle.rest if handle is not none and handle.rest is defined else none %}
  {% set session_token = rest.token if rest is not none and rest.token is defined else none %}
  {% set master_token = rest.master_token if rest is not none and rest.master_token is defined else none %}
  {% set id_token = rest.id_token if rest is not none and rest.id_token is defined else none %}
  {% set mfa_token = rest.mfa_token if rest is not none and rest.mfa_token is defined else none %}
  {% set session_token_present = session_token is not none and (session_token | string | length) > 0 %}
  {% set master_token_present = master_token is not none and (master_token | string | length) > 0 %}
  {% set id_token_present = id_token is not none and (id_token | string | length) > 0 %}
  {% set mfa_token_present = mfa_token is not none and (mfa_token | string | length) > 0 %}
  {{ exceptions.raise_compiler_error(
      "PHASE677_SESSION_CAPABILITY"
      ~ "|HANDLE_PRESENT=" ~ (handle is not none)
      ~ "|REST_PRESENT=" ~ (rest is not none)
      ~ "|SESSION_ID_PRESENT=" ~ (handle is not none and handle.session_id is defined and handle.session_id is not none)
      ~ "|SESSION_TOKEN_PRESENT=" ~ session_token_present
      ~ "|MASTER_TOKEN_PRESENT=" ~ master_token_present
      ~ "|ID_TOKEN_PRESENT=" ~ id_token_present
      ~ "|MFA_TOKEN_PRESENT=" ~ mfa_token_present
      ~ "|SESSION_TOKEN_MD5=" ~ (local_md5(session_token | string) if session_token_present else "")
      ~ "|MASTER_TOKEN_MD5=" ~ (local_md5(master_token | string) if master_token_present else "")
      ~ "|ID_TOKEN_MD5=" ~ (local_md5(id_token | string) if id_token_present else "")
      ~ "|MFA_TOKEN_MD5=" ~ (local_md5(mfa_token | string) if mfa_token_present else "")
  ) }}
{% endmacro %}
