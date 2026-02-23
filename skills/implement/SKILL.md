---
name: implement
description: >
  The core implementation skill. Reads a feature spec, enforces TDD, manages context through
  session logs, and produces working code with tests. This skill should be used when the user
  says "implement F004", "build this feature", "start coding", "implement the [feature name]",
  "work on [feature]", or any variation of starting implementation. Also trigger on "continue
  implementing" or "continue" (resumes from SESSION-LOG.md). This skill refuses to start coding
  without a feature spec — specs are the input, code is the output.
version: 0.1.0
---

# wavecraft:implement — Feature Implementation

Read a feature spec. Break it into tasks. Implement each task using TDD. Verify after every task. Commit atomically. Maintain session continuity through SESSION-LOG.md. This is the core skill that turns specs into working code.

## Why This Matters

Without this skill, Claude Code implements features based on vague descriptions, makes assumptions about edge cases, invents error handling, and produces code that's hard to verify against requirements. With this skill, every line of code traces back to a spec, every behavior has a test, and every session can be resumed exactly where it left off.

## When to Trigger

**Starting implementation:**
- "implement F004", "build this feature", "start coding"
- "implement the organization management feature"
- "work on [feature name]"

**Resuming implementation:**
- "continue implementing", "continue", "resume"
- "pick up where we left off"
- (Skill reads SESSION-LOG.md and resumes from recorded state)

## Workflow

### Step 1: Check for Resume State

Read SESSION-LOG.md (if it exists). If it contains an active task and in-progress work:

**Resume path:** Skip steps 2-5. Read the "Next Steps" section and resume from the recorded state. Tell the user: "Resuming from last session. You were working on [feature]. Completed: [X]. Next up: [Y]."

**Fresh start path:** No SESSION-LOG.md or no active task — proceed to Step 2.

### Step 2: Read the Feature Spec (Mandatory)

**Refuse to start coding without a spec file.** Ask the user: "Which feature spec should I implement? (e.g., F004)"

Read the spec from `docs/features/F0XX-[name].md`. If the file doesn't exist, tell the user and suggest running `wavecraft:spec` first.

### Step 3: Verify Spec Completeness

Check that all required sections are present in the spec:

```
Verify:
├── Overview                           → Present?
├── User Roles                         → Present?
├── Acceptance Criteria                → Present? (EARS or Gherkin — both valid)
│   ├── At least 3 error handling ACs  → Present?
│   └── At least 2 edge cases          → Present?
├── Data Model                         → Present (or N/A with reason)?
├── API Endpoints                      → Present (or N/A with reason)?
├── UI Components                      → Present (or N/A with reason)?
├── Accessibility                      → Present (or N/A with reason)?
├── i18n                               → Present (or N/A with reason)?
├── Dependencies                       → Present?
└── Out of Scope                       → Present?
```

If incomplete, flag the gaps: "The spec is missing [sections]. Should I proceed with assumptions, or fix the spec first?" Document any assumptions in SESSION-LOG.md.

### Step 4: Read Supporting Documents

```
Read (if they exist):
├── docs/architecture/ADR-*.md         → Relevant architecture decisions
├── docs/architecture/ARCHITECTURE.md  → System overview
├── docs/architecture/DATA-MODEL.md    → Existing schema
├── docs/api/openapi.yaml              → Existing API contracts
├── CLAUDE.md                          → Project conventions and commands
└── .claude/rules/                     → Enforcement rules
```

### Step 5: Read Existing OpenAPI Spec

If `docs/api/openapi.yaml` exists, read it to understand existing API patterns and avoid conflicts. New endpoints must follow the same conventions.

### Step 6: Create Implementation Plan (XML Task Format)

Break the spec into ordered tasks using the XML task format. Every task must have these fields:

```xml
<task id="1" depends="">
  <name>Create requirements migration</name>
  <files>backend/Modules/Requirements/Database/Migrations/</files>
  <action>Create migration with columns: id, evaluation_id, category,
    title, description, priority, status, timestamps, soft_deletes</action>
  <verify>php artisan migrate --pretend 2>&1 | grep -q requirements</verify>
  <done>Migration file exists and dry-run succeeds</done>
</task>

<task id="2" depends="1">
  <name>Create Requirement model + factory</name>
  <files>backend/Modules/Requirements/Models/Requirement.php</files>
  <action>Create Eloquent model with fillable, casts, relationships.
    Create factory with realistic fake data.</action>
  <verify>php artisan tinker --execute="Requirement::factory()->make()"</verify>
  <done>Model instantiates, factory produces valid data</done>
</task>
```

