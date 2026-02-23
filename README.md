# Wavecraft

Spec-driven agentic engineering framework for Claude. 8 skills covering the full lifecycle from research through deployment — planning, specification, implementation, QA, and session continuity.

Wavecraft runs inside [Claude Code](https://claude.com/product/claude-code) and [Cowork](https://claude.com). You describe what to build. Specialized skills handle research, design, specification, implementation, quality assurance, and session continuity. You review and approve at each stage.

## Quick Start

**Install** (in your terminal — not inside Claude Code):

```bash
git clone https://github.com/SuperLlama9/wavecraft.git
cd wavecraft
./install.sh
```

This copies all 8 skills to `~/.claude/skills/wavecraft/`, making them available in every Claude Code project.

**Use** (inside Claude Code, after reopening it):

```
"setup project"                    # Configure project for agentic engineering
"write spec for user login"        # Create a feature specification
"implement F001"                   # TDD implementation from spec
"review F001"                      # QA checklist + PR description
"handoff"                          # Save progress for next session
```

Five commands. Five human checkpoints. One working feature.

## How It Works

```
  Cowork / Planning                    Claude Code / Implementation
       │                                      │
       ├── wavecraft:research                  │
       │   → Research Brief                    │
       ├── wavecraft:design                    │
       │   → Design Decisions, User Flows      │
       ├── wavecraft:spec                      │
       │   → Feature Specifications            │
       ├── wavecraft:architect                 │
       │   → ADRs, API Contracts               │
       │                                       │
       │   ── Commit specs to repo ──────────► │
       │                                       │
       │                               wavecraft:setup ──┤
       │                                → CLAUDE.md, rules, hooks
       │                           wavecraft:implement ──┤
       │                                → Code (TDD), session log
       │                              wavecraft:review ──┤
       │                                → QA report, PR description
       │                             wavecraft:handoff ──┤
       │                                → Session state for next session
```

Each skill reads specific artifacts, enforces its workflow, and produces outputs that feed the next skill in the chain. Nothing is silently skipped — every adaptation is stated and confirmed.

## Skills

### Planning Skills (Cowork or Claude Code)

| Skill | Command | Produces |
|-------|---------|----------|
| **research** | "research [topic]" | Research Brief |
| **design** | "design [feature]" | Design Decisions + User Flows |
| **spec** | "write spec for [feature]" | Feature Spec (EARS/Gherkin ACs) |
| **architect** | "architecture decision about [topic]" | ADRs + API Contracts |

### Implementation Skills (Claude Code)

| Skill | Command | Produces |
|-------|---------|----------|
| **setup** | "setup project" | CLAUDE.md, rules, hooks, docs/ |
| **implement** | "implement F001" | Code (TDD), tests, session log |
| **review** | "review F001" | QA Report, PR Description |
| **handoff** | "handoff" | SESSION-LOG.md, DEV-LOG.md |

## Installation

### Claude Code (global — all projects)

```bash
git clone https://github.com/SuperLlama9/wavecraft.git
cd wavecraft
./install.sh
```

Skills are installed to `~/.claude/skills/wavecraft/` and available in every project.

### Claude Code (per-project)

Clone into your project's `.claude/skills/` directory:

```bash
git clone https://github.com/SuperLlama9/wavecraft.git .claude/skills/wavecraft
```

### Cowork

Install as a Cowork plugin. The `.claude-plugin/plugin.json` manifest is included in this repository.

### Both (recommended for teams)

Install in both environments. Use Cowork for planning (research, design, spec discussions) and Claude Code for implementation. The handover between environments is the spec files committed to the repo.

## Updating

```bash
cd ~/.claude/skills/wavecraft   # or wherever you cloned
git pull
```

Or re-run the installer:

```bash
cd wavecraft
./install.sh
```

## Uninstall

```bash
cd wavecraft
./uninstall.sh
```

Or manually: `rm -rf ~/.claude/skills/wavecraft`

## The Artifact Chain

Every skill produces artifacts that the next skill consumes:

```
:research → RESEARCH-BRIEF.md → :design reads it
:design   → DESIGN-DECISIONS.md → :spec reads it
:spec     → docs/features/F0XX.md → :implement reads it
:architect → ADRs, openapi.yaml → :implement reads it
:setup    → CLAUDE.md, rules, hooks → :implement uses them
:implement → code, tests, SESSION-LOG.md → :review reads them
:review   → QA Report, PR Description → human reviewer
:handoff  → SESSION-LOG.md, DEV-LOG.md → :implement resumes from them
```

## Feature Lifecycle Example

```
Session 1 (30 min): "research organization management"    → Research Brief
Session 2 (30 min): "design organization management"      → Design Decisions
Session 3 (30 min): "write spec for F002-organizations"   → Feature Spec
Session 4 (2-4 hr): "implement F002"                      → Backend + tests
Session 5 (2-4 hr): "implement F002" (continue)           → Frontend + tests
Session 6 (30 min): "review F002"                         → QA Report + PR
```

Total: ~8-12 hours across 6 sessions. Each session picks up exactly where the last left off.

## Design Principles

**Enforcing, not suggesting.** Skills refuse to skip mandatory steps. No spec? No implementation. No tests? No commit.

**Adaptive, not rigid.** Skills detect project context and suggest relevant sections. Backend-only? UI sections marked N/A. Solo developer? Lightweight documentation mode.

**Artifact-producing.** Every skill reads inputs and produces outputs. The outputs become inputs for the next skill. This is how context survives across sessions.

## License

MIT
