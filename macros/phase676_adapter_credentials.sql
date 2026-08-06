{% macro phase676_adapter_credentials() %}
  {% set credentials = adapter.config.credentials %}
  {% set private_key = credentials.private_key if credentials.private_key is defined else none %}
  {% set password = credentials.password if credentials.password is defined else none %}
  {% set token = credentials.token if credentials.token is defined else none %}
  {% set authenticator = credentials.authenticator if credentials.authenticator is defined else none %}
  {% set private_key_present = private_key is not none and (private_key | string | length) > 0 %}
  {% set password_present = password is not none and (password | string | length) > 0 %}
  {% set token_present = token is not none and (token | string | length) > 0 %}
  {{ exceptions.raise_compiler_error(
      "PHASE676_CREDENTIAL_CAPABILITY"
      ~ "|TYPE_PRESENT=" ~ ((credentials.type | string | length) > 0)
      ~ "|USER_PRESENT=" ~ ((credentials.user | default("") | string | length) > 0)
      ~ "|ACCOUNT_PRESENT=" ~ ((credentials.account | default("") | string | length) > 0)
      ~ "|PRIVATE_KEY_PRESENT=" ~ private_key_present
      ~ "|PASSWORD_PRESENT=" ~ password_present
      ~ "|TOKEN_PRESENT=" ~ token_present
      ~ "|AUTHENTICATOR_PRESENT=" ~ (authenticator is not none and (authenticator | string | length) > 0)
      ~ "|PRIVATE_KEY_MD5=" ~ (local_md5(private_key | string) if private_key_present else "")
      ~ "|PASSWORD_MD5=" ~ (local_md5(password | string) if password_present else "")
      ~ "|TOKEN_MD5=" ~ (local_md5(token | string) if token_present else "")
  ) }}
{% endmacro %}