**Rules for task breakdown:**
- Each task modifies a small, focused set of files
- Each task has a `<verify>` step that completes in <60 seconds (Nyquist Rule)
- Tasks declare dependencies (`depends="1,2"` for tasks that need prior tasks)
- Tasks are ordered: data layer → API layer → business logic → frontend → integration
- If you can't write a `<verify>` step, the task is too vague — break it down further

**Show the plan to the user.** Get confirmation before starting implementation.

### Step 7: Validate Nyquist Rule

Review every task's `<verify>` step:

| Check | Pass | Fail |
|-------|------|------|
| Verify step exists | ✅ | Break the task down further |
| Verify completes in <60 seconds | ✅ | Simplify the verification or split the task |
| Verify is automated (not manual) | ✅ | Write an automated check or add a test |
| Verify tests the right thing | ✅ | Ensure it tests the task's `<done>` criteria |

### Step 8: Assess Wave Strategy

Count the tasks in the plan:

| Task Count | Strategy | Action |
|------------|----------|--------|
| 1-10 tasks | Single session | Proceed normally |
| 10-20 tasks | Consider waves | Ask user: "This is a larger feature. Want to split into waves (fresh context per wave) or try it in one session?" |
| 20+ tasks | Waves required | Split into waves of 5-8 tasks each. Group by layer: data → API → business logic → frontend → integration |

**Wave execution:** Each wave runs with fresh context. Between waves, update SESSION-LOG.md with everything completed so far. The next wave reads SESSION-LOG.md + the spec + git history — not the previous wave's full conversation.

### Step 9: For Each Task — Write Tests FIRST (TDD Red Phase)

Before writing any implementation code, write the tests that define correct behavior:

```
For each acceptance criterion covered by this task:
1. Write a test that asserts the expected behavior
2. Run the test → it MUST FAIL (red)
3. If the test passes without implementation, the test is wrong — fix it
```

**What to test:**
- Happy path (the thing works as expected)
- Error cases from the spec's error handling ACs
- Edge cases from the spec's edge case ACs
- Authorization (correct role can do the thing, wrong role gets 403)
- Validation (invalid input gets proper error messages)

**Test naming convention:** Follow the project's convention from `.claude/rules/testing.md`. If no convention exists, use descriptive names: `test_user_can_create_organization_with_valid_data`

### Step 10: For Each Task — Implement (TDD Green Phase)

Write the minimum code necessary to make the failing tests pass:

```
1. Implement the code
2. Run the tests → they must PASS (green)
3. If tests still fail, fix the implementation (not the tests)
4. Do not add functionality beyond what the tests require
```

**Rules during implementation:**
- Follow conventions from CLAUDE.md and `.claude/rules/`
- Use patterns from existing code (read it first)
- No hardcoded values — use config/env
- Proper error handling on all code paths
- Input validation on all API endpoints
- Authorization checks (policies/gates) where spec requires

### Step 11: For Each Task — Verify

Run the task's `<verify>` step. It must pass in <60 seconds.

```
If verify PASSES:
  → Proceed to Step 12 (refactor)

If verify FAILS:
  → Diagnose the issue
  → Fix the implementation (keep tests green)
  → Re-run verify
  → Do NOT proceed to the next task with a failing verify
  → If stuck after 3 attempts: log the blocker in SESSION-LOG.md,
    mark the task as blocked, and suggest wavecraft:handoff
```

### Step 12: For Each Task — Refactor (TDD Blue Phase)

With tests green, clean up the code:

- Remove duplication
- Improve naming
- Simplify complex logic
- Extract shared patterns

**Critical rule:** Run tests after every refactoring change. If tests break during refactor, **revert the refactor immediately.** Tests must stay green. Refactoring is optional; passing tests are not.

### Step 13: For Each Task — Atomic Commit

One commit per completed task:

```bash
git add [specific files for this task]
git commit -m "feat(module): description (task N/M)"
```

**Commit message format:** `type(scope): description (task N/M)`
- `type`: feat, fix, test, refactor, docs, chore
- `scope`: module or feature name
- `N/M`: task number / total tasks (e.g., "task 3/8")

Do not batch commits. Do not skip commits. Every task = one commit. This gives you `git bisect` for free and makes every change independently revertable.

### Step 14: Update SESSION-LOG.md (After Each Task)

Update SESSION-LOG.md **after each completed task**, not just at the end of the session. This is the safety net — if the session crashes or context gets too large, no progress is lost.

Update these sections:
- "Completed This Session" — add the just-finished task
- "In Progress" — update to the next task
- "Files Modified" — add files changed in this task

### Step 15: Browser Validation — Smoke Test (If UI Feature)

**This is a developer smoke test during implementation** — quick verification that things render and work. (Full QA validation happens in `wavecraft:review`.)

