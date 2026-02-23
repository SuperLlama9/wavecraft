---
name: architect
description: >
  Make and document significant architectural decisions. This skill should be used when the user
  says "architecture decision", "write an ADR", "design the system", "data model", "API contract",
  "system design", "how should we structure this", or any variation of making architectural choices.
  Also trigger when the user mentions "multi-tenancy", "database design", "service architecture",
  "API design", "deployment architecture", or asks about trade-offs between technical approaches.
  Produces ADRs, system architecture overview, data model, and API contracts.
version: 0.1.0
---

# wavecraft:architect — Architecture Decisions

Make and document significant architectural decisions. Evaluates options with trade-offs, produces Architecture Decision Records (ADRs), and maintains the system architecture overview, data model, and API contracts. Ensures that architectural choices are explicit, reasoned, and traceable.

## Why This Matters

Architectural decisions made implicitly during implementation become invisible technical debt. When Claude Code picks a database strategy, a caching approach, or an API pattern without a documented decision, future sessions have no context for why things are the way they are. ADRs make the reasoning durable — they survive context windows, team changes, and time.

## When to Trigger

- "architecture decision", "write an ADR", "design the system"
- "data model", "API contract", "system design"
- "how should we structure this"
- When a feature spec requires a new architectural pattern
- When two implementation approaches have significant trade-offs

## Workflow

### Step 1: Read Context Files (Mandatory)

```
Read (mandatory):
├── DISCUSSION-LOG.md              → Previous decisions and context
│   (or PROJECT-LOG.md)
├── PROCESS.md                     → Current lifecycle phase
│   (or PROJECT-LOG.md)

Read (if they exist):
├── docs/architecture/*.md         → Existing ADRs (don't contradict without superseding)
├── docs/architecture/ARCHITECTURE.md → System overview
├── docs/architecture/DATA-MODEL.md   → Current database schema
├── docs/api/openapi.yaml          → Current API contracts
├── docs/features/*.md             → Feature specs (what needs to be supported)
└── CLAUDE.md                      → Tech stack and conventions
```

**Bootstrap mode:** If context files don't exist, create them minimally. Then proceed.

### Step 2: Identify Decision Scope

Ask the user:
1. **What architectural decision are we making?** Get a clear description.
2. **Why is this decision needed now?** What triggered it — new feature, performance issue, scaling concern, tech debt?
3. **What constraints exist?** Budget, timeline, team skills, existing infrastructure, compliance requirements.

### Step 3: Document Context

Write the context section of the ADR:
- Why is this decision needed?
- What problem does it solve?
- What constraints apply?
- What has been tried before (if anything)?

### Step 4: Evaluate Options

Present at least 2 alternatives with honest trade-offs:

```
For each option:
├── Name and brief description
├── Pros (specific, not generic)
├── Cons (specific, not generic)
├── Cost / complexity (low / medium / high)
├── Impact on existing code (none / minor refactor / major changes)
├── Team familiarity (high / medium / low — learning curve?)
└── Risk assessment (what could go wrong?)
```

**Rules for option evaluation:**
- Always include at least 2 options (even if one is clearly better — document why)
- Be honest about cons — don't soft-pedal the downsides of the recommended option
- Include "do nothing" as an option if the status quo is viable
- Consider both short-term implementation cost and long-term maintenance cost

Walk through options with the user. Get their input before making a recommendation.

### Step 5: Make Recommendation

State the recommended option clearly with rationale:
- Why this option over the alternatives
- What trade-offs are accepted
- What risks are acknowledged and how they'll be mitigated

### Step 6: Define Consequences

```markdown
## Consequences
- Positive: [what gets better — be specific]
- Negative: [what gets harder or what's sacrificed — be honest]
- Risks: [what could go wrong and how likely]
- Reversibility: [how hard to change this decision later — easy / moderate / difficult]
```

### Step 7: Define Performance Budgets (If Applicable)

If the decision affects performance:

```markdown
## Performance Budgets
- API response time: [target, e.g., <200ms for reads, <500ms for writes]
- Page load time: [target, e.g., <2s first meaningful paint]
- Database query time: [target, e.g., <50ms for indexed queries]
- Bundle size: [target, e.g., <250KB initial JS]
- Memory usage: [target, if relevant]
```

