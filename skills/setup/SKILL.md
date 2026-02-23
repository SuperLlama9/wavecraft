---
name: setup
description: >
  Configure any project for spec-driven agentic engineering with Claude. Creates CLAUDE.md,
  .claude/rules, hooks, agent definitions, and the full docs/ directory structure. This skill
  should be used when the user says "setup project", "initialize wavecraft", "configure claude
  code", "set up the project", "onboard this project", "initialize agentic workflow", or any
  variation of setting up a project for structured AI-assisted development. Also trigger when
  the user mentions "CLAUDE.md", "project setup", or asks how to configure Claude Code for
  a new or existing project. This is always the first skill to run on a new project.
version: 0.1.0
---

# wavecraft:setup — Project Configuration

Configure a project for spec-driven agentic engineering. This skill creates the full infrastructure that all other Wavecraft skills depend on: CLAUDE.md, enforcement rules, hooks, agent definitions, documentation structure, and continuity files.

## Why This Matters

Without proper setup, Claude Code operates without context — it doesn't know your stack, your conventions, or your architecture. Every session starts from scratch. This skill creates the persistent configuration that makes Claude Code effective across sessions and team members.

## Workflow

### Step 1: Detect Existing Configuration

Before creating anything, check what already exists:

```
Check for:
├── CLAUDE.md              → Project context file
├── .claude/               → Claude configuration directory
│   ├── rules/             → Enforcement rules
│   ├── agents/            → Agent definitions
│   └── settings.json      → Hooks and permissions
├── docs/                  → Documentation structure
├── SESSION-LOG.md         → Session continuity
├── DEV-LOG.md             → Development history
├── PROCESS.md             → Lifecycle tracking
└── DISCUSSION-LOG.md      → Decision log
```

**If configuration exists:** Ask the user whether to update (merge improvements into existing config) or overwrite (start fresh). NEVER silently overwrite existing configuration.

**If partial configuration exists:** Only create missing files. Suggest improvements to existing ones.

### Step 2: Gather Project Context

Ask the user these questions. Use AskUserQuestion for structured input. Skip questions the user has already answered.

**Required:**
1. What's your tech stack? (e.g., "Next.js + Django + PostgreSQL", "Rails + Vue", "Go microservices")
2. What's your team size? (solo / 2-3 / 4-10 / 10+)

**Optional (ask only if relevant):**
3. Deployment target? (Vercel, AWS, Docker, Railway, other)
4. Existing test setup? (yes with coverage / yes but sparse / no tests yet)
5. Branching strategy? (trunk-based / feature branches / gitflow)
6. Specific conventions? (naming, formatting tools, module structure)
7. Browser automation available? (Playwright MCP / Chrome Extension / neither)

### Step 3: Detect Team Mode

Based on team size answer:

| Team Size | Mode | What Changes |
|-----------|------|-------------|
| Solo (1) | Lightweight | Combined PROJECT-LOG.md, simplified docs/, single agent, no Team Mode references |
| Small (2-3) | Standard | Full artifact set, feature branch workflow, basic agents |
| Medium (4-10) | Full | Full artifact set, Team Mode guidance, multiple agents, PR templates |
| Large (10+) | Enterprise | Full governance, code review gates, dependency scanning, deployment checklists |

### Step 4: Create CLAUDE.md

**Hard rule: Maximum 100 lines.** CLAUDE.md is loaded into every session's context — bloat here costs tokens everywhere.

Structure (adapt section names to the project's stack):

```markdown
# [Project Name]

[One-line description. Stack summary.]

## Commands
[5-10 most-used commands: start dev server, run tests, lint, format, build]

## Architecture
[3-5 lines: where code lives, module structure, key patterns]

## Conventions
[API style, naming conventions, auth approach, formatting rules]

## Testing
[Test runner, TDD requirement, coverage target]

## Critical Rules
[3-5 NEVER/ALWAYS rules specific to this project]

## Model Profiles
[Which model for which activity — e.g., Opus for planning/architecture, Sonnet for implementation, Haiku for research/quick lookups]

## Context Budget
[Max context per session, when to compact, when to split into waves — e.g., "Compact at ~40 tool calls, new session at ~60. One feature per session."]
```

**Model Profiles and Context Budget** are part of CLAUDE.md because they're project-level configuration that every session needs. Keep each section to 2-3 lines — these are reference values, not documentation.

Read `references/claude-md-guide.md` for detailed guidance on writing effective CLAUDE.md files.

### Step 5: Create .claude/rules/

Create rule files based on the project's stack. Each rule file focuses on one concern. Rules are auto-loaded by Claude Code and provide stronger enforcement than CLAUDE.md (they don't degrade over long sessions).

**Always create:**
- `testing.md` — TDD workflow, test patterns, coverage requirements
- `security.md` — Auth checks, input validation, secrets handling

**Create if applicable:**
- `api-conventions.md` — REST/GraphQL patterns, response format, error handling
- `frontend.md` — Component patterns, state management, styling conventions
- `modules.md` — Module boundaries, cross-module communication rules
- `database.md` — Migration rules, query patterns, transaction handling

Read `references/rules-templates.md` for stack-specific rule templates.

