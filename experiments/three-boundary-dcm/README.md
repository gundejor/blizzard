# Three-boundary DCM verification contract

**Proposed, unexecuted, not approved.** Documentation only; no live action now. Implements Chart `rvn-9n3` comment `01a0d33c-390e-7a60-aad2-5e1fc7b9ab55` with accepted candidate `rvn-9n3.5` at Gondolin library commit `8c026bd`. Blizzard commit `630708c` supports only observed two-project mechanics: projects in `SNOWFLAKE_LEARNING_DB.DCM`, container grants, non-admin deployment, implicit `PUBLIC`, positive/negative access checks; not this sequence or privilege envelope.

## Authority and scope

- **Agent:** if separately authorized, may run **only** `snow dcm plan`. No SQL, scripts, SDKs, `snow dcm create`, `deploy`, `purge`, `drop`, or other commands.
- **Jørgen Bjørdal:** handles privileged bootstrap, project creation, human-run DCM deployment, verification setup/checks, and cleanup.
- **Missing or uncertain state:** any project, container, object, identity, credential, role, grant, or privilege is a human prerequisite and a stop. Agents must not create, repair, retry, or broaden access.

Out of scope: company accounts/repositories, CI, production hardening, identity lifecycle, shared-warehouse policy, broader DCM lifecycle, implementation, and external research.

## Names and scope

Use only these inputs:

| Input | Value | Treatment |
| --- | --- | --- |
| `NAMESPACE` | `BLZ_DCMX_0M6` | disposable namespace |
| `CONTROL_DATABASE` | `SNOWFLAKE_LEARNING_DB` | retained external input; never derived or cleaned |
| `CONTROL_SCHEMA` | `DCM` | retained external input; never derived or cleaned |
| `CONTROL_WAREHOUSE` | `COMPUTE_WH` | retained external input; never derived or cleaned |

Naming rules for the exact inventory below:

- Form disposable account-scoped identifiers and project/database-role local names from unquoted uppercase `NAMESPACE` + `_` + the inventory's semantic suffix. `DHUB`/`DWH` are fixed domain suffixes, not configurable layers.
- `DATA`, `SOURCE`, and implicit `PUBLIC` are fixed schema/table local names.
- Review schemas and database roles as `DATABASE.LOCAL_NAME`; use `DATABASE.SCHEMA.OBJECT` only for schema-contained objects.

For supported future DCM definition contexts, use inputs rather than literals:

- Use Jinja2 `{{ variable }}` from `manifest.yml` `templating.defaults` or target `templating.configurations`. Precedence is defaults → selected configuration → plan-time `--variable`/`-D`. SQL runtime overrides are documented too.
- DCM substitution is unproven for manifest project/target identifiers and for human bootstrap, harness, or cleanup. Use reviewed names directly there. No custom renderer, naming code, manifest, or script.

