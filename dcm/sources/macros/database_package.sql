{% macro create_database_package(project, database) %}
{% set database_name = project ~ '_' ~ database.purpose %}
{% set ro_role = database_name ~ '.DBR_ALL_RO' %}
{% set rw_role = database_name ~ '.DBR_ALL_RW' %}

DEFINE DATABASE {{ database_name }}
  COMMENT = '{{ database.purpose | title }} database managed by the {{ project }} DCM project';

DEFINE DATABASE ROLE {{ ro_role }};
DEFINE DATABASE ROLE {{ rw_role }};
GRANT USAGE ON DATABASE {{ database_name }} TO DATABASE ROLE {{ ro_role }};
GRANT USAGE ON DATABASE {{ database_name }} TO DATABASE ROLE {{ rw_role }};

{% for schema in database.schemas %}
DEFINE SCHEMA {{ database_name }}.{{ schema }}
  COMMENT = '{{ schema | title }} data scope';

GRANT USAGE ON SCHEMA {{ database_name }}.{{ schema }} TO DATABASE ROLE {{ ro_role }};
GRANT USAGE ON SCHEMA {{ database_name }}.{{ schema }} TO DATABASE ROLE {{ rw_role }};
GRANT CREATE TABLE, CREATE VIEW, CREATE DYNAMIC TABLE ON SCHEMA {{ database_name }}.{{ schema }} TO DATABASE ROLE {{ rw_role }};
{% endfor %}

GRANT INHERITED SELECT ON ALL TABLES IN DATABASE {{ database_name }} TO DATABASE ROLE {{ ro_role }};
GRANT INHERITED SELECT ON ALL VIEWS IN DATABASE {{ database_name }} TO DATABASE ROLE {{ ro_role }};
GRANT INHERITED SELECT ON ALL DYNAMIC TABLES IN DATABASE {{ database_name }} TO DATABASE ROLE {{ ro_role }};

GRANT INHERITED SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN DATABASE {{ database_name }} TO DATABASE ROLE {{ rw_role }};
GRANT INHERITED SELECT ON ALL VIEWS IN DATABASE {{ database_name }} TO DATABASE ROLE {{ rw_role }};
GRANT INHERITED SELECT ON ALL DYNAMIC TABLES IN DATABASE {{ database_name }} TO DATABASE ROLE {{ rw_role }};
{% endmacro %}
