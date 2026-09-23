# Observed result — work-4x6

Observed in the personal Blizzard trial account on 2026-09-23 with Snowflake CLI 3.27.0. These are sandbox observations, not a production architecture decision.

## Checks

| Check | Result | Evidence |
|---|---|---|
| Distinct non-admin deployment roles, no effective global `MANAGE GRANTS` | Pass | Foundation and domain create/plan/deploy succeeded as dedicated service users with primary roles `BLZ_DCMX_4X6_FOUNDATION_DEPLOYER` and `BLZ_DCMX_4X6_DOMAIN_DEPLOYER`, always with secondary roles `NONE`. `SHOW GRANTS TO ROLE` contained no `MANAGE GRANTS`; `SHOW GRANTS TO USER` showed each deployment user held only its corresponding role. |
| Domain ownership | Pass | `SHOW` reported the domain DCM project, database, managed-access `DATA` schema, `EXAMPLE_DATA` table, database role, and implicit database `PUBLIC` schema owned by `BLZ_DCMX_4X6_DOMAIN_DEPLOYER`. The foundation DCM project and shared role were owned by the foundation deployer. |
| Consumer `SELECT` | Pass | With user `BLZ_DCMX_4X6_CONSUMER_USER`, primary role `BLZ_DCMX_4X6_SHARED_CONSUMER`, and secondary roles empty, `SELECT * FROM BLZ_DCMX_4X6_DOMAIN_DB.DATA.EXAMPLE_DATA` succeeded and returned no rows. |
| Unrelated-role `SELECT` denied | Pass | With user `BLZ_DCMX_4X6_UNRELATED_USER`, primary role `BLZ_DCMX_4X6_UNRELATED`, and secondary roles empty, the same query exited 1 with `002003 (02000): Database 'BLZ_DCMX_4X6_DOMAIN_DB' does not exist or not authorized.` |

The domain DCM deployment successfully managed `USAGE` on the database/schema and `SELECT` on the table to `BLZ_DCMX_4X6_DOMAIN_DB.READER`, then granted that database role to the foundation-created account role. No global `MANAGE GRANTS` was granted.

## Exact setup/plan failures retained

1. The first bootstrap file redundantly issued `USE SECONDARY ROLES NONE` inside a CLI restricted session. It stopped before object creation with `003107 (42501): Current session is restricted. USE ROLE not allowed.` The fix removed in-file role switching; all invocations still pin `--role` and `--secondary-roles NONE`.
2. The configured `realmwork` PAT is restricted to `ACCOUNTADMIN`. Connecting as the foundation role failed before DCM creation with `390186 (08001): Role 'BLZ_DCMX_4X6_FOUNDATION_DEPLOYER' ... is not granted to this user, or is not permitted for the credentials being used.` Creating another role-restricted PAT while authenticated by that PAT failed with `099413 (38002)` for the same user and `099421 (22023)`/`099420 (22023)` for incompatible or omitted restrictions. The non-broadening fix used experiment-only, one-role service users with temporary key-pair authentication.
3. The first domain plan used reserved table name `SAMPLE`. DCM render stopped before managed-object mutation with `001003/1003` and `unexpected 'SAMPLE'`. Renaming only the disposable table to `EXAMPLE_DATA` made plan and deployment succeed.

## Limits and cleanup state

- Snowflake/DCM also managed the new database's implicit `PUBLIC` schema; this was not a second requested domain schema.
- The test proves this exact two-project positive path and one unrelated-role denial only. It does not establish customer templating, a third composition project, exhaustive role/lifecycle behavior, CI, or production readiness.
- Experiment objects are intentionally retained for acceptance inspection. Follow [README.md](README.md#cleanup) to remove only the `BLZ_DCMX_4X6` namespace after review.
