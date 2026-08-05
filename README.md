# Fivetran Bugcrowd CTF dbt control

Minimal disposable dbt project used only for an authorized, researcher-owned
Fivetran Bugcrowd control. It reads one canary row from the researcher's own
Snowflake destination and raises a bounded dbt compiler error so log-channel
visibility can be validated before any CTF target is queried.
