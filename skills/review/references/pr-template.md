# PR Description Template

Use this template when producing the GitHub PR description in Step 15 of the :review workflow.

```markdown
## Summary
[2-3 sentences: what this PR implements and why. Reference the feature spec.]

Implements: docs/features/F0XX-[name].md

## Changes

### Backend
- [Key backend change 1]
- [Key backend change 2]

### Frontend
- [Key frontend change 1]
- [Key frontend change 2]

### Tests
- [N] new tests added
- Coverage: [X]% on changed files (target: 85%)

## Acceptance Criteria

| AC | Description | Status |
|----|-------------|--------|
| AC-001 | [description] | ✅ |
| AC-002 | [description] | ✅ |
| AC-010 | [description] | ⚠️ [note] |

[X/Y] criteria verified

## QA Summary

| Check | Status |
|-------|--------|
| Tests | ✅ All passing |
| Coverage | ✅ [X]% |
| Security | ✅ No issues |
| Accessibility | ✅ / N/A |
| Performance | ✅ No issues |
| Dependencies | ✅ No vulnerabilities |
| Browser Validation | ✅ [roles tested] |

## Screenshots
[Include screenshots from browser validation if UI feature]

## How to Test Manually
1. [Specific step 1]
2. [Specific step 2]
3. [Expected result]

## Notes for Reviewer
[Anything the reviewer should pay special attention to]
[Known limitations or trade-offs]
[Spec gaps discovered during implementation]
```

## Rules

1. Keep the summary concise — the spec has the details
2. Always link to the feature spec
3. AC status table must match the QA Report
4. "How to Test" should be specific enough for a reviewer unfamiliar with the feature
5. Include screenshots for ANY UI change
6. Note spec gaps — these should be addressed in a follow-up
