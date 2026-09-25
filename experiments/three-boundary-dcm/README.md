# Three-boundary DCM verification contract

Status: **proposed and unexecuted**. This contract governs a possible later Blizzard experiment; it is not implementation or authority to execute it.

## Authority, provenance, and boundary

This contract implements Chart `rvn-9n3` comment `01a0d33c-390e-7a60-aad2-5e1fc7b9ab55` using accepted candidate `rvn-9n3.5` at Gondolin library commit `8c026bd`. The earlier two-project result at Blizzard commit `630708c` supports only its recorded mechanics: projects in `SNOWFLAKE_LEARNING_DB.DCM`, their observed container grants, non-admin deployment, an implicit `PUBLIC` schema, and positive/negative access checks. It does not prove this proposed sequence or privilege envelope.

This assignment makes no live call. In any separately authorized execution, an agent may run **only** `snow dcm plan`. Jørgen Bjørdal performs every state change: privileged bootstrap, project creation, human-run DCM deployment, verification setup/checks, and cleanup. No agent may substitute SQL, scripts, SDKs, `snow dcm create`, `deploy`, `purge`, `drop`, or another command. Missing or uncertain project, container, object, identity, credential, role, grant, or privilege state is a human prerequisite and stop, never permission to create, repair, retry, or broaden it.

Company accounts and repositories, CI, production hardening, identity lifecycle, shared-warehouse policy, broader DCM lifecycle behavior, implementation, external research, and all live calls in this assignment are excluded.

## Central naming contract

The rule is: disposable account-scoped identifiers and project or database-role local names are formed from the unquoted uppercase `NAMESPACE`, `_`, and the semantic suffix shown in the resolved inventory below. The schema and table local names `DATA`, `SOURCE`, and implicit `PUBLIC` are fixed names instead. Schemas and database roles are carried and reviewed as two-part `DATABASE.LOCAL_NAME` identifiers, while only schema-contained objects are carried and reviewed as three-part `DATABASE.SCHEMA.OBJECT` identifiers. The rule has only these explicit inputs for this experiment:

| Input | Resolved value | Treatment |
| --- | --- | --- |
| `NAMESPACE` | `BLZ_DCMX_0M6` | disposable experiment namespace |
| `CONTROL_DATABASE` | `SNOWFLAKE_LEARNING_DB` | retained external input; never derived or cleaned |
| `CONTROL_SCHEMA` | `DCM` | retained external input; never derived or cleaned |
| `CONTROL_WAREHOUSE` | `COMPUTE_WH` | retained external input; never derived or cleaned |

`DHUB` and `DWH` are the two fixed domain suffixes in this bounded design, not additional configurable naming layers. For example, the rule resolves the DHUB database to `BLZ_DCMX_0M6_DHUB_DB`, its requested schema to `BLZ_DCMX_0M6_DHUB_DB.DATA`, and its project to `SNOWFLAKE_LEARNING_DB.DCM.BLZ_DCMX_0M6_PROJECT_DHUB`. The inventory below is the single resolved example and source of exact names for review and human action; future DCM definition files must reference these inputs rather than repeat resolved literals.

Where a future DCM definition needs a varying identifier, use DCM's documented Jinja2 `{{ variable }}` substitution, with values declared in `manifest.yml` under `templating.defaults` or `templating.configurations` and selected by the target; a plan-time `--variable`/`-D` override has higher precedence. The documented precedence is defaults, selected configuration, then runtime values. This contract does not claim that DCM templating applies to manifest project/target identifiers or to human bootstrap, harness, or cleanup operations; those unsupported contexts consume the reviewed resolved inventory directly. It adds no custom renderer, naming code, manifest, or script.

