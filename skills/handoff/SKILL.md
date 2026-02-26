---
name: handoff
description: >
  Cleanly end a Claude session by documenting everything needed for the next session to resume
  immediately. This skill should be used when the user says "save my progress", "session handoff",
  "wrap up session", "end session", "pause work", "I need to stop", or any variation of ending
  a work session. Also trigger when Claude detects high context usage (many tool calls, long
  conversation, degrading response quality) — suggest handoff proactively. This skill is the
  mechanism that makes session continuity possible across the Wavecraft framework.
version: 0.1.0
---

# wavecraft:handoff — Session Handoff

Cleanly end a session by documenting everything needed for the next session to resume immediately. This skill writes SESSION-LOG.md (current state) and appends to DEV-LOG.md (cumulative history), ensuring no context is lost between sessions.

## Why This Matters

Without a structured handoff, every new Claude session starts blind. The developer has to re-explain context, re-describe decisions, and re-state progress. With handoff, the next session reads SESSION-LOG.md and is productive within the first minute. This is the single most impactful habit in agentic engineering — it turns Claude from a stateless tool into a collaborator with memory.

## When to Trigger

**User-initiated:**
- "save my progress", "handoff", "wrap up", "end session", "I'm done for today"
- "pause work", "I need to stop", "save state"

