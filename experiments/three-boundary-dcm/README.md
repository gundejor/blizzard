# Three-boundary DCM verification contract

Status: **proposed and unexecuted**. This document is a contract for a possible later Blizzard experiment, not runnable implementation or authority to execute it.

## Provenance and boundary

This contract implements the bounded direction in Chart `rvn-9n3`, comment `01a0d33c-390e-7a60-aad2-5e1fc7b9ab55`, using the accepted `rvn-9n3.5` candidate at Gondolin library commit `8c026bd` and its `DCM-EVIDENCE.md` index. The earlier two-project result at Blizzard commit `630708c` supports only its recorded two-project observations; it does not prove this sequence.

This assignment makes no live call. In any later execution, an agent may run **only** `snow dcm plan`. Jørgen Bjørdal alone performs bootstrap, DCM project creation, deploy, state-changing verification setup, and cleanup. Agents must not substitute SQL, scripts, SDKs, `snow dcm create`, `deploy`, `purge`, `drop`, or any other command. Missing project, object, identity, credential, role, grant, or privilege state needed by plan is a named human prerequisite: stop and return it to Jørgen; do not create, repair, or broaden anything.

Company accounts and repositories, CI, production hardening, identity lifecycle, shared-warehouse policy, and broader DCM lifecycle behavior are excluded.

## Disposable test inventory

Use the fresh prefix `BLZ_DCMX_0M6` in the existing personal Blizzard account. Every account-scoped object and DCM project is named exactly below and starts with that prefix. Database-local objects are exact, fully qualified names inside a prefixed database; they are disposable only as part of that database. Before bootstrap, Jørgen confirms that none of the listed account-scoped objects or projects exists and that neither prefixed database contains a listed local name. Cleanup is bounded to this exact inventory, not a prefix wildcard. These identifiers and settings are test configuration, not naming or sizing standards.

| Boundary | Complete proposed inventory |
| --- | --- |
| privileged bootstrap | roles `BLZ_DCMX_0M6_OWN_DHUB` and `BLZ_DCMX_0M6_OWN_DWH`; single-role deployment identities `BLZ_DCMX_0M6_DEPLOY_DHUB` and `BLZ_DCMX_0M6_DEPLOY_DWH`; populated projects `BLZ_DCMX_0M6_PROJECT_DHUB` and `BLZ_DCMX_0M6_PROJECT_DWH`; optional role `BLZ_DCMX_0M6_OWN_PLATFORM`, with no grants, identity, objects, or project |
| DHUB base | roles `BLZ_DCMX_0M6_DHUB_FUNCTIONAL`, `BLZ_DCMX_0M6_DHUB_SERVICE`, `BLZ_DCMX_0M6_DHUB_WH_INTERACTIVE_USAGE`, and `BLZ_DCMX_0M6_DHUB_WH_SERVICE_USAGE`; warehouses `BLZ_DCMX_0M6_DHUB_WH_INTERACTIVE` and `BLZ_DCMX_0M6_DHUB_WH_SERVICE`; database `BLZ_DCMX_0M6_DHUB_DB`; schema `BLZ_DCMX_0M6_DHUB_DB.DATA`; table `BLZ_DCMX_0M6_DHUB_DB.DATA.SOURCE`; database role `BLZ_DCMX_0M6_DHUB_DB.BLZ_DCMX_0M6_SOURCE_READER` |
| DWH base | roles `BLZ_DCMX_0M6_DWH_FUNCTIONAL`, `BLZ_DCMX_0M6_DWH_SERVICE`, `BLZ_DCMX_0M6_DWH_WH_INTERACTIVE_USAGE`, and `BLZ_DCMX_0M6_DWH_WH_SERVICE_USAGE`; warehouses `BLZ_DCMX_0M6_DWH_WH_INTERACTIVE` and `BLZ_DCMX_0M6_DWH_WH_SERVICE`; database `BLZ_DCMX_0M6_DWH_DB`; schema `BLZ_DCMX_0M6_DWH_DB.DATA`; database role `BLZ_DCMX_0M6_DWH_DB.BLZ_DCMX_0M6_LOCAL_READER` |
| DHUB boundary grant | `BLZ_DCMX_0M6_DHUB_DB.BLZ_DCMX_0M6_SOURCE_READER` granted to existing `BLZ_DCMX_0M6_DWH_SERVICE`; DHUB declares the edge and ownership does not move |
| optional DWH dependent release | view `BLZ_DCMX_0M6_DWH_DB.DATA.DHUB_SOURCE` referencing `BLZ_DCMX_0M6_DHUB_DB.DATA.SOURCE`, included only to test an object-specific creation dependency |

