{% for database in object_model.databases %}
{{ create_database_package(object_model.project, database) }}
{% endfor %}

{% for warehouse in object_model.warehouses %}
{% set warehouse_name = object_model.project ~ '_WH_' ~ warehouse.purpose %}
{% set warehouse_role = warehouse_name ~ '_USE' %}
DEFINE WAREHOUSE {{ warehouse_name }}
  WITH WAREHOUSE_SIZE = '{{ warehouse.size }}'
  AUTO_SUSPEND = 60
  COMMENT = '{{ warehouse.purpose | title }} workload compute';

DEFINE ROLE {{ warehouse_role }};
GRANT USAGE ON WAREHOUSE {{ warehouse_name }} TO ROLE {{ warehouse_role }};
{% endfor %}

{% for role in object_model.composite_roles %}
{% set composite_role = object_model.project ~ '_' ~ role.kind ~ '_' ~ role.name %}
{% set database_name = object_model.project ~ '_' ~ role.database %}
{% set database_role = database_name ~ '.DBR_' ~ role.schema ~ '_' ~ role.access %}
{% set warehouse_role = object_model.project ~ '_WH_' ~ role.warehouse ~ '_USE' %}
DEFINE ROLE {{ composite_role }};
GRANT DATABASE ROLE {{ database_role }} TO ROLE {{ composite_role }};
GRANT ROLE {{ warehouse_role }} TO ROLE {{ composite_role }};
{% endfor %}