Snowflake [identifier requirements](https://docs.snowflake.com/en/sql-reference/identifiers-syntax) (retrieved 2026-09-25 UTC): unquoted names start with an ASCII letter or underscore, then use only letters, underscores, decimal digits, or dollar signs; they are stored/resolved uppercase. Quoted names preserve case, allow other characters, and normally require exact references. Both have a 255-character limit. Uppercase here is local, not a universal best practice.

[DCM project files/templating](https://docs.snowflake.com/en/user-guide/dcm-projects/dcm-projects-files), [plan options](https://docs.snowflake.com/en/developer-guide/snowflake-cli/command-reference/dcm-commands/plan), and [`EXECUTE DCM PROJECT`](https://docs.snowflake.com/en/sql-reference/sql/execute-dcm-project) (retrieved 2026-09-25 UTC) document those mechanics, not Snowflake CLI's separate project-template syntax for DCM definitions; none is used.

### Exact disposable inventory

In the existing personal Blizzard account, Jørgen must approve one deterministic resolved inventory with full database/schema qualification and retained inputs before collision checks, plan review, or cleanup. This example is **blocked** until separate stage-state reconciliation is reviewed and approved. Cleanup uses only approved exact names, never prefix wildcards.

| Class | Proposed inventory |
| --- | --- |
| ownership/deployment | account roles `BLZ_DCMX_0M6_OWN_DHUB`, `BLZ_DCMX_0M6_OWN_DWH`; service users `BLZ_DCMX_0M6_DEPLOY_DHUB`, `BLZ_DCMX_0M6_DEPLOY_DWH`; their one-role assignments and credentials |
| DCM control | projects `SNOWFLAKE_LEARNING_DB.DCM.BLZ_DCMX_0M6_PROJECT_DHUB`, `SNOWFLAKE_LEARNING_DB.DCM.BLZ_DCMX_0M6_PROJECT_DWH`, owned by matching ownership roles |
| DHUB desired state | roles `BLZ_DCMX_0M6_DHUB_FUNCTIONAL`, `BLZ_DCMX_0M6_DHUB_SERVICE`, `BLZ_DCMX_0M6_DHUB_WH_INTERACTIVE_USAGE`, `BLZ_DCMX_0M6_DHUB_WH_SERVICE_USAGE`; warehouses `BLZ_DCMX_0M6_DHUB_WH_INTERACTIVE`, `BLZ_DCMX_0M6_DHUB_WH_SERVICE`; database `BLZ_DCMX_0M6_DHUB_DB`; requested schema `BLZ_DCMX_0M6_DHUB_DB.DATA`; table `BLZ_DCMX_0M6_DHUB_DB.DATA.SOURCE`; database role `BLZ_DCMX_0M6_DHUB_DB.BLZ_DCMX_0M6_SOURCE_READER` |
| DWH desired state | roles `BLZ_DCMX_0M6_DWH_FUNCTIONAL`, `BLZ_DCMX_0M6_DWH_SERVICE`, `BLZ_DCMX_0M6_DWH_WH_INTERACTIVE_USAGE`, `BLZ_DCMX_0M6_DWH_WH_SERVICE_USAGE`; warehouses `BLZ_DCMX_0M6_DWH_WH_INTERACTIVE`, `BLZ_DCMX_0M6_DWH_WH_SERVICE`; database `BLZ_DCMX_0M6_DWH_DB`; requested schema `BLZ_DCMX_0M6_DWH_DB.DATA` |
| cross-domain edge | DHUB grants `BLZ_DCMX_0M6_DHUB_DB.BLZ_DCMX_0M6_SOURCE_READER` to existing `BLZ_DCMX_0M6_DWH_SERVICE`; ownership stays put |
| human verification harness | service users `BLZ_DCMX_0M6_VERIFY_CONSUMERS`, `BLZ_DCMX_0M6_VERIFY_UNRELATED`; role `BLZ_DCMX_0M6_UNRELATED`; all four functional/service roles assigned to `BLZ_DCMX_0M6_VERIFY_CONSUMERS`, unrelated role to `BLZ_DCMX_0M6_VERIFY_UNRELATED`; temporary `USAGE` on `BLZ_DCMX_0M6_DWH_WH_SERVICE` to unrelated role; credentials and local key material |

`SNOWFLAKE_LEARNING_DB`, its `DCM` schema, and `COMPUTE_WH` are retained external prerequisites: neither project owns, replaces, alters, or cleans them.

Expected implicit `BLZ_DCMX_0M6_DHUB_DB.PUBLIC` and `BLZ_DCMX_0M6_DWH_DB.PUBLIC` are check/cleanup inventory within disposable databases, **not** requested domain schemas; there is no permission to mutate system-managed `PUBLIC`. Only `.DATA` is requested.

Reviewed `rvn-hyr` findings still need separate reconciliation before execution: **Does each project create schema-local stage state beyond its named project record, what exact identifiers will inspection show, and is that state removed by project deletion?** Add any separately retained object to the exact inventory before execution. Until answered, stop; do not adopt researched cleanup patterns here.

Every disposable warehouse: `XSMALL`, initially suspended, auto-resume on, 60-second auto-suspend. Test settings, not standards. This smallest shape (one database/domain, one role/consumer category) does not settle permanent database count or workload subdivisions.

## Proposed permissions

**Proposal, neither proven sufficient nor minimum.** The prior local experiment observed the control-access envelope, not its sufficiency or minimality here.

- Each ownership role gets account `CREATE DATABASE`, `CREATE ROLE`, and `CREATE WAREHOUSE`; `USAGE` on the retained control database and schema; `CREATE DCM PROJECT` and `CREATE STAGE` on the control schema; and `USAGE` on the retained control warehouse. These are its only proposed control-container/account grants.
- Declaration-created ownership is proposed to cover each role's own database, requested schema, database roles, warehouses, account roles, and grants. Ownership/deployment sessions use no global `MANAGE GRANTS`, admin/system role, other domain ownership role, or secondary-role assistance.
- Each domain grants interactive warehouse `USAGE` to its interactive-usage role, then that role to its functional role; it grants service warehouse `USAGE` to its service-usage role, then that role to its service role. Consumer functional/service roles get no other compute category. Ownership roles necessarily own both domain warehouses and are outside that consumer claim.
- DHUB grants database and `DATA` schema `USAGE`, and `SOURCE` table `SELECT`, to `BLZ_DCMX_0M6_DHUB_DB.BLZ_DCMX_0M6_SOURCE_READER`; it grants that database role to already-existing `BLZ_DCMX_0M6_DWH_SERVICE`. This is the only proposed data-access edge. Neither functional role nor `BLZ_DCMX_0M6_DHUB_SERVICE` is intended to have data access; the harness does not test their effective denial.

If project creation, planning, deployment, or inspection needs another role relationship or privilege, stop and report the exact error or missing prerequisite. Jørgen must revise and reapprove before broadening.

The candidate's platform-owner permission, empty DWH local-reader permission, and dependent-view/object-creation permission remain **deferred**, not rejected or reversed. Their inert roles, empty object, optional view, and dependent release are also deferred and absent here.

## Execution sequence: complete desired states

Each stage retains earlier declarations; these are complete states, not deltas. Only Jørgen creates projects and runs deployments; only those human-run deployments create domain objects, roles, and grants.

1. **Human bootstrap and project creation:** Jørgen uses privileged administration for the approved prerequisites: matching ownership roles, deployment users/credentials, exact control-container/account grants, and one-role assignments. Under each matching non-admin ownership role, he creates the fully qualified project.
2. **Independent bases:** DHUB and DWH may be planned and human-deployed in either order. Each state retains every listed domain object, local compute grant, and role composition; DWH creates and retains `BLZ_DCMX_0M6_DWH_SERVICE`.
3. **Boundary release:** After **both** bases, DHUB retains its entire base and adds the source-reader-to-DWH-service edge. DWH remains unchanged; there is no optional dependent-object release.
4. **Verification readiness:** After both bases and boundary deployment, Jørgen sets up harness assignments, temporary unrelated-role warehouse `USAGE`, and any source row needed for a meaningful result. This is privileged human setup, not domain desired state or DCM-grant evidence. Assignments pin one primary consumer role per check with secondary roles disabled; the temporary grant gives the unrelated role usable DWH compute for data-denial testing. Runtime data is neither a deployment prerequisite nor proof of success.

No stage omits earlier declarations or depends on an unlisted project, object, ownership transfer, manual repair, or grant.

## Evidence and human checkpoints

### Agent plans

- **Every approved stage:** retain sanitized pre-deploy plan with pinned deployment user, primary ownership role, secondary roles disabled, fully qualified project, stage, planned creates/grants/removals, exit status, tool version, UTC time.
- **Pre-deploy gate:** no unexpected removal, replacement, ownership transfer, unrelated/deferred object, or privilege broadening.
- **After each reported human deployment:** run the **same approved `snow dcm plan`** as no-change replan. Require exit zero and empty plan; otherwise preserve sanitized output, report exactly, stop—never claim success or repair/retry.

Plans show DCM proposals against then-current state, not creation, ownership, deployment success, direct grants, effective access, compute choice, query result, denial, or cleanup.

### Human checks

Jørgen captures separate inspection/runtime evidence:

- **Owners/direct edges:** actual owners of both projects and every disposable role, database, requested/implicit schema, warehouse, database role, table; direct warehouse→usage-role→consumer-role and DHUB object→database-role→DWH-service grants; direct absence of global `MANAGE GRANTS` and unintended role inheritance. Direct grant rows do not prove effective access.
- **Positive data path:** as `BLZ_DCMX_0M6_VERIFY_CONSUMERS`, primary `BLZ_DCMX_0M6_DWH_SERVICE`, secondary roles disabled, warehouse `BLZ_DCMX_0M6_DWH_WH_SERVICE`, `SELECT` from `BLZ_DCMX_0M6_DHUB_DB.DATA.SOURCE` succeeds. Record active role/warehouse; this proves that session's effective path, not just a direct grant.
- **Compute separation:** four separately pinned sessions: each functional role uses its domain interactive warehouse and is denied its service warehouse; each service role uses its domain service warehouse and is denied its interactive warehouse. Record successful active-warehouse checks and authorization failures; ownership-role behavior proves nothing about consumer separation.
- **Unrelated denial:** as `BLZ_DCMX_0M6_VERIFY_UNRELATED`, primary `BLZ_DCMX_0M6_UNRELATED`, secondary roles disabled, temporary DWH service-warehouse access: same source `SELECT` fails for data authorization. Record nonzero exit/error; absence of compute is not data denial.

These human-run checks require separate authorization; **not now**.

### Checkpoints and stops

1. Before live action: independent review and Jørgen approval of contract, exact names, unresolved stage mechanic, privileges, evidence handling, cleanup.
2. Before each initial base plan Jørgen confirms named project/control prerequisites; before each replan or dependent plan, prior human deployment too. After each plan he decides whether it matches; only he creates/deploys.
3. Before verification: Jørgen authorizes/creates exact harness. After sanitizing and committing evidence: he authorizes exact-inventory cleanup or records retention reason, owner, deadline, and eventual cleanup result.

**Stop** on initial disposable-name collision, unexpected identifier for stage, absent prerequisite, unexpected object/change/removal/ownership transfer, privilege request, plan or replan error, evidence leak, namespace escape, or actual/approved-state mismatch. Preserve sanitized context; require new human checkpoint before retry.

### Evidence hygiene and cleanup

Commit only claim-relevant rows, tool version, UTC time, stage, exact identifiers, actor category, exit status. Exclude credentials, keys, tokens, account locators, personal paths, connection configuration, raw transcripts, unrelated account metadata.

Jørgen cleans up in dependency-safe order, using only the approved exact inventory:

1. Remove harness assignments and the temporary warehouse grant.
2. Remove harness users, role, credentials, and keys.
3. Remove the domain cross-edge and DCM-managed objects. Dropping disposable databases includes requested `DATA` and implicit `PUBLIC`.
4. Remove both fully qualified projects and any resolved project-owned stage state.
5. Remove deployment users, credentials, and keys.
6. Remove ownership roles.

Never alter retained `SNOWFLAKE_LEARNING_DB`, `SNOWFLAKE_LEARNING_DB.DCM`, or `COMPUTE_WH`. Partial execution needs the same bounded human cleanup and a recorded result; agents never clean up.
