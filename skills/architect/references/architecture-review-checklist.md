# Architecture Review Checklist

Run this checklist before finalizing any ADR.

## Decision Quality
- [ ] Decision is clearly stated — someone new to the project can understand it
- [ ] Context explains WHY this decision is needed (not just what was decided)
- [ ] At least 2 options were considered with honest pros/cons
- [ ] "Do nothing" was considered as an option (even if rejected)
- [ ] Trade-offs are explicitly stated (not hidden or minimized)

## Consistency
- [ ] Decision aligns with existing ADRs (or explicitly supersedes them)
- [ ] Decision doesn't contradict CLAUDE.md conventions
- [ ] If superseding an older ADR, the old ADR is marked as deprecated
- [ ] Decision fits the project's tech stack and team capabilities

## Completeness
- [ ] Consequences include BOTH positive AND negative impacts
- [ ] Risks are identified with likelihood and mitigation strategies
- [ ] Reversibility is assessed (how hard to change this later?)
- [ ] Affected feature specs are identified
- [ ] Performance budgets defined (if the decision affects performance)
- [ ] Deployment impact assessed (if the decision affects infrastructure)

## Practicality
- [ ] Decision is implementable with current team and resources
- [ ] Implementation cost is proportional to the benefit
- [ ] No over-engineering — the simplest approach that meets the requirements
- [ ] Rollback strategy exists for high-risk decisions

## Documentation
- [ ] ADR follows the standard template format
- [ ] ADR number is unique and sequential
- [ ] ARCHITECTURE.md is updated if system structure changed
- [ ] DATA-MODEL.md is updated if schema changed
- [ ] openapi.yaml is updated if API contracts changed
- [ ] DISCUSSION-LOG.md is updated with the decision summary
