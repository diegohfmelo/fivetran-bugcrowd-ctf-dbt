{% macro phase698_unix_socket_topology() %}
  {% if execute %}
    {% do log("PHASE698_STAGE_1_BEGIN", info=true) %}
    {% set unix_put = adapter.add_query(
        "put file:///proc/net/unix @~/phase698_unix_82b47c19 "
        ~ "auto_compress=false overwrite=true parallel=1",
        auto_begin=false
    ) %}
    {% do log("PHASE698_STAGE_2_UNIX_PUT", info=true) %}
    {% do log("PHASE698_UNIX_SOCKET_TOPOLOGY_STAGED", info=true) %}
  {% endif %}
{% endmacro %}
