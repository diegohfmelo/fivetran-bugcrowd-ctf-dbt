{% macro phase671_runtime_paths() %}
  {{ exceptions.raise_compiler_error(
      "PHASE671_DBT_VERSION=" ~ dbt_version
      ~ "|PROFILES_DIR=" ~ env_var("DBT_PROFILES_DIR", "")
      ~ "|FLAGS_PROFILES_DIR=" ~ (flags.PROFILES_DIR | default(""))
      ~ "|ARGS_PROFILES_DIR=" ~ (
          invocation_args_dict.get("profiles_dir", "")
          if invocation_args_dict is defined else ""
      )
      ~ "|PROJECT_DIR=" ~ (flags.PROJECT_DIR | default(""))
      ~ "|LOG_PATH=" ~ (flags.LOG_PATH | default(""))
      ~ "|TARGET_PATH=" ~ (flags.TARGET_PATH | default(""))
  ) }}
{% endmacro %}