### Step 8: Deployment Readiness Check

For decisions that affect infrastructure:

```markdown
## Deployment Considerations
- Where does this run? [Vercel, Railway, AWS, Docker, etc.]
- Environment variables needed: [list new env vars]
- Secrets management: [how are secrets stored and accessed?]
- CI/CD impact: [new pipeline steps? build changes?]
- Monitoring: [what needs to be monitored? alerts?]
- Rollback strategy: [how to revert if something goes wrong]
```

### Step 9: Create/Update API Contracts (If Applicable)

If the decision introduces or changes API endpoints:
- Update `docs/api/openapi.yaml` with new endpoint definitions
- Ensure request/response schemas reflect the architectural decision
- Document authentication and authorization requirements

### Step 10: Produce ADR

Write the ADR to `docs/architecture/ADR-0XX-[name].md`:

```markdown
# ADR-0XX: [Decision Title]

## Status: [Proposed | Accepted | Deprecated | Superseded by ADR-0YY]

## Date: [date]

## Context
[Why is this decision needed? What problem does it solve?
What constraints exist? — from Step 3]

## Options Considered

### Option A: [Name]
- Pros: [list]
- Cons: [list]
- Cost/complexity: [low/medium/high]

### Option B: [Name]
- Pros: [list]
- Cons: [list]
- Cost/complexity: [low/medium/high]

## Decision
[Which option was chosen and why — from Step 5]

## Consequences
- Positive: [what gets better]
- Negative: [what gets harder]
- Risks: [what could go wrong]

## Performance Budgets
[If applicable — from Step 7]

## Deployment Considerations
[If applicable — from Step 8]

## Related
- Specs: [which feature specs this affects]
- ADRs: [related architecture decisions]
```

### Step 11: Update Architecture Overview

If the decision changes the system's overall architecture, update `docs/architecture/ARCHITECTURE.md`:
- Update system diagrams (described in text/ascii)
- Update component relationships
- Update data flow descriptions

If ARCHITECTURE.md doesn't exist and this is the first significant architecture decision, create it.

### Step 12: Update Data Model

If the decision changes the database schema, update `docs/architecture/DATA-MODEL.md`:
- Add new tables/columns
- Update relationships
- Document constraints and indexes

### Step 13: Run Architecture Review Checklist

Before finalizing, verify:

```
Architecture Review:
├── [ ] Decision is clearly stated (someone new can understand it)
├── [ ] At least 2 options were considered with honest trade-offs
├── [ ] Consequences include both positive and negative
├── [ ] Decision aligns with existing ADRs (or explicitly supersedes them)
├── [ ] Performance budgets defined (if applicable)
├── [ ] Deployment impact assessed (if applicable)
├── [ ] No contradiction with CLAUDE.md conventions
├── [ ] Feature specs that depend on this are identified
└── [ ] Rollback strategy exists (if high-risk decision)
```

### Step 14: Update Discussion Log

Append to DISCUSSION-LOG.md (or PROJECT-LOG.md):

```markdown
## [date] — Architecture: ADR-0XX [Decision Title]

**Decision:** [one-line summary of what was decided]
**Rationale:** [brief — why this option over alternatives]
**Impact:** [which specs/features are affected]
**Next:** [what happens now — implementation, more decisions, etc.]
```

## Adaptation

**Single feature (Scenario B):**
Only create an ADR if the feature introduces a genuinely new pattern. Don't rewrite ARCHITECTURE.md for a routine feature addition. A quick note in the spec's implementation notes may suffice for minor decisions.

**Process automation (Scenario D):**
Focus on integration architecture, data flow between systems, and error handling. API contracts may become integration contracts (webhooks, event schemas, file formats).

**Early-stage project:**
Create ARCHITECTURE.md alongside the first ADR. Keep it light — it'll grow as decisions accumulate.

**Superseding a previous ADR:**
Mark the old ADR as "Deprecated — Superseded by ADR-0YY." Create the new ADR with full context including why the previous decision is being changed.

## Reference Files

| Reference | When to Read |
|-----------|-------------|
| `references/adr-template.md` | When producing the ADR (Step 10) |
| `references/architecture-review-checklist.md` | When running the review checklist (Step 13) |
