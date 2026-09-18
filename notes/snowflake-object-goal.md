# Snowflake object composition goal

## Goal

Build a small Snowflake object model reproducibly from reusable naming and
composition rules. The prototype should demonstrate how primitive access roles
become building blocks for human and service roles; it is not intended to be a
complete production access architecture.

The implementation must not rely on a collection of unrelated, manually
constructed names. It should accept the meaningful parts of an object—such as
project namespace, purpose, scope, and access level—and consistently produce
the Snowflake objects and grants that follow the agreed patterns.

## Target object model

The first concrete example is an analytics database with separate transformation
and reporting workloads:

```text
BLZ_ANALYTICS
├── TRANSFORM
└── REPORTING

BLZ_SVC_DBT_TRANSFORM
├── BLZ_ANALYTICS.DBR_TRANSFORM_RW
└── BLZ_WH_TRANSFORM_USE

BLZ_FR_ANALYST
├── BLZ_ANALYTICS.DBR_REPORTING_RO
└── BLZ_WH_REPORTING_USE
```

It requires these account-level objects:

| Object | Purpose |
| --- | --- |
| `BLZ_ANALYTICS` | Database containing the analytics model |
| `BLZ_WH_TRANSFORM` | Compute for transformation workloads |
| `BLZ_WH_REPORTING` | Compute for reporting workloads |
| `BLZ_WH_TRANSFORM_USE` | Primitive permission to use transformation compute |
| `BLZ_WH_REPORTING_USE` | Primitive permission to use reporting compute |
| `BLZ_SVC_DBT_TRANSFORM` | Composite role for the dbt workload |
| `BLZ_FR_ANALYST` | Composite role for human analysts |

The database supplies the namespace for its schemas and database roles, so
`BLZ` is not repeated inside those names.

## Naming patterns

| Object | Pattern | Example |
| --- | --- | --- |
| Database | `<PROJECT>_<PURPOSE>` | `BLZ_ANALYTICS` |
| Schema | `<SCOPE>` | `REPORTING` |
| Warehouse | `<PROJECT>_WH_<PURPOSE>` | `BLZ_WH_REPORTING` |
| Database role | `<DATABASE>.DBR_<SCOPE>_<ACCESS>` | `BLZ_ANALYTICS.DBR_REPORTING_RO` |
| Warehouse usage role | `<PROJECT>_WH_<PURPOSE>_USE` | `BLZ_WH_REPORTING_USE` |
| Functional role | `<PROJECT>_FR_<FUNCTION>` | `BLZ_FR_ANALYST` |
| Service role | `<PROJECT>_SVC_<SYSTEM>_<PURPOSE>` | `BLZ_SVC_DBT_TRANSFORM` |

Names use uppercase snake case and unquoted Snowflake identifiers. Components
should describe durable purpose rather than a person, temporary initiative, or
repository location.

## Reproducibility requirements

The prototype is successful when:

1. One canonical declaration describes the meaningful object components and
   role composition.
2. Names and grants are derived consistently from that declaration rather than
   repeated independently throughout the code.
3. The same declaration produces the same DCM plan repeatedly.
4. Adding another schema, workload, or composite role follows the same pattern
   without copying and editing an entire implementation.
5. Invalid or incomplete declarations fail before deployment where the chosen
   tooling can reasonably validate them.
6. A human can inspect the generated Snowflake objects and understand why each
   role receives its privileges.

Use the simplest mechanism compatible with DCM. Do not introduce a framework or
new dependency unless plain project features cannot express these requirements.

## Initial boundaries

The first iteration will not attempt to solve:

- user or identity-provider assignment;
- entitlement and administrative roles;
- multiple environments;
- row-access or masking policies;
- production break-glass access;
- a complete ownership model; or
- deployment without explicit review and approval of the DCM plan.

The exact privilege contract for `DBR_TRANSFORM_RW`, especially object creation
and ownership required by dbt, remains an implementation question. It should be
made explicit before that role is deployed rather than hidden behind the `RW`
suffix.
