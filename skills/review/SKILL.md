---
name: review
description: >
  Comprehensive QA review of a completed feature. Compares implementation against spec, runs the
  full QA checklist, checks coverage, performs browser validation, and prepares a PR description.
  This skill should be used when the user says "review this feature", "prepare for PR", "QA check",
  "is this ready for review?", "check my work", "run the QA checklist", or any variation of
  reviewing a completed implementation. Also trigger when a feature implementation is complete
  and the next step is merging.
version: 0.1.0
---

# wavecraft:review — Quality Assurance & PR Preparation

Comprehensive QA review that compares implementation against the feature spec. Verifies every acceptance criterion, runs security/performance/accessibility checklists, performs browser validation with role-based walkthroughs, and produces a QA Report + PR Description ready for human review.

## Why This Matters

Passing tests prove code correctness in isolation. This skill proves the feature works as users would experience it, meets security standards, follows project conventions, and is documented for reviewers. Without structured QA, features get merged with gaps that only surface in production.

## When to Trigger

- "review this feature", "prepare for PR", "QA check"
- "is this ready for review?", "check my work"
- "run the QA checklist"
- After `wavecraft:implement` completes a feature

## Workflow

### Step 1: Identify the Feature Spec

Ask the user which feature to review: "Which feature should I review? (e.g., F002)"

Read the spec from `docs/features/F0XX-[name].md`. This is the source of truth — the implementation is reviewed against it.

### Step 2: Read Implementation Context

```
Read:
├── docs/features/F0XX-[name].md     → The spec (source of truth for review)
├── SESSION-LOG.md                    → What was implemented and any known issues
├── DEV-LOG.md                        → Implementation history and decisions
├── docs/api/openapi.yaml             → API documentation (if applicable)
├── CLAUDE.md                         → Project conventions
└── .claude/rules/                    → Enforcement rules
```

### Step 3: Run Full Test Suite

Run the project's test suite. This must pass before any other review step.

```bash
# Use the test command from CLAUDE.md
# e.g., php artisan test, pytest, npm test, go test ./...
```

**If tests fail:** Stop and report. Do not proceed with the rest of the review. The developer needs to fix failing tests first.

Record: total tests, passing, failing, coverage percentage.

### Step 4: Check Test Coverage

Compare coverage against the project's target (default ≥85% for changed files):

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Changed files coverage | ≥85% | [X]% | ✅ / ❌ |
| New modules coverage | ≥90% | [X]% | ✅ / ❌ |
| Overall project coverage | ≥80% | [X]% | ✅ / ❌ |

If coverage is below target, identify which files or branches are under-tested.

### Step 5: Verify Each Acceptance Criterion

Go through the spec's acceptance criteria one by one. For each AC:

1. Find the test(s) that verify this criterion
2. Confirm the test actually tests the right behavior (not just a passing test that tests something else)
3. Mark the AC as: ✅ implemented / ❌ missing / ⚠️ partial

```markdown
## Acceptance Criteria Verification
- AC-001: ✅ User can create organization — verified by test_user_can_create_organization
- AC-002: ✅ Duplicate slug returns 409 — verified by test_duplicate_slug_returns_409
- AC-003: ⚠️ Member can view but not edit — view test exists, edit restriction test missing
- AC-010: ✅ Invalid input returns validation errors — verified by test_validation_errors
- AC-020: ❌ Empty state shows onboarding message — no test, not implemented
```

This is the core of the review: **does the implementation match the spec?** Verification works the same regardless of whether ACs use EARS or Gherkin format.

### Step 6: Run Code Quality Checklist

```
Code Quality:
├── [ ] Follows project conventions (CLAUDE.md rules)
├── [ ] No hardcoded values (uses config/env)
├── [ ] Error handling is comprehensive
├── [ ] Input validation on all endpoints
├── [ ] No N+1 query issues (check eager loading)
├── [ ] Proper use of database transactions (where needed)
├── [ ] No over-engineering or unnecessary abstractions
├── [ ] Code survival check: will this code last >2 weeks?
```

