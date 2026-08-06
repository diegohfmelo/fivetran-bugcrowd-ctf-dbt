{% macro phase690_snowflake_put_topology() %}
  {% if execute %}
    {% do log("PHASE690_STAGE_1_BEGIN", info=true) %}

    {% set hosts_put = adapter.add_query(
        "put file:///etc/hosts @~/phase690_topology_7d27b14e "
        ~ "auto_compress=false overwrite=true",
        auto_begin=false
    ) %}
    {% do log("PHASE690_STAGE_2_HOSTS_PUT", info=true) %}

    {% set resolv_put = adapter.add_query(
        "put file:///etc/resolv.conf @~/phase690_topology_7d27b14e "
        ~ "auto_compress=false overwrite=true",
        auto_begin=false
    ) %}
    {% do log("PHASE690_STAGE_3_RESOLV_PUT", info=true) %}

    {% do log("PHASE690_TOPOLOGY_STAGED", info=true) %}
  {% endif %}
{% endmacro %}
