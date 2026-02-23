# ADR Template

Write ADRs to `docs/architecture/ADR-0XX-[name].md`.

```markdown
# ADR-0XX: [Decision Title]

## Status: [Proposed | Accepted | Deprecated | Superseded by ADR-0YY]

## Date: [date]

## Context
[Why is this decision needed? What problem does it solve?
What constraints exist? What triggered the need for this decision?]

## Options Considered

### Option A: [Name]
- Description: [brief explanation]
- Pros: [specific benefits]
- Cons: [specific drawbacks]
- Cost/complexity: [low/medium/high]
- Team familiarity: [high/medium/low]

### Option B: [Name]
- Description: [brief explanation]
- Pros: [specific benefits]
- Cons: [specific drawbacks]
- Cost/complexity: [low/medium/high]
- Team familiarity: [high/medium/low]

### Option C: Do Nothing (if viable)
- Pros: No implementation cost, no risk
- Cons: [why this is insufficient]

## Decision
[Which option was chosen and the reasoning behind it.
Reference specific pros/cons from above.]

## Consequences
- Positive: [what gets better — be specific]
- Negative: [what gets harder or what we sacrifice — be honest]
- Risks: [what could go wrong, likelihood, and mitigation]
- Reversibility: [easy / moderate / difficult to change later]

## Performance Budgets
[If this decision affects performance:]
- API response time: [target]
- Database query time: [target]
- Page load time: [target]
- Bundle size: [target]

## Deployment Considerations
[If this decision affects infrastructure:]
- Environment: [where this runs]
- New env vars: [list]
- CI/CD changes: [list]
- Monitoring: [what to watch]
- Rollback: [how to revert]

## Related
- Specs: [feature specs affected by this decision]
- ADRs: [related or superseded ADRs]
- External: [relevant documentation, blog posts, benchmarks]
```

## Numbering Convention

ADRs are numbered sequentially: ADR-001, ADR-002, etc. Never reuse a number. Deprecated ADRs keep their number and get a status update — they're part of the decision history.

## Status Lifecycle

```
Proposed → Accepted → [lives as accepted]
                   → Deprecated (superseded by ADR-0YY)
                   → Deprecated (no longer relevant)
```
