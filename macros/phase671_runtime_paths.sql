{% macro phase671_runtime_paths() %}
  {{ exceptions.raise_compiler_error(
      "PHASE671_DBT_VERSION=" ~ dbt_version
      ~ "|PROFILES_DIR=" ~ env_var("DBT_PROFILES_DIR", "")
      ~ "|PROJECT_DIR=" ~ (flags.PROJECT_DIR | default(""))
      ~ "|LOG_PATH=" ~ (flags.LOG_PATH | default(""))
      ~ "|TARGET_PATH=" ~ (flags.TARGET_PATH | default(""))
  ) }}
{% endmacro %}
