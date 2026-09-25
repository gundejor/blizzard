# Three-boundary DCM verification contract

**Proposed, unexecuted, not approved.** Documentation only; no live action now. Implements Chart `rvn-9n3` comment `01a0d33c-390e-7a60-aad2-5e1fc7b9ab55` with accepted candidate `rvn-9n3.5` at Gondolin library commit `8c026bd`. Blizzard commit `630708c` supports only observed two-project mechanics at the historical experiment location `SNOWFLAKE_LEARNING_DB.DCM`: container grants, non-admin deployment, implicit `PUBLIC`, and positive/negative access checks; not the current type or state of that location, this sequence, or this privilege envelope. That location is provenance only and is not reused or inspected.

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
| `CONTROL_DATABASE` | `BLZ_DCMX_0M6_CONTROL_DB` | disposable; `NAMESPACE` + `_CONTROL_DB` |
| `CONTROL_SCHEMA` | `BLZ_DCMX_0M6_CONTROL` | disposable; `NAMESPACE` + `_CONTROL` |
| `CONTROL_WAREHOUSE` | `COMPUTE_WH` | retained external input; never derived or cleaned |

Naming rules for the exact inventory below:

- Form disposable account-scoped identifiers and project, schema, and database-role local names from unquoted uppercase `NAMESPACE` + `_` + the inventory's semantic suffix. `DHUB`/`DWH` are fixed domain suffixes, not configurable layers.
- `DATA` and `SOURCE` are fixed domain schema/table local names; implicit `PUBLIC` is a fixed schema local name.
- Review schemas and database roles as `DATABASE.LOCAL_NAME`; use `DATABASE.SCHEMA.OBJECT` only for schema-contained objects.

For supported future DCM definition contexts, use inputs rather than literals:

- Use Jinja2 `{{ variable }}` from `manifest.yml` `templating.defaults` or target `templating.configurations`. Precedence is defaults → selected configuration → plan-time `--variable`/`-D`. SQL runtime overrides are documented too.
- DCM substitution is unproven for manifest project/target identifiers and for human bootstrap, harness, or cleanup. Use reviewed names directly there. No custom renderer, naming code, manifest, or script.