### Step 7: Run Security Checklist

```
Security:
├── [ ] Auth required on all private endpoints
├── [ ] Authorization checks (policies/gates) on all state-changing operations
├── [ ] SQL injection prevention (parameterized queries only)
├── [ ] XSS prevention (output encoding on all user-generated content)
├── [ ] CSRF protection on state-changing operations
├── [ ] No secrets in code, logs, or error messages
├── [ ] No MCP prompt injection vulnerabilities
├── [ ] Rate limiting on public or sensitive endpoints
```

### Step 8: Run Accessibility Checklist (If Applicable)

Skip if backend-only (mark N/A with reason).

```
Accessibility:
├── [ ] Keyboard navigation works for all interactive elements
├── [ ] ARIA labels on icons and buttons without visible text
├── [ ] Focus management after modal open/close, page navigation
├── [ ] Color contrast meets WCAG 2.1 AA (4.5:1 text, 3:1 UI)
├── [ ] Screen reader tested on key workflows
├── [ ] Error messages linked to form fields (aria-describedby)
├── [ ] Skip navigation link present (if new page)
```

### Step 9: Run Performance Checklist

```
Performance:
├── [ ] Database indexes on queried/filtered columns
├── [ ] Pagination on list endpoints (no unbounded queries)
├── [ ] Eager loading for relationships (no N+1)
├── [ ] Cache strategy for read-heavy data (if applicable)
├── [ ] API response time within budget (<200ms reads, <500ms writes)
├── [ ] Bundle size within budget (<250KB initial, if frontend)
├── [ ] No unnecessary re-renders (if React/Vue)
```

### Step 10: Run Dependency Check

```bash
# Check for known vulnerabilities
npm audit          # JavaScript
composer audit     # PHP
pip-audit          # Python
govulncheck ./...  # Go
```

Report any vulnerabilities found: severity, affected package, available fix.

### Step 11: Browser Validation — Formal QA (Role-Based)

**This is the full QA validation before PR** — more thorough than the smoke test in `:implement`.

**For UI features:**

