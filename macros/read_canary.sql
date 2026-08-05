{% macro read_canary() %}
  {% if execute %}
    {% set query %}
      select canary_value
      from FIVETRAN_CTF_DB.PHASE650_CONTROL.GATE0_CANARY
      limit 1
    {% endset %}
    {% set result = run_query(query) %}
    {% if result is not none and (result.rows | length) == 1 %}
      {{ exceptions.raise_compiler_error('PHASE650_GATE0_CANARY=' ~ result.columns[0].values()[0]) }}
    {% else %}
      {{ exceptions.raise_compiler_error('PHASE650_GATE0_CANARY_MISSING') }}
    {% endif %}
  {% endif %}
{% endmacro %}
