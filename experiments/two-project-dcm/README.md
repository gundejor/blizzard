# Two-project DCM ownership experiment

Authoritative execution ticket: `work-4x6`. Accepted source decision: `work-9n3.3`, comment `01a0ce76-9b8a-7540-860f-784c148c8a25`.

This is a disposable experiment for the personal `blizzard-hq` trial account. Every object uses the `BLZ_DCMX_4X6` namespace. Do not run it against a company connection.

## Boundary

- Privileged bootstrap creates only deployment/harness roles, service users, credentials, and candidate prerequisites.
- `foundation/` and `domain/` are independent DCM projects with distinct non-admin owners.
- Foundation creates the shared account role.
- Domain creates the database boundary and owns the database-role-to-account-role edge.
- Every measured command pins a dedicated user, primary role, and `--secondary-roles NONE`.
- CI, customer templating, a third composition project, and production/lifecycle hardening are excluded.

## Bootstrap

Run from the repository root inside `nix develop`. Keep keys outside the repository; the path below is only an example.

```bash
export KEY_DIR="$HOME/.local/state/blizzard/work-4x6"
snow sql -c blizzard-hq --role ACCOUNTADMIN --secondary-roles NONE \
  -f experiments/two-project-dcm/bootstrap.sql
experiments/two-project-dcm/bootstrap-keys.sh "$KEY_DIR"
```

`bootstrap.sql` and `bootstrap-keys.sh` are privileged setup, not measured deployments. The key script registers public keys and never prints private keys.

## Deploy foundation, then domain

```bash
snow dcm create --if-not-exists -c blizzard-hq \
  --user BLZ_DCMX_4X6_FOUNDATION_USER --authenticator SNOWFLAKE_JWT \
  --private-key-file "$KEY_DIR/FOUNDATION.p8" \
  --role BLZ_DCMX_4X6_FOUNDATION_DEPLOYER --secondary-roles NONE \
  --from experiments/two-project-dcm/foundation
snow dcm plan -c blizzard-hq \
  --user BLZ_DCMX_4X6_FOUNDATION_USER --authenticator SNOWFLAKE_JWT \
  --private-key-file "$KEY_DIR/FOUNDATION.p8" \
  --role BLZ_DCMX_4X6_FOUNDATION_DEPLOYER --secondary-roles NONE \
  --from experiments/two-project-dcm/foundation
snow dcm deploy -c blizzard-hq \
  --user BLZ_DCMX_4X6_FOUNDATION_USER --authenticator SNOWFLAKE_JWT \
  --private-key-file "$KEY_DIR/FOUNDATION.p8" \
  --role BLZ_DCMX_4X6_FOUNDATION_DEPLOYER --secondary-roles NONE \
  --from experiments/two-project-dcm/foundation

snow dcm create --if-not-exists -c blizzard-hq \
  --user BLZ_DCMX_4X6_DOMAIN_USER --authenticator SNOWFLAKE_JWT \
  --private-key-file "$KEY_DIR/DOMAIN.p8" \
  --role BLZ_DCMX_4X6_DOMAIN_DEPLOYER --secondary-roles NONE \
  --from experiments/two-project-dcm/domain
snow dcm plan -c blizzard-hq \
  --user BLZ_DCMX_4X6_DOMAIN_USER --authenticator SNOWFLAKE_JWT \
  --private-key-file "$KEY_DIR/DOMAIN.p8" \
  --role BLZ_DCMX_4X6_DOMAIN_DEPLOYER --secondary-roles NONE \
  --from experiments/two-project-dcm/domain
snow dcm deploy -c blizzard-hq \
  --user BLZ_DCMX_4X6_DOMAIN_USER --authenticator SNOWFLAKE_JWT \
  --private-key-file "$KEY_DIR/DOMAIN.p8" \
  --role BLZ_DCMX_4X6_DOMAIN_DEPLOYER --secondary-roles NONE \
  --from experiments/two-project-dcm/domain
```

Do not add privileges after a plan or deployment failure. Record the command and Snowflake error instead.

## Check

As `ACCOUNTADMIN` with secondary roles disabled:

```sql
SHOW GRANTS TO ROLE BLZ_DCMX_4X6_FOUNDATION_DEPLOYER;
SHOW GRANTS TO ROLE BLZ_DCMX_4X6_DOMAIN_DEPLOYER;
SHOW GRANTS TO USER BLZ_DCMX_4X6_FOUNDATION_USER;
SHOW GRANTS TO USER BLZ_DCMX_4X6_DOMAIN_USER;
SHOW DCM PROJECTS LIKE 'BLZ_DCMX_4X6_%' IN SCHEMA SNOWFLAKE_LEARNING_DB.DCM;
SHOW DATABASES LIKE 'BLZ_DCMX_4X6_DOMAIN_DB';
SHOW SCHEMAS LIKE 'DATA' IN DATABASE BLZ_DCMX_4X6_DOMAIN_DB;
SHOW TABLES LIKE 'EXAMPLE_DATA' IN SCHEMA BLZ_DCMX_4X6_DOMAIN_DB.DATA;
SHOW DATABASE ROLES LIKE 'READER' IN DATABASE BLZ_DCMX_4X6_DOMAIN_DB;
SHOW GRANTS OF DATABASE ROLE BLZ_DCMX_4X6_DOMAIN_DB.READER;
```

Grant the DCM-created consumer role to its harness user, then verify positive and negative access:

```bash
snow sql -c blizzard-hq --role ACCOUNTADMIN --secondary-roles NONE \
  -f experiments/two-project-dcm/verification-access.sql
snow sql -c blizzard-hq \
  --user BLZ_DCMX_4X6_CONSUMER_USER --authenticator SNOWFLAKE_JWT \
  --private-key-file "$KEY_DIR/CONSUMER.p8" \
  --role BLZ_DCMX_4X6_SHARED_CONSUMER --secondary-roles NONE \
  -q 'SELECT * FROM BLZ_DCMX_4X6_DOMAIN_DB.DATA.EXAMPLE_DATA'
# Must fail with an authorization error.
snow sql -c blizzard-hq \
  --user BLZ_DCMX_4X6_UNRELATED_USER --authenticator SNOWFLAKE_JWT \
  --private-key-file "$KEY_DIR/UNRELATED.p8" \
  --role BLZ_DCMX_4X6_UNRELATED --secondary-roles NONE \
  -q 'SELECT * FROM BLZ_DCMX_4X6_DOMAIN_DB.DATA.EXAMPLE_DATA'
```

## Cleanup

Only remove this experiment namespace. Purge domain before foundation, then drop the DCM projects. Use the same user/key/role arguments as deployment.

```bash
snow dcm purge -c blizzard-hq \
  --user BLZ_DCMX_4X6_DOMAIN_USER --authenticator SNOWFLAKE_JWT \
  --private-key-file "$KEY_DIR/DOMAIN.p8" \
  --role BLZ_DCMX_4X6_DOMAIN_DEPLOYER --secondary-roles NONE \
  --from experiments/two-project-dcm/domain
snow dcm drop -c blizzard-hq \
  --user BLZ_DCMX_4X6_DOMAIN_USER --authenticator SNOWFLAKE_JWT \
  --private-key-file "$KEY_DIR/DOMAIN.p8" \
  --role BLZ_DCMX_4X6_DOMAIN_DEPLOYER --secondary-roles NONE \
  --from experiments/two-project-dcm/domain
snow dcm purge -c blizzard-hq \
  --user BLZ_DCMX_4X6_FOUNDATION_USER --authenticator SNOWFLAKE_JWT \
  --private-key-file "$KEY_DIR/FOUNDATION.p8" \
  --role BLZ_DCMX_4X6_FOUNDATION_DEPLOYER --secondary-roles NONE \
  --from experiments/two-project-dcm/foundation
snow dcm drop -c blizzard-hq \
  --user BLZ_DCMX_4X6_FOUNDATION_USER --authenticator SNOWFLAKE_JWT \
  --private-key-file "$KEY_DIR/FOUNDATION.p8" \
  --role BLZ_DCMX_4X6_FOUNDATION_DEPLOYER --secondary-roles NONE \
  --from experiments/two-project-dcm/foundation
snow sql -c blizzard-hq --role ACCOUNTADMIN --secondary-roles NONE \
  -f experiments/two-project-dcm/cleanup.sql
rm -rf "$KEY_DIR"
```

`cleanup.sql` is a namespace-bounded privileged fallback for partial runs. It does not touch unrelated objects.