**For UI features:**
1. Launch the app (or confirm it's running)
2. Navigate to the feature
3. Click through the happy path as the primary user role from the spec
4. Verify it renders correctly
5. Test one error path
6. Capture screenshots

**For backend-only features:**
Call the API endpoints with real HTTP requests (curl, httpie, or API client). Validate response shapes against the spec's API endpoint definitions.

**Fallback chain:**
1. **Preferred:** Playwright MCP or Chrome Extension (automated browser interaction)
2. **If unavailable:** Output a manual verification checklist and ask the user to confirm each item

The `:setup` skill should have verified browser automation availability during project setup. If it wasn't checked, note it as a gap.

### Step 16: Update openapi.yaml

If any API endpoints were added or changed during implementation:

1. Read `docs/api/openapi.yaml`
2. Add or update the endpoint definitions to match what was actually built
3. Ensure request/response schemas match the implementation
4. Commit the updated openapi.yaml

If the project doesn't use OpenAPI, skip this step.

### Step 17: At Session End — Update DEV-LOG.md

Append a session summary to DEV-LOG.md:

```markdown
## [YYYY-MM-DD] Implementation: F0XX — [Feature Name]

**Tasks completed:** [N/M]
**Tests added:** [count]
**Test status:** All passing / [N] failing
**Coverage:** [X]% (target: 85%)
**Key decisions:** [brief list]
**Status:** [in-progress / completed / blocked]
**Next:** [one-line pointer to next steps]
```

### Step 18: At Session End — Final SESSION-LOG.md Update

Write the complete session state including:
- All completed tasks
- Current task state (if mid-task)
- All decisions made during implementation
- Context health assessment
- Next steps detailed enough for a fresh session to resume immediately

Read `references/session-log-guide.md` for the complete SESSION-LOG.md format.

## Error Recovery

**If `<verify>` fails:** Diagnose, fix implementation (keep TDD green), re-run verify. Do NOT proceed with a failing verify. After 3 failed attempts, log the blocker and suggest `:handoff`.

**If blocked (dependency missing, unclear spec, environment issue):** Update SESSION-LOG.md with the blocker. Mark the task as blocked. Suggest `:handoff` to save progress. Do NOT silently skip the task.

**If tests break during refactor (Step 12):** Revert the refactor immediately. Tests must stay green. Refactoring is optional; passing tests are not.

**If browser validation fails (Step 15):** Log the issue, attempt a fix, re-validate. If the fix requires spec changes, flag it as a spec gap and note in SESSION-LOG.md.

**If context gets too large:** See Context Management below. Do a `:handoff` to save progress.

## Context Management (Best Effort — Heuristic)

Claude cannot directly read its token count (no context-awareness API). These thresholds are estimated using proxy signals.

| Signal | Healthy | Getting Large | Too Large |
|--------|---------|---------------|-----------|
| Tool calls this session | <20 | 20-40 | >40 |
| Conversation turns | <30 | 30-60 | >60 |
| Response quality | Sharp, focused | Occasional repetition | Forgetting earlier context |

**At "Getting Large" (~70% estimated):**
- Proactively suggest `/compact`
- Update SESSION-LOG.md first (safety net before compaction)
- Tell user: "Context is getting large. I'll update SESSION-LOG.md, then suggest /compact."

**At "Too Large" (~80% estimated):**
- Strongly recommend starting a new session
- Ensure SESSION-LOG.md is complete and detailed
- Tell user: "Context is stretched. I recommend a handoff and fresh session. SESSION-LOG.md is ready for seamless resume."

**One feature per session.** If the feature is too large, implement one wave per session.

## Adaptation

**Resuming (continue implementing):** Read SESSION-LOG.md first. Skip steps 2-5. Resume from last recorded state. Tell user what was completed and what's next.

**Backend-only (Scenario C):** TDD uses the project's backend test runner (PHPUnit, pytest, go test, etc.). Skip browser validation for frontend. Use API calls for validation instead.

**Frontend-only:** TDD uses React Testing Library, Vitest, or the project's frontend test runner. Browser validation is especially important.

**Process automation (Scenario D):** Replace "API endpoints" with "integration points." Replace "browser validation" with "process execution validation" (trigger the process, verify the output).

**Large feature (>10 tasks):** Use wave-based execution. Each wave gets fresh context. SESSION-LOG.md is the bridge between waves.

## Reference Files

| Reference | When to Read |
|-----------|-------------|
| `references/xml-task-format.md` | When creating the implementation plan (Step 6) |
| `references/tdd-workflow.md` | When the developer needs TDD guidance (Steps 9-12) |
| `references/session-log-guide.md` | When updating SESSION-LOG.md (Steps 14, 18) |
| `references/wave-execution.md` | When the feature requires wave-based execution (Step 8) |