**Proactive suggestion (don't auto-invoke — ask first):**
- Estimated high context usage (heuristic: >40 tool calls or >90 minutes of conversation)
- Response quality appears to be degrading (repetition, losing track of state)
- User mentions context concerns ("is context getting large?", "should we start fresh?")

When suggesting proactively, say: "We've been going a while. Want me to do a session handoff to save progress before we continue or wrap up?"

## Workflow

### Step 1: Read Current State

Before writing anything, gather the full picture:

```
Read (if they exist):
├── SESSION-LOG.md         → Previous session state (will be overwritten)
├── DEV-LOG.md             → Cumulative history (will be appended)
├── PROCESS.md             → Current lifecycle phase
│   (or PROJECT-LOG.md     → Lightweight mode equivalent)
└── The feature spec being implemented (if applicable)
```

If SESSION-LOG.md doesn't exist yet, that's fine — this might be the first handoff. Create it from scratch.

### Step 2: Summarize Accomplishments

Review what was done this session. Be specific and concrete:

**Good:** "Implemented the organization creation API endpoint with full test coverage (12 tests). Added RLS policies for multi-tenant isolation."

**Bad:** "Worked on organizations feature." (Too vague — a fresh session can't resume from this.)

Sources of truth for what was accomplished:
- Git log (`git log --oneline` for commits this session)
- Files modified (`git diff --stat` against the session's starting point)
- Test results (if tests were run)
- The conversation history itself

### Step 3: Document Decisions

Capture every non-trivial decision made during the session with its rationale:

**Good:** "Used PostgreSQL RLS over application-level tenant filtering — ADR-002 requires row-level security for all tenant data."

**Bad:** "Decided on RLS." (Missing rationale — next session won't know why.)

Decisions to capture:
- Architecture choices (even small ones)
- Implementation approach ("used X library instead of Y because...")
- Spec interpretations ("AC-003 says 'validate input' — interpreted as server-side validation with Zod schema")
- Deferred work ("Skipped pagination for now — will add in F005")

### Step 4: List Files Modified

Every file created, modified, or deleted this session. Full paths. Brief description of what changed.

```markdown
## Files Modified This Session
- `app/Models/Organization.php` — Created: Organization model with RLS scope
- `app/Http/Controllers/OrganizationController.php` — Created: CRUD endpoints
- `tests/Feature/OrganizationTest.php` — Created: 12 tests covering create, read, update
- `database/migrations/2026_02_22_create_organizations.php` — Created: organizations table with tenant_id
- `docs/api/openapi.yaml` — Updated: added /api/organizations endpoints
```

Use `git diff --name-status` as the source of truth if available.

### Step 5: Identify Blockers and Unresolved Items

Anything that's stuck, unclear, or needs human input:

- **Blockers:** "Can't proceed with invite flow — need SMTP credentials for email service"
- **Open questions:** "Spec says 'admin can manage members' but doesn't define what 'manage' includes — need spec clarification"
- **Known issues:** "Test for concurrent org creation is flaky — passes 9/10 times, likely a race condition in the test setup"

Be explicit about what's needed to unblock each item.

### Step 6: Define Next Steps

Ordered list of what the next session should do. These must be specific enough that a fresh Claude session can start working immediately without asking clarifying questions.

**Good:**
```markdown
1. Implement frontend components for organization list page (spec F002, section "UI Components")
2. Add organization switcher to the sidebar navigation (see DESIGN-DECISIONS.md, section "Navigation")
3. Write E2E test for create-org flow using Playwright
4. Update ARCHITECTURE.md with the multi-tenant data flow diagram
```

**Bad:**
```markdown
1. Continue working on organizations
2. Fix bugs
3. Add tests
```

### Step 7: Write SESSION-LOG.md

Overwrite SESSION-LOG.md with the current state. Use all sections — every section must be present even if empty (write "None" for empty sections).

```markdown
# Session Log

## Active Task
[Feature spec reference and current focus area]

## Status
[One line: where we are right now]

## Completed This Session
- [Specific task 1 with concrete detail]
- [Specific task 2 with concrete detail]

## In Progress
- [Partially completed work — what's done, what remains]

## Key Decisions Made
- [Decision]: [rationale]

## Blocked / Unresolved
- [Blocker/question]: [what's needed]

## Files Modified This Session
- `path/to/file` — [what changed]

## Next Steps (for next session)
1. [Specific, actionable first step]
2. [Specific, actionable second step]
3. [Specific, actionable third step]

## Context Health
- Session length: [X tool calls]
- Estimated context usage: [low/medium/high]
- Quality assessment: [good/degrading/should-compact]
- Recommendation: [continue/compact/new-session]

## Integration Status
- Last real stack test: [date/wave or "never"]
- Database engine used in tests vs production: [e.g., SQLite tests / PostgreSQL production]
- Known boundary gaps: [untested boundaries — e.g., "frontend API types not verified against real responses"]
- Recommendation: [boot check needed / integration test needed / stack verified]
```

### Step 8: Append to DEV-LOG.md

DEV-LOG.md is the cumulative history — it's appended to, never overwritten. Add a dated entry:

```markdown
## [YYYY-MM-DD] Session: [brief description]

**Feature:** [spec reference if applicable]
**Accomplished:** [2-3 bullet summary]
**Decisions:** [key decisions, brief]
**Status:** [in-progress / completed / blocked]
**Next:** [one-line pointer to next steps]
```

If DEV-LOG.md doesn't exist, create it with a header and this first entry.

**Lightweight mode (solo):** If the project uses PROJECT-LOG.md instead of separate PROCESS.md + DISCUSSION-LOG.md, also append key decisions to PROJECT-LOG.md.

### Step 9: Assess Context Health

Estimate the session's context usage using proxy signals (Claude cannot read its actual token count):

| Signal | Low | Medium | High |
|--------|-----|--------|------|
| Tool calls this session | <20 | 20-40 | >40 |
| Conversation turns | <30 | 30-60 | >60 |
| Elapsed time estimate | <45 min | 45-90 min | >90 min |
| Response quality | Sharp, focused | Occasional repetition | Forgetting earlier context |

Record the assessment in SESSION-LOG.md's "Context Health" section. Recommend one of:
- **continue** — Context is healthy, session can keep going if the user wants
- **compact** — Context is getting large; run `/compact` before continuing
- **new-session** — Start a fresh session; SESSION-LOG.md is ready for seamless resume

### Step 10: Verify Git Status

Check whether all changes are committed:

```bash
git status
git log --oneline -5
```

Report to the user:
- If everything is committed: "All changes committed. Clean working tree."
- If uncommitted changes exist: "There are uncommitted changes in: [files]. Consider committing before ending the session."
- If there are untracked files: "Untracked files found: [files]. These won't be available to the next session unless committed."

Do NOT auto-commit. Just report status and let the user decide.

**Check for stale worktrees:** Look for `.claude/worktrees/` directories. If they exist, report them: "Found [N] worktree directories from parallel agent execution. If no uncommitted changes exist in them, consider cleaning up to free disk space." Do not auto-delete — let the user decide.

### Step 11: Confirm with User

Present the handoff summary and ask: "Here's the session handoff. Anything missing or incorrect before we close?"

Show a brief summary:
```
Session Handoff Complete
├── Completed: [N items]
├── In Progress: [N items]
├── Blocked: [N items]
├── Files Modified: [N files]
├── Next Steps: [N steps defined]
├── Context Health: [assessment]
├── Git Status: [clean / uncommitted changes]
└── SESSION-LOG.md: Updated ✅
    DEV-LOG.md: Appended ✅
```

Wait for user confirmation. If they add anything, update SESSION-LOG.md before closing.

## Adaptation

**First handoff on a new project:** If SESSION-LOG.md and DEV-LOG.md don't exist yet, create them. If PROCESS.md / PROJECT-LOG.md doesn't exist, note this as a gap — suggest running `:setup` first next session.

**Mid-session handoff (context getting large):** Same full workflow, but the "Context Health" section should strongly recommend "new-session" and the "Next Steps" should be extra-detailed since the next session starts completely fresh.

**Nothing was accomplished (session was exploration only):** Still do the handoff. Record what was explored, what was learned, and what the exploration concluded. Exploration sessions produce knowledge — capture it.

**After a failed implementation:** Document what failed and why. The "Blocked / Unresolved" section is critical here. Next steps should start with diagnosing / fixing the failure, not continuing past it.

**Lightweight mode (solo):** Same workflow, but write to PROJECT-LOG.md in addition to SESSION-LOG.md. Skip DEV-LOG.md if the project doesn't use it (SESSION-LOG.md serves both purposes in lightweight mode, with a cumulative "History" section at the bottom).

## Proactive Trigger Heuristics

This skill should be SUGGESTED (never auto-invoked) when these signals appear:

| Signal | Action |
|--------|--------|
| >40 tool calls in this session | Suggest: "Context is getting large. Want to do a handoff?" |
| >90 minutes elapsed (estimated) | Suggest: "We've been going a while. Handoff to save progress?" |
| User says "context", "tokens", "long session" | Suggest: "I can do a session handoff to capture everything." |
| Response quality degrades (repetition, forgetting) | Suggest: "I think my context is getting stretched. Let me do a handoff so we don't lose anything." |
| Feature implementation complete | Suggest: "Feature looks done. Want me to handoff before we move on?" |

The suggestion should be brief and non-intrusive. The user can decline and keep working.