Snowflake's [identifier requirements](https://docs.snowflake.com/en/sql-reference/identifiers-syntax) (retrieved 2026-09-25 UTC) say unquoted identifiers start with an ASCII letter or underscore, then contain only letters, underscores, decimal digits, or dollar signs, and are stored/resolved uppercase. Double-quoted identifiers preserve case and permit otherwise excluded characters but must be referenced exactly by default; either form is limited to 255 characters. The uppercase values here are a local experiment choice, not a universal Snowflake naming best practice. Snowflake's [DCM project files and templating documentation](https://docs.snowflake.com/en/user-guide/dcm-projects/dcm-projects-files), [DCM plan option reference](https://docs.snowflake.com/en/developer-guide/snowflake-cli/command-reference/dcm-commands/plan), and [`EXECUTE DCM PROJECT` reference](https://docs.snowflake.com/en/sql-reference/sql/execute-dcm-project) (retrieved 2026-09-25 UTC) document Jinja2 variables, manifest configurations, CLI `--variable`/`-D`, and SQL runtime overrides. They do not establish that Snowflake CLI's separate project-template syntax applies to DCM definitions; no such syntax is used here.

## Resolved exact inventory and retained control containers

The resolved example uses namespace `BLZ_DCMX_0M6` in the existing personal Blizzard account. Before any collision check, plan review, or exact dependency-safe human cleanup, Jørgen must approve one deterministic, fully resolved inventory containing full database/schema qualification and the explicit retained-container inputs. The current example is not execution-ready until the separate stage-state reconciliation is reviewed and approved. Cleanup is limited to the approved exact inventory, never a prefix wildcard.

| Class | Complete proposed disposable inventory |
| --- | --- |
| ownership and deployment | account roles `BLZ_DCMX_0M6_OWN_DHUB`, `BLZ_DCMX_0M6_OWN_DWH`; service users `BLZ_DCMX_0M6_DEPLOY_DHUB`, `BLZ_DCMX_0M6_DEPLOY_DWH`; their one-role assignments and credentials |
| DCM control state | projects `SNOWFLAKE_LEARNING_DB.DCM.BLZ_DCMX_0M6_PROJECT_DHUB` and `SNOWFLAKE_LEARNING_DB.DCM.BLZ_DCMX_0M6_PROJECT_DWH`, owned respectively by the matching ownership role |
| DHUB desired state | roles `BLZ_DCMX_0M6_DHUB_FUNCTIONAL`, `BLZ_DCMX_0M6_DHUB_SERVICE`, `BLZ_DCMX_0M6_DHUB_WH_INTERACTIVE_USAGE`, `BLZ_DCMX_0M6_DHUB_WH_SERVICE_USAGE`; warehouses `BLZ_DCMX_0M6_DHUB_WH_INTERACTIVE`, `BLZ_DCMX_0M6_DHUB_WH_SERVICE`; database `BLZ_DCMX_0M6_DHUB_DB`; requested schema `BLZ_DCMX_0M6_DHUB_DB.DATA`; table `BLZ_DCMX_0M6_DHUB_DB.DATA.SOURCE`; database role `BLZ_DCMX_0M6_DHUB_DB.BLZ_DCMX_0M6_SOURCE_READER` |
| DWH desired state | roles `BLZ_DCMX_0M6_DWH_FUNCTIONAL`, `BLZ_DCMX_0M6_DWH_SERVICE`, `BLZ_DCMX_0M6_DWH_WH_INTERACTIVE_USAGE`, `BLZ_DCMX_0M6_DWH_WH_SERVICE_USAGE`; warehouses `BLZ_DCMX_0M6_DWH_WH_INTERACTIVE`, `BLZ_DCMX_0M6_DWH_WH_SERVICE`; database `BLZ_DCMX_0M6_DWH_DB`; requested schema `BLZ_DCMX_0M6_DWH_DB.DATA` |
| cross-domain edge | `BLZ_DCMX_0M6_DHUB_DB.BLZ_DCMX_0M6_SOURCE_READER` granted by DHUB to existing role `BLZ_DCMX_0M6_DWH_SERVICE`; ownership does not move |
| human verification harness | service users `BLZ_DCMX_0M6_VERIFY_CONSUMERS` and `BLZ_DCMX_0M6_VERIFY_UNRELATED`; role `BLZ_DCMX_0M6_UNRELATED`; assignments of all four functional/service roles to `BLZ_DCMX_0M6_VERIFY_CONSUMERS` and the unrelated role to `BLZ_DCMX_0M6_VERIFY_UNRELATED`; temporary `USAGE` on `BLZ_DCMX_0M6_DWH_WH_SERVICE` to the unrelated role; harness credentials and local key material |

`SNOWFLAKE_LEARNING_DB`, its `DCM` schema, and `COMPUTE_WH` are retained external prerequisites, not disposable experiment state. Neither project may own, replace, alter, or clean them. Proposed project access for each matching ownership role is `USAGE` on that database and schema, `CREATE DCM PROJECT` and `CREATE STAGE` on that schema, and `USAGE` on `COMPUTE_WH`. The local two-project experiment observed this container envelope; whether every element is sufficient or minimal here is unverified.

Snowflake/DCM is expected to create `BLZ_DCMX_0M6_DHUB_DB.PUBLIC` and `BLZ_DCMX_0M6_DWH_DB.PUBLIC` implicitly with their databases. They are check and cleanup inventory contained by the respective disposable database, not requested domain schemas; this contract grants no permission to mutate a system-managed `PUBLIC` schema. The requested domain schemas remain only the two `.DATA` schemas.

The prior local source requires `CREATE STAGE` but does not identify whether DCM creates a separately visible stage, its generated name, or whether project deletion removes it. Before execution Jørgen must answer: **Does each project create schema-local stage state beyond the two named project records, what exact identifiers will inspection show, and is that state removed by project deletion?** Any separately retained object must be added to the exact inventory before execution; absence of that answer is a stop.

Every disposable warehouse is `XSMALL`, initially suspended, with auto-resume enabled and auto-suspend after 60 seconds. These identifiers and settings are bounded test configuration, not naming or sizing standards. One database per domain and one representative role per consumer category are the smallest test shape; they do not settle permanent database count or workload subdivisions.

## Proposed privilege and grant envelope

This is the exact proposal for the test, **not evidence of sufficiency and not a proven minimum**.

1. With privileged administration, Jørgen creates the two ownership roles, two deployment users and credentials, exact control-container/account privilege grants, and one-role user assignments. Under each matching non-admin ownership role, Jørgen creates its project and runs its DCM deployments. Domain objects, roles, and grants are created only by those human-run deployments.
2. Each ownership role receives `CREATE DATABASE`, `CREATE ROLE`, and `CREATE WAREHOUSE` on the account plus only its control-container access above. Ownership created through its declarations is proposed to supply authority over its own database, requested schema, database roles, warehouses, account roles, and grants. Neither ownership nor deployment session receives global `MANAGE GRANTS`, an admin/system role, the other domain's ownership role, or secondary-role assistance.
3. Each domain grants `USAGE` on its interactive warehouse to its interactive-usage role and that role to its functional role. It grants `USAGE` on its service warehouse to its service-usage role and that role to its service role. Functional/service **consumer roles** receive no other compute category; ownership roles necessarily own both domain warehouses and are outside this consumer separation claim.
4. DHUB grants database and `DATA` schema `USAGE` plus `SOURCE` table `SELECT` to `BLZ_DCMX_0M6_DHUB_DB.BLZ_DCMX_0M6_SOURCE_READER`, then grants that database role to the already existing `BLZ_DCMX_0M6_DWH_SERVICE`. This is the only proposed data-access edge; neither functional role nor `BLZ_DCMX_0M6_DHUB_SERVICE` receives data access.
5. Verification-harness assignments and temporary unrelated-role warehouse `USAGE` are privileged human setup after deployment, not domain desired state or evidence of DCM-managed grants. They exist only to pin one primary consumer role per check with secondary roles disabled and to test data denial with usable DWH compute.

If project creation, planning, deployment, or inspection requires another role relationship or privilege, stop with the exact error or missing prerequisite. Jørgen must revise and reapprove this contract before broadening.

The accepted candidate's platform-owner permission, empty DWH local-reader permission, and dependent-view/object-creation permission are **deferred**, not rejected or reversed. Their inert roles, empty object, optional view, and dependent release are deliberately absent from this bounded test.

## Complete desired states and order

1. **Human bootstrap and project creation:** Jørgen establishes only the approved ownership/deployment/control prerequisites, then creates each fully qualified project under its matching ownership role.
2. **Independent bases:** DHUB and DWH complete base states may be planned and human-deployed in either order. Each project state contains every object, local compute grant, and role composition listed for that domain. DWH creates and retains the recipient `BLZ_DCMX_0M6_DWH_SERVICE` role.
3. **DHUB boundary release:** only after both bases exist, DHUB's complete desired state retains every DHUB base declaration and adds the source-reader-to-DWH-service edge. DWH state is unchanged. There is no optional dependent-object release.
4. **Verification readiness:** after both deployments and the DHUB boundary deployment, Jørgen creates the harness assignments/temporary grant and any source row needed for a meaningful result. Runtime data is not a DCM deployment prerequisite or proof of deployment success.

No stage is a delta that omits earlier declarations, and no stage may depend on unlisted project, object, ownership transfer, manual repair, or grant.

## Evidence contract

### Agent plans and mandatory no-change replans

For every approved desired-state stage, retain sanitized plan output with pinned deployment user, primary ownership role, secondary roles disabled, fully qualified project, stage, planned creates/grants/removals, exit status, tool version, and UTC time. A satisfactory pre-deploy plan contains no unexpected removal, replacement, ownership transfer, unrelated object, deferred object, or privilege broadening.

After Jørgen reports each human deployment complete, an agent must run the same approved `snow dcm plan` as a no-change replan. Expected evidence is a successful empty plan. A nonzero exit or any proposed change is a failed checkpoint: preserve the sanitized result, report it exactly, and stop; never call deployment successful or repair/retry it.

A plan proves only what DCM proposed against then-current state. It does not prove project/object creation, ownership, deployment success, direct grants, effective access, compute choice, query result, denial, or cleanup.

### Human inspection and runtime harness

Jørgen separately captures:

- **Ownership and direct edges:** actual owner of both projects and every disposable role, database, requested/implicit schema, warehouse, database role, and table; direct warehouse-to-usage-role, usage-role-to-consumer-role, DHUB object-to-database-role, and database-role-to-DWH-service grants; direct absence of global `MANAGE GRANTS` and unintended role inheritance. Direct grant rows prove only those edges, not effective access.
- **Effective positive access:** as `BLZ_DCMX_0M6_VERIFY_CONSUMERS`, pin primary role `BLZ_DCMX_0M6_DWH_SERVICE`, secondary roles disabled, and `BLZ_DCMX_0M6_DWH_WH_SERVICE`; `SELECT` from `BLZ_DCMX_0M6_DHUB_DB.DATA.SOURCE` must succeed, and evidence must record the active role and warehouse. This proves that session's effective path, not merely the direct grant.
- **Compute separation:** in four separately pinned sessions, each functional role must use its domain interactive warehouse and be denied its domain service warehouse; each service role must use its domain service warehouse and be denied its domain interactive warehouse. Record successful active-warehouse checks and authorization failures. Do not infer consumer separation from ownership-role behavior.
- **Unrelated denial:** as `BLZ_DCMX_0M6_VERIFY_UNRELATED`, pin `BLZ_DCMX_0M6_UNRELATED`, secondary roles disabled, and its temporary DWH service-warehouse access; the same source `SELECT` must fail for data authorization. Record nonzero exit and error without treating absence of compute as the denial.

These checks are human-run and separately authorized; this contract does not authorize setup or execution now.

## Checkpoints, evidence hygiene, and cleanup

1. Before live action, independent review and Jørgen approval cover this contract, exact identifiers, unresolved stage mechanic, privileges, evidence handling, and cleanup.
2. Before each initial pre-deploy base plan, Jørgen confirms the named project/control prerequisites. Before each replan or dependent-stage plan, he also confirms the preceding human deployment. After each plan, Jørgen decides whether it matches the contract; only Jørgen may create or deploy.
3. Before verification, Jørgen separately authorizes and creates the exact harness state. After evidence is sanitized and committed, Jørgen authorizes exact-inventory cleanup or records retention reason, owner, deadline, and eventual cleanup result.

Stop on an initial disposable-identifier collision, an identifier unexpected for the current stage, absent prerequisite, unexpected object/change/removal/ownership transfer, privilege request, plan or no-change-replan error, evidence leak, namespace escape, or actual/approved-state mismatch. Preserve sanitized context and require a new human checkpoint before any retry.

Committed evidence excludes credentials, key material, tokens, account locators, personal paths, connection configuration, raw transcripts, and unrelated account metadata. It includes only claim-relevant rows plus tool version, UTC time, stage, exact identifiers, actor category, and exit status.

Jørgen cleans, in dependency-safe order, the harness assignments and temporary warehouse grant; harness users/role/credentials/keys; domain cross-edge and DCM-managed objects; both fully qualified projects and any resolved project-owned stage state; deployment users/credentials/keys; and ownership roles. Dropping each disposable database includes its requested `DATA` and implicit `PUBLIC` schemas. `SNOWFLAKE_LEARNING_DB`, `SNOWFLAKE_LEARNING_DB.DCM`, and `COMPUTE_WH` are retained and must not be altered. Partial execution requires the same bounded human cleanup and a recorded result; agents never clean up.
