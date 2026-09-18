# Blizzard DCM project

DCM owns Snowflake objects in this repository. Terraform is reserved for AWS and other lower-level infrastructure.

```bash
snow dcm create --if-not-exists -c blizzard-hq
snow dcm plan -c blizzard-hq
snow dcm deploy -c blizzard-hq
```

Always review `plan` before `deploy`. `SNOWFLAKE_LEARNING_DB.DCM` is the manually bootstrapped container for the DCM Project itself; DCM manages the declared objects.

The model uses DCM inherited grants so access applies to current and future
objects. This opt-in Snowflake feature must be enabled once by `ACCOUNTADMIN`
before deployment:

```sql
ALTER ACCOUNT SET FEATURE_RBAC_INHERITED_GRANTS = 'ENABLED';
```

Inherited grants are currently a Public Preview feature.

## Object model

`manifest.yml` contains the canonical `object_model` declaration. The global
Jinja macro in `sources/macros/database_package.sql` defines the reusable
database, schema, primitive-role, and grant pattern. The definition in
`sources/definitions/object_model.sql` invokes that macro for every declared
database, then creates warehouses and composes account roles.

The declaration produces independent database packages:

```text
BLZ_ANALYTICS
├── TRANSFORM
│   └── DBR_TRANSFORM_RW
└── REPORTING
    └── DBR_REPORTING_RO

BLZ_FINANCE
├── TRANSFORM
│   └── DBR_TRANSFORM_RW
└── REPORTING
    └── DBR_REPORTING_RO
```

Add another entry under `object_model.databases` to create another package from
the same SQL. Each schema may request one or more supported access levels. Add
composite roles separately so their database, schema, access, and warehouse
relationships remain explicit.

`RO` grants inherited read access to current and future tables, views, and
dynamic tables. `RW` additionally grants inherited table DML and schema
privileges to create tables, views, and dynamic tables; objects created by the
dbt role remain owned by that role in this sandbox model.

- [DCM Projects](https://docs.snowflake.com/en/user-guide/dcm-projects/dcm-projects-overview)
- [Snowflake CLI DCM commands](https://docs.snowflake.com/en/developer-guide/snowflake-cli/data-pipelines/dcm-projects)
- [Supported entities](https://docs.snowflake.com/en/user-guide/dcm-projects/dcm-projects-supported-entities)
