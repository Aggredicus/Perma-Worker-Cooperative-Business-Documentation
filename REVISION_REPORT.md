# Revision Report

This repository was expanded from a minimal scaffold into a working business administration suite intended for a Michigan permaculture services company launching as an LLC and planning for eventual worker-cooperative conversion.

## What was revised in this governance update

This update converted the future-state cooperative materials from high-level outlines into a more executable governance package.

### Rewritten core constitutional documents
- `docs/04_conversion_future/coop_bylaws_draft.md`
- `docs/04_conversion_future/worker_owner_membership_agreement_draft.md`
- `docs/04_conversion_future/patronage_dividend_policy_draft.md`
- `docs/04_conversion_future/cooperative_corporation_conversion_plan.md`
- `docs/03_governance_and_policies/governance_evolution_policy.md`
- `docs/01_formation/operating_agreement_conversion_ready.md`

### New governance machinery added
- `docs/03_governance_and_policies/board_charter.md`
- `docs/03_governance_and_policies/membership_committee_charter.md`
- `docs/03_governance_and_policies/finance_committee_charter.md`
- `docs/03_governance_and_policies/conflict_of_interest_policy.md`
- `docs/03_governance_and_policies/director_code_of_conduct.md`
- `docs/03_governance_and_policies/discipline_and_appeals_procedure.md`
- `docs/03_governance_and_policies/election_and_voting_procedure.md`
- `docs/03_governance_and_policies/capital_accounts_and_internal_equity_policy.md`
- `docs/03_governance_and_policies/meeting_agenda_and_resolution_templates.md`
- `docs/03_governance_and_policies/governance_committee_charter.md`
- `docs/03_governance_and_policies/emergency_authority_policy.md`
- `docs/03_governance_and_policies/governance_simulation_gap_memo.md`

## Approved design choices embedded in the documents

The rewrite encodes the choices approved by the user:
- hybrid founder-to-worker transition,
- three-seat board,
- two-thirds member vote for worker-owner admission,
- two-thirds member vote for expulsion after due process,
- patronage based primarily on labor compensation.

## Simulation-based rationale for the update

The prior package was strong as a transition roadmap but weak as a live governance constitution. The revision directly addressed failures revealed in boardroom simulations involving:
- contested worker-owner admissions,
- annual surplus allocation,
- discipline and expulsion,
- board deadlock,
- founder-control drift after conversion.

## Post-revision simulation findings

A second simulation pass identified and closed several operational gaps that would have caused problems in a live small-cooperative setting:
- admissions now work even before a formal Membership Committee exists,
- founder-seat vacancies can no longer be informally refilled by remaining directors,
- the repo now includes a Governance Committee Charter where director-removal review is referenced,
- the repo now includes an Emergency Authority Policy where emergency action was previously referenced but not defined.

A dedicated simulation memo was added at `docs/03_governance_and_policies/governance_simulation_gap_memo.md` to record scenario outcomes and remaining redline items.

## Remaining items for attorney / CPA review

Before live use, have Michigan counsel and a CPA or EA review:
- exact cooperative entity choice and filing path,
- founder reserved-matters design and enforceability,
- membership capital and redemption mechanics,
- patronage tax treatment and reporting,
- conflict and non-solicitation language,
- board and member voting language for the final chosen entity statute.

## Source-grounded notes

Michigan states that LLC governance is set by the articles or operating agreement, and the Michigan LLC Act defines and recognizes operating agreements. Michigan’s employee-owned corporation act includes a definition of “worker cooperative,” which supports the repo’s direction for worker-ownership design. The IRS instructions for Form 1099-PATR state that cooperatives file the form for each person to whom at least $10 in patronage dividends or related distributions were paid, subject to the current instructions for the tax year in question.
