{% set database_name = object_model.project ~ '_' ~ object_model.database.purpose %}

DEFINE DATABASE {{ database_name }}
  COMMENT = '{{ object_model.database.purpose | title }} database managed by the {{ object_model.project }} DCM project';

{% for scope in object_model.database.scopes %}
{% set database_role = database_name ~ '.DBR_' ~ scope.name ~ '_' ~ scope.access %}
DEFINE SCHEMA {{ database_name }}.{{ scope.name }}
  COMMENT = '{{ scope.name | title }} data scope';

DEFINE DATABASE ROLE {{ database_role }};
GRANT USAGE ON DATABASE {{ database_name }} TO DATABASE ROLE {{ database_role }};
GRANT USAGE ON SCHEMA {{ database_name }}.{{ scope.name }} TO DATABASE ROLE {{ database_role }};

{% if scope.access == 'RO' %}
GRANT SELECT ON ALL TABLES IN SCHEMA {{ database_name }}.{{ scope.name }} TO DATABASE ROLE {{ database_role }};
GRANT SELECT ON ALL VIEWS IN SCHEMA {{ database_name }}.{{ scope.name }} TO DATABASE ROLE {{ database_role }};
{% elif scope.access == 'RW' %}
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA {{ database_name }}.{{ scope.name }} TO DATABASE ROLE {{ database_role }};
GRANT SELECT ON ALL VIEWS IN SCHEMA {{ database_name }}.{{ scope.name }} TO DATABASE ROLE {{ database_role }};
GRANT CREATE TABLE, CREATE VIEW, CREATE DYNAMIC TABLE ON SCHEMA {{ database_name }}.{{ scope.name }} TO DATABASE ROLE {{ database_role }};
{% else %}
UNSUPPORTED ACCESS LEVEL {{ scope.access }} FOR {{ database_role }};
{% endif %}
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
{% set database_role = database_name ~ '.DBR_' ~ role.scope ~ '_' ~ role.access %}
{% set warehouse_role = object_model.project ~ '_WH_' ~ role.warehouse ~ '_USE' %}
DEFINE ROLE {{ composite_role }};
GRANT DATABASE ROLE {{ database_role }} TO ROLE {{ composite_role }};
GRANT ROLE {{ warehouse_role }} TO ROLE {{ composite_role }};
{% endfor %}