Every warehouse is `XSMALL`, initially suspended, with auto-resume enabled and auto-suspend after 60 seconds. Each domain owns its warehouses, their usage roles, and grants of the interactive usage role to its functional role and service usage role to its service role. No role receives the other compute category. Cross-domain reads use DWH service compute, not a DHUB warehouse.

One database per domain, one representative role of each category, and one optional dependent object are the smallest test shape; they do not settle eventual database count, role names, warehouse size, or workload subdivisions.

## Proposed privilege envelope

This is the **exact proposed set for this test**, deliberately unproven as the minimum. A plan or deploy failure is evidence against it, not authority to add privileges.

1. Jørgen uses privileged administration only to create the exact inventory above, assign `BLZ_DCMX_0M6_DEPLOY_DHUB` only `BLZ_DCMX_0M6_OWN_DHUB` and `BLZ_DCMX_0M6_DEPLOY_DWH` only `BLZ_DCMX_0M6_OWN_DWH`, establish the two named DCM projects, and perform final cleanup.
2. `BLZ_DCMX_0M6_OWN_DHUB` and `BLZ_DCMX_0M6_OWN_DWH` each receive only `CREATE DATABASE`, `CREATE ROLE`, and `CREATE WAREHOUSE` on the account. `BLZ_DCMX_0M6_PROJECT_DHUB` is owned and operated by `BLZ_DCMX_0M6_OWN_DHUB`; `BLZ_DCMX_0M6_PROJECT_DWH` is owned and operated by `BLZ_DCMX_0M6_OWN_DWH`. Ownership created through their declarations supplies authority over their own database, schemas, database roles, warehouses and grants.
3. The exact local compute composition is:
   - `USAGE` on `BLZ_DCMX_0M6_DHUB_WH_INTERACTIVE` to `BLZ_DCMX_0M6_DHUB_WH_INTERACTIVE_USAGE`, then that usage role to `BLZ_DCMX_0M6_DHUB_FUNCTIONAL`;
   - `USAGE` on `BLZ_DCMX_0M6_DHUB_WH_SERVICE` to `BLZ_DCMX_0M6_DHUB_WH_SERVICE_USAGE`, then that usage role to `BLZ_DCMX_0M6_DHUB_SERVICE`;
   - `USAGE` on `BLZ_DCMX_0M6_DWH_WH_INTERACTIVE` to `BLZ_DCMX_0M6_DWH_WH_INTERACTIVE_USAGE`, then that usage role to `BLZ_DCMX_0M6_DWH_FUNCTIONAL`; and
   - `USAGE` on `BLZ_DCMX_0M6_DWH_WH_SERVICE` to `BLZ_DCMX_0M6_DWH_WH_SERVICE_USAGE`, then that usage role to `BLZ_DCMX_0M6_DWH_SERVICE`.
   No role receives the other compute category; warehouse usage confers no ownership or administration.
4. DHUB declares `USAGE` on `BLZ_DCMX_0M6_DHUB_DB`, `USAGE` on `BLZ_DCMX_0M6_DHUB_DB.DATA`, and `SELECT` on `BLZ_DCMX_0M6_DHUB_DB.DATA.SOURCE` to database role `BLZ_DCMX_0M6_DHUB_DB.BLZ_DCMX_0M6_SOURCE_READER`. As its owner, `BLZ_DCMX_0M6_OWN_DHUB` may grant that database role to the already existing `BLZ_DCMX_0M6_DWH_SERVICE` account role; it receives no ownership or administration over the recipient role.
5. Data access deliberately stops there: neither functional role receives a database role or data-object grant; `BLZ_DCMX_0M6_DHUB_SERVICE` receives none; and `BLZ_DCMX_0M6_DWH_DB.BLZ_DCMX_0M6_LOCAL_READER` is deliberately empty because this test declares no local DWH table. No other database/schema/table/view access grant is proposed, including one for optional view creation; evidence that one is required is a stop-and-revise result.
6. `BLZ_DCMX_0M6_OWN_PLATFORM`, if bootstrapped, receives no account privilege, inheritance, object, grant, identity, or DCM project in this experiment.
7. No deployment or workload role receives global `MANAGE GRANTS`, an admin/system role, another domain's ownership role, or secondary-role assistance. Deployment and plan sessions pin the matching identity and primary role with secondary roles disabled.

