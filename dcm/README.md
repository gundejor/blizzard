# Blizzard DCM project

DCM owns Snowflake objects in this repository. Terraform is reserved for AWS and other lower-level infrastructure.

```bash
snow dcm create --if-not-exists -c blizzard-hq
snow dcm plan -c blizzard-hq
snow dcm deploy -c blizzard-hq
```

Always review `plan` before `deploy`. `SNOWFLAKE_LEARNING_DB.DCM` is the manually bootstrapped container for the DCM Project itself; DCM manages the declared objects.

- [DCM Projects](https://docs.snowflake.com/en/user-guide/dcm-projects/dcm-projects-overview)
- [Snowflake CLI DCM commands](https://docs.snowflake.com/en/developer-guide/snowflake-cli/data-pipelines/dcm-projects)
- [Supported entities](https://docs.snowflake.com/en/user-guide/dcm-projects/dcm-projects-supported-entities)
