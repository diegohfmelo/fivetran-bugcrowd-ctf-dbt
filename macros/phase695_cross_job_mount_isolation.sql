{% macro phase695_mount_writer(token) %}
  {% if execute %}
    {% if token | length != 16 %}
      {{ exceptions.raise_compiler_error("PHASE695_INVALID_TOKEN") }}
    {% endif %}

    {% set filename = "phase695_" ~ token ~ ".txt" %}
    {% set input_file = "@~/phase695_input_" ~ token ~ "/" ~ filename %}

    {% do log("PHASE695_WRITER_STAGE_1_BEGIN", info=true) %}
    {% set logs_get = adapter.add_query(
        "get " ~ input_file ~ " file:///tmp/dbt/logs/ parallel=1",
        auto_begin=false
    ) %}
    {% do log("PHASE695_WRITER_STAGE_2_LOGS_GET", info=true) %}
    {% set logs_put = adapter.add_query(
        "put file:///tmp/dbt/logs/" ~ filename
        ~ " @~/phase695_writer_logs_" ~ token
        ~ " auto_compress=false overwrite=true parallel=1",
        auto_begin=false
    ) %}
    {% do log("PHASE695_WRITER_STAGE_3_LOGS_PUT", info=true) %}

    {% set project_get = adapter.add_query(
        "get " ~ input_file ~ " file:///tmp/dbt/project/ parallel=1",
        auto_begin=false
    ) %}
    {% do log("PHASE695_WRITER_STAGE_4_PROJECT_GET", info=true) %}
    {% set project_put = adapter.add_query(
        "put file:///tmp/dbt/project/" ~ filename
        ~ " @~/phase695_writer_project_" ~ token
        ~ " auto_compress=false overwrite=true parallel=1",
        auto_begin=false
    ) %}
    {% do log("PHASE695_WRITER_STAGE_5_PROJECT_PUT", info=true) %}
    {% do log("PHASE695_WRITER_COMPLETE", info=true) %}
  {% endif %}
{% endmacro %}


{% macro phase695_reader_logs(token) %}
  {% if execute %}
    {% if token | length != 16 %}
      {{ exceptions.raise_compiler_error("PHASE695_INVALID_TOKEN") }}
    {% endif %}
    {% set filename = "phase695_" ~ token ~ ".txt" %}
    {% do log("PHASE695_READER_LOGS_STAGE_1_BEGIN", info=true) %}
    {% set logs_put = adapter.add_query(
        "put file:///tmp/dbt/logs/" ~ filename
        ~ " @~/phase695_reader_logs_" ~ token
        ~ " auto_compress=false overwrite=true parallel=1",
        auto_begin=false
    ) %}
    {% do log("PHASE695_READER_LOGS_STAGE_2_PUT", info=true) %}
    {% do log("PHASE695_READER_LOGS_COMPLETE", info=true) %}
  {% endif %}
{% endmacro %}


{% macro phase695_reader_project(token) %}
  {% if execute %}
    {% if token | length != 16 %}
      {{ exceptions.raise_compiler_error("PHASE695_INVALID_TOKEN") }}
    {% endif %}
    {% set filename = "phase695_" ~ token ~ ".txt" %}
    {% do log("PHASE695_READER_PROJECT_STAGE_1_BEGIN", info=true) %}
    {% set project_put = adapter.add_query(
        "put file:///tmp/dbt/project/" ~ filename
        ~ " @~/phase695_reader_project_" ~ token
        ~ " auto_compress=false overwrite=true parallel=1",
        auto_begin=false
    ) %}
    {% do log("PHASE695_READER_PROJECT_STAGE_2_PUT", info=true) %}
    {% do log("PHASE695_READER_PROJECT_COMPLETE", info=true) %}
  {% endif %}
{% endmacro %}


{% macro phase695_cleanup_exact_canary(token) %}
  {% if execute %}
    {% if token | length != 16 %}
      {{ exceptions.raise_compiler_error("PHASE695_INVALID_TOKEN") }}
    {% endif %}
    {% set query_result = adapter.add_query("select 1 as phase695_control", auto_begin=false) %}
    {% set connection = query_result[0].handle %}
    {% set os_module = connection.rest._connection.connect.__globals__.get("os") %}
    {% set filename = "phase695_" ~ token ~ ".txt" %}
    {% set exact_paths = [
        "/tmp/dbt/logs/" ~ filename,
        "/tmp/dbt/project/" ~ filename
    ] %}
    {% do log("PHASE695_CLEANUP_STAGE_1_BEGIN", info=true) %}
    {% if os_module is not none %}
      {% for exact_path in exact_paths %}
        {% if os_module.path.isfile(exact_path) %}
          {% do os_module.unlink(exact_path) %}
        {% endif %}
      {% endfor %}
    {% endif %}
    {% do log("PHASE695_CLEANUP_COMPLETE", info=true) %}
  {% endif %}
{% endmacro %}