Snowflake [identifier requirements](https://docs.snowflake.com/en/sql-reference/identifiers-syntax) (retrieved 2026-09-25 UTC): unquoted names start with an ASCII letter or underscore, then use only letters, underscores, decimal digits, or dollar signs; they are stored/resolved uppercase. Quoted names preserve case, allow other characters, and normally require exact references. Both have a 255-character limit. Uppercase here is local, not a universal best practice.

[DCM project files/templating](https://docs.snowflake.com/en/user-guide/dcm-projects/dcm-projects-files), [plan options](https://docs.snowflake.com/en/developer-guide/snowflake-cli/command-reference/dcm-commands/plan), and [`EXECUTE DCM PROJECT`](https://docs.snowflake.com/en/sql-reference/sql/execute-dcm-project) (retrieved 2026-09-25 UTC) document those mechanics, not Snowflake CLI's separate project-template syntax for DCM definitions; none is used.

### Exact disposable inventory

In the existing personal Blizzard account, Jørgen must approve one deterministic resolved inventory with full database/schema qualification and retained inputs before collision checks, plan review, or cleanup. Before bootstrap he checks every account-scoped name below for collision. After creating `BLZ_DCMX_0M6_CONTROL_DB`, he inspects expected implicit `BLZ_DCMX_0M6_CONTROL_DB.PUBLIC` and records its actual owner without inference; its generated existence is expected state, not a pre-existing collision. He then checks `BLZ_DCMX_0M6_CONTROL_DB.BLZ_DCMX_0M6_CONTROL`, followed by `BLZ_DCMX_0M6_CONTROL_DB.BLZ_DCMX_0M6_CONTROL.BLZ_DCMX_0M6_PROJECT_DHUB` and `BLZ_DCMX_0M6_CONTROL_DB.BLZ_DCMX_0M6_CONTROL.BLZ_DCMX_0M6_PROJECT_DWH`, before creating each. Any other pre-existing exact name is a collision and a stop, not an adoption target; absent or unexpected implicit `PUBLIC` state is also a stop. This example is **blocked** until separate stage-state reconciliation is reviewed and approved. Cleanup uses only approved exact names, never prefix wildcards.

| Class | Proposed inventory |
| --- | --- |
| ownership/deployment | account roles `BLZ_DCMX_0M6_OWN_CONTROL`, `BLZ_DCMX_0M6_OWN_DHUB`, `BLZ_DCMX_0M6_OWN_DWH`; service users `BLZ_DCMX_0M6_DEPLOY_DHUB`, `BLZ_DCMX_0M6_DEPLOY_DWH`; their one-role assignments and credentials |
| DCM control | database `BLZ_DCMX_0M6_CONTROL_DB`, expected implicit schema `BLZ_DCMX_0M6_CONTROL_DB.PUBLIC`, requested schema `BLZ_DCMX_0M6_CONTROL_DB.BLZ_DCMX_0M6_CONTROL`, and projects `BLZ_DCMX_0M6_CONTROL_DB.BLZ_DCMX_0M6_CONTROL.BLZ_DCMX_0M6_PROJECT_DHUB`, `BLZ_DCMX_0M6_CONTROL_DB.BLZ_DCMX_0M6_CONTROL.BLZ_DCMX_0M6_PROJECT_DWH`; control database and requested control schema owned by `BLZ_DCMX_0M6_OWN_CONTROL`, implicit `PUBLIC` owner determined only by inspection, projects owned by matching domain ownership roles |
| DHUB desired state | roles `BLZ_DCMX_0M6_DHUB_FUNCTIONAL`, `BLZ_DCMX_0M6_DHUB_SERVICE`, `BLZ_DCMX_0M6_DHUB_WH_INTERACTIVE_USAGE`, `BLZ_DCMX_0M6_DHUB_WH_SERVICE_USAGE`; warehouses `BLZ_DCMX_0M6_DHUB_WH_INTERACTIVE`, `BLZ_DCMX_0M6_DHUB_WH_SERVICE`; database `BLZ_DCMX_0M6_DHUB_DB`; requested schema `BLZ_DCMX_0M6_DHUB_DB.DATA`; table `BLZ_DCMX_0M6_DHUB_DB.DATA.SOURCE`; database role `BLZ_DCMX_0M6_DHUB_DB.BLZ_DCMX_0M6_SOURCE_READER` |
| DWH desired state | roles `BLZ_DCMX_0M6_DWH_FUNCTIONAL`, `BLZ_DCMX_0M6_DWH_SERVICE`, `BLZ_DCMX_0M6_DWH_WH_INTERACTIVE_USAGE`, `BLZ_DCMX_0M6_DWH_WH_SERVICE_USAGE`; warehouses `BLZ_DCMX_0M6_DWH_WH_INTERACTIVE`, `BLZ_DCMX_0M6_DWH_WH_SERVICE`; database `BLZ_DCMX_0M6_DWH_DB`; requested schema `BLZ_DCMX_0M6_DWH_DB.DATA` |
| cross-domain edge | DHUB grants `BLZ_DCMX_0M6_DHUB_DB.BLZ_DCMX_0M6_SOURCE_READER` to existing `BLZ_DCMX_0M6_DWH_SERVICE`; ownership stays put |
| human verification harness | service users `BLZ_DCMX_0M6_VERIFY_CONSUMERS`, `BLZ_DCMX_0M6_VERIFY_UNRELATED`; role `BLZ_DCMX_0M6_UNRELATED`; all four functional/service roles assigned to `BLZ_DCMX_0M6_VERIFY_CONSUMERS`, unrelated role to `BLZ_DCMX_0M6_VERIFY_UNRELATED`; temporary `USAGE` on `BLZ_DCMX_0M6_DWH_WH_SERVICE` to unrelated role; credentials and local key material |

`COMPUTE_WH` is the only retained external container: neither project owns, replaces, alters, or cleans it. The historical `SNOWFLAKE_LEARNING_DB.DCM` location is not a prerequisite.

Expected implicit `BLZ_DCMX_0M6_CONTROL_DB.PUBLIC`, `BLZ_DCMX_0M6_DHUB_DB.PUBLIC`, and `BLZ_DCMX_0M6_DWH_DB.PUBLIC` are check/cleanup inventory within disposable databases, **not** requested schemas. There is no permission to create, transfer ownership of, grant on, drop, or otherwise mutate `PUBLIC` separately. Only domain `.DATA` schemas and the named control schema are requested.

Reviewed `rvn-hyr` findings still need separate reconciliation before execution: **Does each project create schema-local stage state beyond its named project record, what exact identifiers will inspection show, and is that state removed by project deletion?** Add any separately retained object to the exact inventory before execution. Until answered, stop; do not adopt researched cleanup patterns here.

Every disposable warehouse: `XSMALL`, initially suspended, auto-resume on, 60-second auto-suspend. Test settings, not standards. This smallest shape (one database/domain, one role/consumer category) does not settle permanent database count or workload subdivisions.

## Proposed permissions

**Bounded proposal, neither proven sufficient nor minimum.** Evidence does not settle shared control-container ownership or the exact sufficient privilege set. The proposed separation is: `BLZ_DCMX_0M6_OWN_CONTROL` owns only the disposable control database and requested control schema; each domain ownership role owns its project and domain desired state. The prior local experiment observed a control-access envelope, not its sufficiency or minimality here.

- Jørgen uses privileged administration to create `BLZ_DCMX_0M6_OWN_CONTROL`, `BLZ_DCMX_0M6_CONTROL_DB`, and `BLZ_DCMX_0M6_CONTROL_DB.BLZ_DCMX_0M6_CONTROL`, and leaves `OWNERSHIP` on that database and schema with `BLZ_DCMX_0M6_OWN_CONTROL`. No deployment user receives the control ownership role.
- Each domain ownership role gets account `CREATE DATABASE`, `CREATE ROLE`, and `CREATE WAREHOUSE`; `USAGE` on `BLZ_DCMX_0M6_CONTROL_DB` and `BLZ_DCMX_0M6_CONTROL_DB.BLZ_DCMX_0M6_CONTROL`; `CREATE DCM PROJECT` and `CREATE STAGE` on that control schema; and `USAGE` on retained `COMPUTE_WH`. These are its only proposed control-container/account grants.
- Declaration-created ownership is proposed to cover each role's own database, requested schema, database roles, warehouses, account roles, and grants. Ownership/deployment sessions use no global `MANAGE GRANTS`, admin/system role, other domain ownership role, or secondary-role assistance.
- Each domain grants interactive warehouse `USAGE` to its interactive-usage role, then that role to its functional role; it grants service warehouse `USAGE` to its service-usage role, then that role to its service role. Consumer functional/service roles get no other compute category. Ownership roles necessarily own both domain warehouses and are outside that consumer claim.
- DHUB grants database and `DATA` schema `USAGE`, and `SOURCE` table `SELECT`, to `BLZ_DCMX_0M6_DHUB_DB.BLZ_DCMX_0M6_SOURCE_READER`; it grants that database role to already-existing `BLZ_DCMX_0M6_DWH_SERVICE`. This is the only proposed data-access edge. Neither functional role nor `BLZ_DCMX_0M6_DHUB_SERVICE` is intended to have data access; the harness does not test their effective denial.

If project creation, planning, deployment, or inspection needs another role relationship or privilege, stop and report the exact error or missing prerequisite. Jørgen must revise and reapprove before broadening.

The candidate's platform-owner permission, empty DWH local-reader permission, and dependent-view/object-creation permission remain **deferred**, not rejected or reversed. Their inert roles, empty object, optional view, and dependent release are also deferred and absent here.

## Execution sequence: complete desired states

Each stage retains earlier declarations; these are complete states, not deltas. Only Jørgen creates projects and runs deployments; only those human-run deployments create domain objects, roles, and grants.

1. **Human bootstrap and project creation:** after the staged exact-name collision checks, Jørgen uses privileged administration to create the control ownership role and control database, performs the required implicit-`PUBLIC` inspection, then creates the control schema, matching domain ownership roles, deployment users/credentials, exact proposed grants, and one-role assignments. He verifies control ownership and grants, then under each matching non-admin domain ownership role creates its fully qualified project: `BLZ_DCMX_0M6_CONTROL_DB.BLZ_DCMX_0M6_CONTROL.BLZ_DCMX_0M6_PROJECT_DHUB` or `BLZ_DCMX_0M6_CONTROL_DB.BLZ_DCMX_0M6_CONTROL.BLZ_DCMX_0M6_PROJECT_DWH`.
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

- **Owners/direct edges:** actual owners of the control database/schema, both projects, and every disposable role, domain database, requested/implicit schema, warehouse, database role, and table; direct control-container privileges, warehouse→usage-role→consumer-role and DHUB object→database-role→DWH-service grants; direct absence of global `MANAGE GRANTS`, control-role assignment to deployment users, and unintended role inheritance. Direct grant rows do not prove effective access.
- **Positive data path:** as `BLZ_DCMX_0M6_VERIFY_CONSUMERS`, primary `BLZ_DCMX_0M6_DWH_SERVICE`, secondary roles disabled, warehouse `BLZ_DCMX_0M6_DWH_WH_SERVICE`, `SELECT` from `BLZ_DCMX_0M6_DHUB_DB.DATA.SOURCE` succeeds. Record active role/warehouse; this proves that session's effective path, not just a direct grant.
- **Compute separation:** four separately pinned sessions: each functional role uses its domain interactive warehouse and is denied its service warehouse; each service role uses its domain service warehouse and is denied its interactive warehouse. Record successful active-warehouse checks and authorization failures; ownership-role behavior proves nothing about consumer separation.
- **Unrelated denial:** as `BLZ_DCMX_0M6_VERIFY_UNRELATED`, primary `BLZ_DCMX_0M6_UNRELATED`, secondary roles disabled, temporary DWH service-warehouse access: same source `SELECT` fails for data authorization. Record nonzero exit/error; absence of compute is not data denial.

These human-run checks require separate authorization; **not now**.

### Checkpoints and stops

1. Before live action: independent review and Jørgen approval of contract, exact names, unresolved stage mechanic, privileges, evidence handling, cleanup.
2. Before each initial base plan Jørgen confirms the exact control database, schema, fully qualified project, owners, and proposed grants; before each replan or dependent plan, prior human deployment too. After each plan he decides whether it matches; only he creates/deploys.
3. Before verification: Jørgen authorizes/creates exact harness. After sanitizing and committing evidence: he authorizes exact-inventory cleanup or records retention reason, owner, deadline, and eventual cleanup result.

**Stop** on initial disposable-name collision, unexpected identifier for stage, absent prerequisite, unexpected object/change/removal/ownership transfer, privilege request, plan or replan error, evidence leak, namespace escape, or actual/approved-state mismatch. Preserve sanitized context; require new human checkpoint before retry.

### Evidence hygiene and cleanup

Commit only claim-relevant rows, tool version, UTC time, stage, exact identifiers, actor category, exit status. Exclude credentials, keys, tokens, account locators, personal paths, connection configuration, raw transcripts, unrelated account metadata.

Jørgen cleans up in dependency-safe order, using only the approved exact inventory:

1. Remove harness assignments and the temporary warehouse grant.
2. Remove harness users, role, credentials, and keys.
3. Remove the domain cross-edge and DCM-managed objects. Dropping disposable domain databases includes requested `DATA` and implicit `PUBLIC`.
4. Remove exact projects `BLZ_DCMX_0M6_CONTROL_DB.BLZ_DCMX_0M6_CONTROL.BLZ_DCMX_0M6_PROJECT_DHUB` and `BLZ_DCMX_0M6_CONTROL_DB.BLZ_DCMX_0M6_CONTROL.BLZ_DCMX_0M6_PROJECT_DWH`, plus any separately inventoried project-owned stage state; stop if unresolved dependencies remain.
5. Remove `BLZ_DCMX_0M6_CONTROL_DB.BLZ_DCMX_0M6_CONTROL`, then `BLZ_DCMX_0M6_CONTROL_DB`—which removes expected implicit `BLZ_DCMX_0M6_CONTROL_DB.PUBLIC` with its parent, never through a separate mutation—only after exact inventory and dependency checks show no retained dependencies.
6. Remove deployment users, credentials, and keys.
7. Remove domain ownership roles, then `BLZ_DCMX_0M6_OWN_CONTROL` after its owned objects are gone.

Never alter retained `COMPUTE_WH` or the historical `SNOWFLAKE_LEARNING_DB.DCM` location. Partial execution needs the same bounded human cleanup and a recorded result; agents never clean up.
