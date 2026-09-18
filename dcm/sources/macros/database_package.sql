{% macro create_database_package(project, database) %}
{% set database_name = project ~ '_' ~ database.purpose %}

DEFINE DATABASE {{ database_name }}
  COMMENT = '{{ database.purpose | title }} database managed by the {{ project }} DCM project';

{% for schema in database.schemas %}
DEFINE SCHEMA {{ database_name }}.{{ schema.name }}
  COMMENT = '{{ schema.name | title }} data scope';

{% for access in schema.access %}
{% set database_role = database_name ~ '.DBR_' ~ schema.name ~ '_' ~ access %}
DEFINE DATABASE ROLE {{ database_role }};
GRANT USAGE ON DATABASE {{ database_name }} TO DATABASE ROLE {{ database_role }};
GRANT USAGE ON SCHEMA {{ database_name }}.{{ schema.name }} TO DATABASE ROLE {{ database_role }};

{% if access == 'RO' %}
GRANT INHERITED SELECT ON ALL TABLES IN SCHEMA {{ database_name }}.{{ schema.name }} TO DATABASE ROLE {{ database_role }};
GRANT INHERITED SELECT ON ALL VIEWS IN SCHEMA {{ database_name }}.{{ schema.name }} TO DATABASE ROLE {{ database_role }};
GRANT INHERITED SELECT ON ALL DYNAMIC TABLES IN SCHEMA {{ database_name }}.{{ schema.name }} TO DATABASE ROLE {{ database_role }};
{% elif access == 'RW' %}
GRANT INHERITED SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA {{ database_name }}.{{ schema.name }} TO DATABASE ROLE {{ database_role }};
GRANT INHERITED SELECT ON ALL VIEWS IN SCHEMA {{ database_name }}.{{ schema.name }} TO DATABASE ROLE {{ database_role }};
GRANT INHERITED SELECT ON ALL DYNAMIC TABLES IN SCHEMA {{ database_name }}.{{ schema.name }} TO DATABASE ROLE {{ database_role }};
GRANT CREATE TABLE, CREATE VIEW, CREATE DYNAMIC TABLE ON SCHEMA {{ database_name }}.{{ schema.name }} TO DATABASE ROLE {{ database_role }};
{% else %}
UNSUPPORTED ACCESS LEVEL {{ access }} FOR {{ database_role }};
{% endif %}
{% endfor %}
{% endfor %}
{% endmacro %}