If DCM project creation, planning, or deployment requires any additional project/schema privilege or role relationship, stop and record the exact missing prerequisite. Jørgen must explicitly revise and reapprove this contract before any broadening.

## Desired-state stages and order

Each stage is a complete desired state for its boundary, never a delta that omits earlier declarations:

1. **Human bootstrap:** Jørgen creates only the approved fresh namespace prerequisites and the two populated project records. Optional `BLZ_DCMX_0M6_OWN_PLATFORM` creates no platform declaration.
2. **Independent bases:** DHUB base and DWH base may be planned and human-deployed in either order. Each base includes its full inventory and all local composition. The DWH base creates and retains the recipient service role.
3. **DHUB boundary grant:** only after both bases exist, the next DHUB desired state retains every DHUB base declaration and adds the source-reader-to-DWH-service grant. A later DHUB plan must show no accidental base removal.
4. **Optional dependent object:** only if retained in the approved test, the next DWH desired state retains every DWH base declaration and adds the view. Its prerequisites are both bases, the source grant if creation needs it, and any object-specific privilege explicitly approved after evidence; it is not a prerequisite for unrelated DWH objects.
5. **Runtime data readiness:** source data readiness occurs after object deployment and is not a DCM deployment prerequisite or proof of deployment success.

No stage may rely on an object, project, ownership transfer, manual repair, or grant that is absent from this inventory and prior approved stages.

## Evidence and checkpoints

### What plan may establish

For each approved stage, retain sanitized plan output showing the pinned boundary identity/role, project and stage, planned creates/grants/removals, and exit result. A satisfactory plan has no unexpected removal, ownership transfer, unrelated object, platform scaffold, or privilege broadening. A no-change replan may be collected only after Jørgen reports the corresponding human deployment complete.

Plan success proves only that DCM produced that plan against the then-current state. It does **not** prove creation, ownership, deployment success, access, compute choice, query success, denial, or cleanup.

### What remains unverified until separately authorized after deploy

Jørgen must separately produce sanitized evidence for:

- actual owner of each project, role, database, schema, warehouse, database role and dependent object;
- the DHUB source grant reaching only the DWH recipient service role without ownership transfer;
- functional roles using only interactive compute and service roles using only service compute;
- DWH service-role `SELECT` through the DHUB source grant using DWH service compute;
- denial of the same data to a fresh unrelated role with secondary roles disabled; and
- absence of global `MANAGE GRANTS` and unintended role inheritance.

A successful plan must never be reported as successful deployment or runtime verification.

### Human checkpoints and stops

1. **Before any live action:** independent review and Jørgen approval of this contract, identifiers, privilege envelope, release layout, evidence handling, and cleanup choice.
2. **Before each agent plan:** Jørgen confirms bootstrap or preceding deploy completion and supplies the approved project path and pinned plan identity. The agent stops if any prerequisite is absent.
3. **After each plan:** Jørgen decides whether the plan matches the contract. Only Jørgen may deploy.
4. **Before dependent release:** Jørgen decides whether the optional object remains useful and approves any evidenced object-specific creation privilege by contract revision.
5. **Before runtime checks:** separate authorization and human preparation of any source rows, test identities, and grants.
6. **Before cleanup:** evidence is sanitized and committed, then Jørgen either authorizes namespace-bounded cleanup or records a bounded retention owner and deadline.

Stop immediately on an unexpected existing identifier, deletion, replacement, ownership change, unrelated object, privilege request, hidden prerequisite, plan error, evidence leak, namespace escape, or mismatch between actual and approved state. Preserve the error and sanitized context; do not retry after repair without a new human checkpoint.

## Evidence hygiene, retention, and cleanup

Commit only the contract and later sanitized results needed to support claims. Remove credentials, private/public key material, tokens, account locators, personal paths, connection configuration, and unrelated account metadata from captures. Record tool version, UTC time, stage, exact disposable identifiers, actor category, exit status, and relevant plan/check rows. Raw transcripts and temporary agent files are not durable evidence.

Jørgen owns cleanup of the exact `BLZ_DCMX_0M6` inventory listed above, its credentials, and its local key material; the prefix alone is not cleanup authority. The default decision is cleanup after evidence acceptance. Retention for inspection requires Jørgen to record the reason, owner, deadline, and eventual cleanup result on the execution ticket. Partial execution still requires the same namespace-bounded human cleanup; agents do not clean up.
