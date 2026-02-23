# Process Template

Use this template when creating `PROCESS.md` for a new project. Adapt sections based on team mode (Standard vs. Lightweight).

---

## Standard Mode (Teams of 2+)

```markdown
# Process — [Project Name]

## Lifecycle Phases

| Phase | Status | Skill | Notes |
|-------|--------|-------|-------|
| 1. Ideation & Research | ⬜ Not Started | wavecraft:research | |
| 2. Design | ⬜ Not Started | wavecraft:design | |
| 3. Specification | ⬜ Not Started | wavecraft:spec | |
| 4. Architecture | ⬜ Not Started | wavecraft:architect | |
| 5. Project Setup | 🟢 Complete | wavecraft:setup | |
| 6. Implementation | ⬜ Not Started | wavecraft:implement | |
| 7. Quality Assurance | ⬜ Not Started | wavecraft:review | |
| 8. Deployment | ⬜ Not Started | (CI/CD + platform tooling) | |

**Status legend:** ⬜ Not Started · 🔵 In Progress · 🟢 Complete · 🔴 Blocked · ➖ N/A

## Current Phase

**Phase:** 5. Project Setup
**Started:** [date]
**Focus:** Configuring project for spec-driven agentic engineering

## Session Rules

- One feature per Claude Code session
- Run `wavecraft:handoff` before ending any session
- Update SESSION-LOG.md after every completed task (not just at session end)
- Suggest `/compact` when context gets large (>40 tool calls)
- Never skip spec reading before implementation

## Active Features

| ID | Feature | Status | Assigned To |
|----|---------|--------|-------------|
| (none yet) | | | |

## Decisions Pending

- (none yet — decisions will be tracked in DISCUSSION-LOG.md)
```

---

## Lightweight Mode (Solo Developer)

For solo developers, PROCESS.md is replaced by `PROJECT-LOG.md` which combines phase tracking and decision logging into a single file. Use this template instead:

```markdown
# Project Log — [Project Name]

## Lifecycle Status

| Phase | Status |
|-------|--------|
| Research | ⬜ |
| Design | ⬜ |
| Spec | ⬜ |
| Architecture | ⬜ |
| Setup | 🟢 |
| Implementation | ⬜ |
| QA | ⬜ |

## Session Rules

- One feature per session
- Run `wavecraft:handoff` before stopping
- Update SESSION-LOG.md after every task

## Log

### [date] — Project Setup
- Configured with Wavecraft (Lightweight mode)
- Stack: [stack]
- Next: Write first feature spec
```

---

## Tips

- Update the "Current Phase" section whenever the project moves to a new phase
- The "Active Features" table helps track what's being worked on across sessions
- Keep this file short — it's a status dashboard, not a journal (that's what DISCUSSION-LOG.md is for)
- In Lightweight mode, append new log entries at the bottom of PROJECT-LOG.md instead of using a separate DISCUSSION-LOG.md
