# Blizzard DCM project

DCM owns Snowflake objects in this repository. Terraform is reserved for AWS and other lower-level infrastructure.

```bash
snow dcm create --if-not-exists -c blizzard-hq
snow dcm plan -c blizzard-hq
snow dcm deploy -c blizzard-hq
```

Always review `plan` before `deploy`. `SNOWFLAKE_LEARNING_DB.DCM` is the manually bootstrapped container for the DCM Project itself; DCM manages the declared objects.

## Object model

`manifest.yml` contains the canonical `object_model` declaration. The Jinja in
`sources/definitions/object_model.sql` derives object names, definitions, grants,
and role composition from it.

The initial declaration produces:

```text
BLZ_SVC_DBT_TRANSFORM
├── BLZ_ANALYTICS.DBR_TRANSFORM_RW
└── BLZ_WH_TRANSFORM_USE

BLZ_FR_ANALYST
├── BLZ_ANALYTICS.DBR_REPORTING_RO
└── BLZ_WH_REPORTING_USE
```

Add scopes, workloads, and composite roles in the manifest rather than copying
SQL definitions. `RO` grants read access. `RW` additionally grants table DML and
schema privileges to create tables, views, and dynamic tables; objects created
by the dbt role remain owned by that role in this sandbox model.

- [DCM Projects](https://docs.snowflake.com/en/user-guide/dcm-projects/dcm-projects-overview)
- [Snowflake CLI DCM commands](https://docs.snowflake.com/en/developer-guide/snowflake-cli/data-pipelines/dcm-projects)
- [Supported entities](https://docs.snowflake.com/en/user-guide/dcm-projects/dcm-projects-supported-entities)
