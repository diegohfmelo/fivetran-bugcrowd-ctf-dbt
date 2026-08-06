{% macro phase681_b_run_control() %}
  {% if execute %}
    {% set marker = env_var('DBT_PHASE681_MARKER', 'PHASE681_MARKER_UNSET') %}
    {% set result = run_query('select current_database() as database_name, current_user as user_name') %}
    {% if result is not none and (result.rows | length) == 1 %}
      {{ exceptions.raise_compiler_error('PHASE681_B_EXECUTION_MARKER=' ~ marker ~ '|QUERY_OK=true') }}
    {% else %}
      {{ exceptions.raise_compiler_error('PHASE681_B_EXECUTION_MARKER=' ~ marker ~ '|QUERY_OK=false') }}
    {% endif %}
  {% endif %}
{% endmacro %}