### Step 6: Create .claude/agents/ (Standard+ mode only)

Agent definitions for specialized tasks. Skip in Lightweight mode (solo developers).

**Minimum set:**
- `backend-dev.md` — Backend implementation specialist
- `qa-reviewer.md` — Code review and QA specialist

**If frontend exists:**
- `frontend-dev.md` — Frontend implementation specialist

Read `references/agent-templates.md` for agent definition templates.

### Step 7: Configure Hooks

Hooks provide the strongest enforcement — they fire automatically and can't be skipped. Configure in `.claude/settings.json`.

**Minimum hooks:**
- `PostToolUse` on `Edit|Write` → Run relevant tests after code changes
- `PreToolUse` on `Edit` → Block edits to migration files (if using database migrations)

**Recommended hooks:**
- `PostToolUse` on `Edit|Write` → Run linter/formatter after code changes

Read `references/hooks-guide.md` for hook configuration patterns per stack.

### Step 8: Create docs/ Structure

Create the full documentation directory tree:

```
docs/
├── SPEC.md                          → Master index of all feature specs
├── features/                        → Individual feature specs (F001-name.md)
├── research/                        → Research briefs
├── design/                          → Design decisions
│   └── user-flows/                  → Individual user flow docs
├── architecture/
│   ├── ARCHITECTURE.md              → System overview
│   ├── DATA-MODEL.md                → Database schema
│   └── (ADR-001-name.md, etc.)      → Architecture Decision Records
└── api/
    └── openapi.yaml                 → API contracts (if applicable)
```

**Lightweight mode (solo):** Only create `docs/features/` and `docs/architecture/`.

### Step 9: Create Continuity Files

These files enable session continuity — the core value proposition of the Wavecraft framework.

**Standard+ mode:**

| File | Content |
|------|---------|
| `PROCESS.md` | Lifecycle phases, current status, session rules. Read `references/process-template.md` for template. |
| `DISCUSSION-LOG.md` | Initial entry: "Project started on [date]. Configured with Wavecraft." |
| `SESSION-LOG.md` | Empty template with all required sections. Read `references/session-log-template.md`. |
| `DEV-LOG.md` | Initial entry: "Project configured with Wavecraft on [date]. Stack: [stack]. Team: [size]." |

**Lightweight mode (solo):**

| File | Content |
|------|---------|
| `PROJECT-LOG.md` | Combined phase tracking + decisions (replaces PROCESS.md and DISCUSSION-LOG.md) |
| `SESSION-LOG.md` | Same template, but with cumulative "History" section at bottom |

**If file already exists:** Skip creation. Do not overwrite existing continuity files.

### Step 10: Verify Setup

Run a validation check after creating all files:

```
Verify:
├── CLAUDE.md exists and is ≤100 lines          → PASS/FAIL
├── .claude/rules/ has at least testing.md       → PASS/FAIL
├── .claude/settings.json has hooks configured   → PASS/FAIL
├── docs/ structure matches standard artifact map → PASS/FAIL
├── Continuity files exist (SESSION-LOG.md, etc.) → PASS/FAIL
├── Test command runs successfully                → PASS/FAIL
└── Browser automation available (if UI project)  → PASS/WARN/N/A
```

Report results to the user. If any FAIL, fix before completing.

### Step 11: Summary Output

After setup completes, print a summary:

```
## Wavecraft Setup Complete

**Project:** [name]
**Stack:** [stack]
**Mode:** [Lightweight/Standard/Full/Enterprise]

### Created Files:
- CLAUDE.md (XX lines)
- .claude/rules/: [list of rule files]
- .claude/agents/: [list of agent files]
- Hooks: [list of configured hooks]
- docs/: [structure summary]
- Continuity files: [list]

### Next Steps:
1. Review CLAUDE.md and adjust if needed
2. Run `wavecraft:spec` to write your first feature spec
3. Run `wavecraft:implement` to start building from that spec
4. Run `wavecraft:handoff` when ending a session

### Enforcement Active:
- [hook 1 description]
- [hook 2 description]
- [rule 1 description]
```

## Adaptation

This skill adapts based on what it finds:

**New project (nothing exists):** Full setup from scratch. Ask all configuration questions.

**Existing project (partial config):** Only create missing files. Suggest improvements to existing config. Ask before modifying anything.

**Backend-only project:** Skip frontend rules, frontend agent, and UI-related docs sections. Focus on API conventions, database rules, and backend testing.

**Monorepo / multi-module:** Create module-level rules. Add module boundary enforcement hooks. Document module structure in CLAUDE.md.

## Reference Files

For detailed templates and stack-specific examples, read these reference files as needed:

| Reference | When to Read |
|-----------|-------------|
| `references/claude-md-guide.md` | When writing CLAUDE.md (Step 4) |
| `references/rules-templates.md` | When creating .claude/rules/ (Step 5) |
| `references/agent-templates.md` | When creating .claude/agents/ (Step 6) |
| `references/hooks-guide.md` | When configuring hooks (Step 7) |
| `references/process-template.md` | When creating PROCESS.md (Step 9) |
| `references/session-log-template.md` | When creating SESSION-LOG.md (Step 9) |