1. Launch the app (or confirm it's running)
2. Read the spec's User Roles section
3. **For EACH role defined in the spec:**
   - Adopt that role (log in as that user type)
   - Walk through the happy path as that role
   - Test role-specific restrictions (what they CAN'T do)
   - Test error paths relevant to that role
   - Capture screenshots
4. Assess UX: labels clear? Navigation intuitive? Feedback after actions? Permission errors helpful? Empty states present?
5. Check responsive behavior (if applicable)
6. Compare actual behavior against spec expectations

**For backend-only features:**
Call ALL endpoints with real HTTP requests. Validate:
- Response status codes match spec
- Response shapes match spec/openapi.yaml
- Error responses have proper format
- Authorization returns 403 for wrong roles
- Validation returns proper error messages

**Fallback chain:**
1. **Preferred:** Playwright MCP or Chrome Extension (automated)
2. **If unavailable:** Output a manual verification checklist with specific test cases per role and ask the user to confirm each item

### Step 12: Check API Documentation

If the feature includes API endpoints:

```
API Documentation:
├── [ ] docs/api/openapi.yaml is updated
├── [ ] New endpoints are documented with request/response schemas
├── [ ] Modified endpoints have updated documentation
├── [ ] Response examples match actual implementation
├── [ ] Error responses are documented
```

### Step 13: Flag Spec Gaps

During the review, you may discover:
- Behaviors not covered by any AC (implementation added something the spec didn't specify)
- ACs that couldn't be verified (ambiguous or untestable)
- Edge cases found during browser validation that the spec didn't anticipate

Document these as "Spec Gaps" in the QA Report. These should feed back to the spec for future reference.

### Step 14: Produce QA Report

Write the QA Report. This is the comprehensive artifact that summarizes the entire review.

```markdown
# QA Report: F0XX — [Feature Name]

## Date: [date]
## Spec: docs/features/F0XX-[name].md
## Reviewer: Claude + [user name]

## Test Results
- Total tests: [N]
- Passing: [N]
- Failing: [N]
- Coverage: [X]% (target: 85%)

## Acceptance Criteria Verification
- AC-001: ✅ [description] — verified by [test name]
- AC-002: ✅ [description] — verified by [test name]
- AC-010: ⚠️ [description] — partially implemented: [what's missing]
- AC-020: ❌ [description] — not implemented

## Browser Validation
- App running: ✅ / ❌
- Primary role ([role name]): ✅ / ❌ — [notes, screenshots]
- Secondary role ([role name]): ✅ / ❌ — [permissions verified?]
- Error path tested: ✅ / ❌ — [which error path]
- UX assessment: [labels? navigation? feedback? permission errors? empty states?]
- Visual issues found: [none / list issues]
- For backend-only: API endpoints validated via HTTP: ✅ / ❌

## Quality Checks
| Category | Status | Notes |
|----------|--------|-------|
| Code Quality | ✅ / ⚠️ / ❌ | [details] |
| Security | ✅ / ⚠️ / ❌ | [details] |
| Accessibility | ✅ / ⚠️ / ❌ / N/A | [details] |
| Performance | ✅ / ⚠️ / ❌ | [details] |
| Dependencies | ✅ / ⚠️ / ❌ | [details] |
| Browser Validation | ✅ / ⚠️ / ❌ / N/A | [details] |
| API Documentation | ✅ / ⚠️ / ❌ | [details] |

## Spec Gaps Found
[Behaviors discovered during implementation not covered by spec]

## Recommendation
[Ready for PR / Needs fixes first (list what) / Needs spec update (list what)]
```

### Step 15: Produce PR Description

Generate a GitHub PR description formatted for easy human review:

```markdown
## Summary
[2-3 sentences: what this PR implements and why]

## Feature Spec
[Link to docs/features/F0XX-[name].md]

## Changes
- [Key change 1]
- [Key change 2]
- [Key change 3]

## Acceptance Criteria Status
- [X/Y] acceptance criteria verified ✅
- [list any ⚠️ or ❌ items]

## Test Coverage
- [N] tests added
- Coverage: [X]% on changed files

## QA Status
[Summary of QA Report: all checks pass / issues found]

## Screenshots
[If UI feature: include screenshots from browser validation]

## How to Test
1. [Step-by-step manual test instructions for the reviewer]
```

### Step 16: Update DEV-LOG.md

Append QA results:

```markdown
## [YYYY-MM-DD] QA Review: F0XX — [Feature Name]

**Result:** [Ready for PR / Needs fixes]
**ACs verified:** [X/Y]
**Coverage:** [X]%
**Issues found:** [none / list]
**Spec gaps:** [none / list]
```

## Adaptation

**Backend-only (Scenario C):** Skip accessibility checklist. Replace browser validation with API endpoint validation. Skip frontend performance checks. Focus on API response times, database queries, and security.

**Frontend-only:** Skip API endpoint validation. Focus on component testing, accessibility, responsive behavior, and browser validation.

**Partial implementation (not all ACs done):** Still run the full review on what's been implemented. Flag missing ACs. The QA Report will show the feature is partially complete — this is useful information for the PR and for planning the remaining work.

**Quick review (small change):** The full checklist may be overkill for a 1-file change. The skill should assess scope and suggest: "This is a small change. Want the full QA checklist or a focused review on [relevant areas]?" If focused: run only relevant checklist items and still verify ACs.

## Reference Files

| Reference | When to Read |
|-----------|-------------|
| `references/qa-checklist-full.md` | For the complete checklist with all items expanded |
| `references/pr-template.md` | For the PR description template |
