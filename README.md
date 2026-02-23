# Wavecraft

**Spec-driven agentic engineering framework for Claude.**

A suite of 8 skills that enforce a structured development lifecycle — from research and design through implementation, QA, and session handoff. Every skill reads specific artifacts, enforces its workflow, and produces outputs that feed the next skill in the chain.

## Skills

| Skill | Purpose | Primary Environment |
|-------|---------|-------------------|
| `wavecraft:research` | Deep research, competitor analysis, technical feasibility | Planning |
| `wavecraft:design` | User flows, component decisions, interaction patterns | Planning |
| `wavecraft:spec` | Feature specifications with EARS/Gherkin acceptance criteria | Planning |
| `wavecraft:architect` | ADRs, system architecture, API contracts | Planning |
| `wavecraft:setup` | Project configuration — CLAUDE.md, rules, hooks, docs structure | Implementation |
| `wavecraft:implement` | TDD implementation from spec, session logging, context management | Implementation |
| `wavecraft:review` | QA checklist, browser validation, PR description | Implementation |
| `wavecraft:handoff` | Session continuity — save progress for next session | Implementation |

## Installation

**Cowork:**
Install `wavecraft.plugin` via the Cowork plugin system.

**Claude Code:**
```bash
claude plugin add github:SuperLlama9/wavecraft
```

**Both (recommended for teams):**
Install in both environments. Use Cowork for planning, Claude Code for implementation.

## Quick Start

1. Run `wavecraft:setup` on your project (creates CLAUDE.md, rules, hooks, docs/)
2. Write a feature spec with `wavecraft:spec`
3. Implement with `wavecraft:implement` (reads spec, enforces TDD)
4. Review with `wavecraft:review` (QA checklist, browser validation)
5. End sessions with `wavecraft:handoff` (saves progress for next session)

## Documentation

- [Best Practices Guide](./docs/AGENTIC-ENGINEERING-BEST-PRACTICES.md) — Full methodology (17 sections)
- [Skill Suite Design](./docs/SKILL-SUITE-DESIGN.md) — Detailed skill specifications

## License

MIT
