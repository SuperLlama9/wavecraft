# Agentic Engineering Best Practices Guide

**A comprehensive guide to spec-driven development across the Claude ecosystem**
**Version:** 3.2 | **Date:** 2026-02-26 | **Author:** Timothy Becker / Claude

---

## Table of Contents

1. [Philosophy: Spec-Driven Development](#1-philosophy)
2. [The Right Tool for Each Phase](#2-tools)
3. [Continuous Documentation & Artifact Map](#3-documentation)
4. [Phase 1: Ideation & Research](#4-ideation)
5. [Phase 2: Design](#5-design)
6. [Phase 3: Specification Writing](#6-specification)
7. [Phase 4: Architecture Design](#7-architecture)
8. [Phase 5: Project Setup for Claude Code](#8-setup)
9. [Phase 6: Development with Team Mode](#9-development)
10. [Phase 7: Context Engineering](#10-context)
11. [Phase 8: Quality Assurance](#11-qa)
12. [Phase 9: Git Workflow & CI/CD](#12-git)
13. [Phase 10: Deployment & Monitoring](#13-deployment)
14. [Enforcement: What Can Be Automated](#14-enforcement)
15. [Skill Architecture & Usage](#15-skills)
16. [Anti-Patterns to Avoid](#16-anti-patterns)
17. [Enterprise Adoption Playbook](#17-adoption)

---

## 1. Philosophy: Spec-Driven Development {#1-philosophy}

### The Core Principle

In 2026, the role of the software engineer has fundamentally shifted. Specifications are the primary artifact; code is the derived output. The emphasis has flipped from 20% planning / 80% coding to **planning-first, iterative building**.

### The Iteration Reality

The process is not one-shot. Research from Sanity, incident.io, and others confirms the real pattern:

- **First attempt will be ~95% incomplete.** This is normal, not failure.
- **Budget 2-3 implementation attempts** per feature, with human review between each.
- **Each iteration narrows the gap** — the spec gets refined alongside the code.
- **The spec is the durable artifact.** Code can be regenerated; the thinking behind the spec cannot.

This means the engineering investment is in the spec and in the review loops — not in the initial code generation. AI handles the code; humans handle the judgment.

### Why This Works

AI agents like Claude Code generate high-quality code when given clear, unambiguous specifications. The bottleneck is no longer "how to code it" but "what exactly to build." A well-written spec eliminates ambiguity, reduces rework significantly, and enables parallel AI-assisted development.

Companies shipping with this pattern report real results:
- **incident.io:** "Incredible step change" in delivery velocity after Claude Code adoption
- **Sanity:** Staff engineer recommends $1,000-1,500/month per senior engineer budget
- **Rakuten:** 7 hours sustained autonomous coding on refactoring projects
- **Accenture × Anthropic:** 30,000 professionals receiving Claude training

### The Spec-Driven Lifecycle

```
IDEATE → RESEARCH → DESIGN → SPECIFY → ARCHITECT → IMPLEMENT → QA → DEPLOY
  │         │          │        │          │           │         │       │
  │         │          │        │          │           │         │       └─ Automated + human
  │         │          │        │          │           │         └─ Continuous, not a phase
  │         │          │        │          │           └─ Claude Code (Team Mode + worktrees)
  │         │          │        │          └─ Human reviews AI-proposed architecture
  │         │          │        └─ Modular markdown specs with acceptance criteria
  │         │          └─ User flows, wireframes, component decisions
  │         └─ Deep research, competitor analysis, technical feasibility
  └─ Business requirements, user needs, market opportunity

──── Cowork / Claude Desktop ────────────┼──── Claude Code ────────────────
     (Research, Design & Planning)       │    (Implementation & Delivery)
                                         │
     Handover artifact:                  │
     Feature specs committed             │
     to the repository                   │
                                         │
     ⟳ Feedback loop:                   │
     Implementation learnings feed       │
     back to spec updates                │
```

### The Continuity Principle

**Every phase produces a persistent artifact that enables seamless continuation in a fresh context window.** This applies equally to Cowork sessions and Claude Code sessions. No thinking, decision, or progress should ever be lost to context window limits.

A new Cowork session reads `DISCUSSION-LOG.md` and `PROCESS.md` → immediately knows the product thinking state.
A new Claude Code session reads `SESSION-LOG.md` and the relevant feature spec → immediately knows the implementation state.

Documentation is not a chore that happens at the end — it is the primary mechanism by which AI agents maintain continuity across sessions. See Section 3 for the complete artifact map.

---

## 2. The Right Tool for Each Phase {#2-tools}

### Why This Matters

Trying to do everything in one environment is itself an anti-pattern. Each Claude surface has genuine strengths, and the best workflow uses each where it excels. The handover artifact between environments is the **spec files** — written in Cowork, committed to the repo, consumed by Claude Code.

### Environment Comparison

| Capability | Claude Desktop | Claude Cowork | Claude Code |
|---|---|---|---|
| **Best for** | Brainstorming, quick research | Structured deliverables, deep research | Implementation, codebase work |
| **Web search** | Yes | Yes (via browser) | Yes |
| **File creation** | Limited | Yes (docx, pptx, xlsx, pdf, md) | Yes (code files) |
| **Codebase awareness** | No | No | Full |
| **Git integration** | No | No | Full |
| **Plan Mode** | No | No | Yes |
| **Subagents** | No | Yes (task agents) | Yes (up to 7) |
| **Hooks** | No | No | Yes |
| **Skills** | No | Plugins | SKILL.md files |
| **MCP servers** | No | Some | Full |
| **Team Mode** | No | No | Yes (experimental) |

### Recommended Phase-to-Tool Mapping

```
Phase 1: Ideation & Research     → Claude Desktop or Cowork
  Why: Conversational, web search, no codebase needed.
  Cowork adds: file creation, browser research, structured outputs.
  Artifact: DISCUSSION-LOG.md, RESEARCH-BRIEF.md

Phase 2: Design                  → Cowork
  Why: User flow diagrams, wireframe descriptions, component decisions.
  No codebase needed, but produces structured design artifacts.
  Artifact: DESIGN-DECISIONS.md, user flow descriptions

Phase 3: Specification Writing   → Cowork
  Why: Creates polished markdown files, can do deep research
  to validate technical feasibility, produces the handover artifact.
  Artifact: docs/features/F0XX-name.md, docs/SPEC.md

Phase 4: Architecture Design     → Cowork → Claude Code (Plan Mode)
  Why: High-level decisions in Cowork, then validate against
  existing codebase in Claude Code's Plan Mode.
  Artifact: ADRs, DATA-MODEL.md, openapi.yaml

Phase 5: Project Setup           → Claude Code
  Why: Needs codebase access to create CLAUDE.md, rules, hooks.
  Artifact: CLAUDE.md, .claude/rules/*, .claude/agents/*

Phase 6: Implementation          → Claude Code
  Why: Full codebase awareness, git, TDD, subagents, hooks.
  Artifact: SESSION-LOG.md (per session), DEV-LOG.md (cumulative)

Phase 7-10: QA, Git, Deploy     → Claude Code
  Why: All require codebase and git access.
  Artifact: CHANGELOG.md, openapi.yaml (updated)
```

### The Handover Point

The critical transition is **Cowork → Claude Code**. The handover artifact is the spec files:

1. Write feature specs in Cowork (markdown files with EARS acceptance criteria)
2. Commit spec files to the repository under `docs/features/`
3. Claude Code reads these specs during implementation
4. If specs need updating during implementation, update them in the repo (not in Cowork)

This means specs are version-controlled alongside the code they describe. The spec lives in the repo; Cowork is where the thinking happens.

---

## 3. Continuous Documentation & Artifact Map {#3-documentation}

### The Core Principle

**Every phase produces a persistent artifact that enables seamless continuation in a fresh context window.** This is not optional — it is the primary mechanism by which AI agents maintain continuity across sessions. Without persistent artifacts, every new session starts from zero, wasting 10-20 minutes on re-orientation.

This principle applies equally to Cowork (research, design, planning) and Claude Code (implementation, QA, deployment). The documentation is not a byproduct — it IS the work.

### Why This Matters

Context windows are finite. Sessions end. Models forget. The only thing that persists between sessions is what's written to disk. Teams that treat documentation as a chore lose hours to re-explaining context. Teams that document continuously lose nothing.

The pattern:
- **Start of session:** Read the relevant artifacts (mandatory, non-negotiable)
- **During session:** Update artifacts as decisions are made (not at the end)
- **End of session:** Verify artifacts reflect the current state

### Standard Artifact Map

**Cowork Phase Artifacts (Pre-Implementation)**

| Phase | File | Location | Purpose |
|-------|------|----------|---------|
| Process | `PROCESS.md` | repo root | The process itself — phases, status, session rules |
| Ideation | `DISCUSSION-LOG.md` | repo root | All decisions, questions, outcomes across sessions |
| Research | `docs/research/RESEARCH-BRIEF.md` | docs/research/ | Problem statement, personas, competitors, constraints |
| Design | `docs/design/DESIGN-DECISIONS.md` | docs/design/ | User flows, wireframes, component choices, interaction patterns |
| Design | `docs/design/user-flows/*.md` | docs/design/ | Individual user flow descriptions |
| Specification | `docs/SPEC.md` | docs/ | Master index linking all feature specs |
| Specification | `docs/features/F0XX-name.md` | docs/features/ | One per feature, EARS format, 50-150 lines each |
| Architecture | `docs/architecture/ARCHITECTURE.md` | docs/architecture/ | System overview, data model, deployment |
| Architecture | `docs/architecture/ADR-0XX-name.md` | docs/architecture/ | One per major decision |
| Architecture | `docs/architecture/DATA-MODEL.md` | docs/architecture/ | Database schema |
| Architecture | `docs/api/openapi.yaml` | docs/api/ | API contracts (source of truth for frontend/backend) |

**Claude Code Phase Artifacts (Implementation)**

| Phase | File | Location | Purpose |
|-------|------|----------|---------|
| Setup | `CLAUDE.md` | repo root | Project context for AI agents (50-100 lines) |
| Setup | `.claude/rules/*.md` | .claude/ | Coding standards, enforcement rules |
| Setup | `.claude/agents/*.md` | .claude/ | Specialist agent definitions |
| Implementation | `SESSION-LOG.md` | repo root | Current session state (overwritten each session) |
| Implementation | `DEV-LOG.md` | repo root | Cumulative development history (appended each session) |
| Implementation | `docs/api/openapi.yaml` | docs/api/ | Updated as APIs are built (living document) |
| QA | CI/CD output | Automated | Coverage reports, test results |
| Deploy | `CHANGELOG.md` | repo root | Release notes per version |

### The Continuity Chain

```
NEW COWORK SESSION
  │
  ├─ Read PROCESS.md          → Know which phase we're in
  ├─ Read DISCUSSION-LOG.md   → Know all decisions made so far
  ├─ Read relevant phase docs → Know the current state of that phase
  │
  └─ Result: Full orientation in <2 minutes, zero re-explanation needed

NEW CLAUDE CODE SESSION
  │
  ├─ Read SESSION-LOG.md      → Know exactly where implementation stopped
  ├─ Read relevant feature spec → Know what to build
  ├─ Read DEV-LOG.md (if needed) → Know the history of decisions
  │
  └─ Result: Resume coding in <3 minutes, no context loss
```

### SESSION-LOG.md vs. DEV-LOG.md

These serve different purposes:

**SESSION-LOG.md** is a snapshot of the current state. It gets overwritten at the start of each new session. It answers: "Where are we right now? What's done? What's next?" Keep it concise — 30-60 lines.

**DEV-LOG.md** is a cumulative history. Each session appends to it. It answers: "How did we get here? What decisions were made along the way? What problems did we encounter?" This grows over time and is the institutional memory of the project.

### DISCUSSION-LOG.md (Cowork Equivalent)

For Cowork sessions, `DISCUSSION-LOG.md` serves the combined role of both SESSION-LOG.md and DEV-LOG.md. It captures decisions, questions, outcomes, and the reasoning behind them. Every Cowork session must read it first and update it before ending.

### Enforcement

Skills enforce this pattern when invoked:
- Cowork skills read `DISCUSSION-LOG.md` and `PROCESS.md` before starting (mandatory)
- Claude Code skills read `SESSION-LOG.md` and the relevant spec before starting (mandatory)
- All skills update their respective artifacts before completing (mandatory)
- Skills refuse to proceed if required artifacts are missing or stale

---

## 4. Phase 1: Ideation & Research {#4-ideation}

### Where: Claude Desktop or Cowork

This phase is conversational and research-heavy. No codebase needed.

### What to Do

Before writing a single spec, understand the problem space deeply. This phase typically takes 2-5 days for a major feature.

### Research Toolkit

**Competitor Analysis:**
- Analyze 3-5 direct competitors (features, pricing, UX patterns)
- Document what they do well and what's missing
- Use web search, product demos, review sites (G2, Capterra)

**User Research:**
- Interview 3-5 target users (even informal conversations count)
- Map current pain points and workflows
- Identify the "jobs to be done" (JTBD framework)

**Technical Feasibility:**
- Use Claude Code in **Plan Mode** to explore the existing codebase
- Identify technical constraints and dependencies
- Research third-party services/APIs needed

**Market Research:**
- Size the opportunity (TAM, SAM, SOM)
- Identify pricing benchmarks
- Understand regulatory/compliance requirements

### Deliverable: Research Brief

A 1-2 page markdown document (`docs/research/RESEARCH-BRIEF.md`) capturing:
- Problem statement
- User personas and their needs
- Competitor landscape
- Technical constraints
- Success metrics (measurable)

All decisions and discussions must be captured in `DISCUSSION-LOG.md` for session continuity.

---

## 5. Phase 2: Design {#5-design}

### Where: Cowork

Design sits between Research and Specification because you need to understand the problem space before designing solutions, and the design decisions feed directly into the specs. This phase captures the structural and interaction design — not pixel-perfect mockups, but the decisions that shape what gets built.

### Why This Phase Exists

Without explicit design decisions, specs become ambiguous about layout, interaction patterns, and visual hierarchy. Claude Code will make its own design decisions if the spec doesn't specify — and those decisions may not match what the product needs. For any product with a user-facing frontend, the design phase prevents implementation surprises.

### What to Decide

**User Flows:**
For each major user journey, document the step-by-step flow:
- Entry point → intermediate screens → completion
- Decision points (what branches exist?)
- Error states and recovery flows
- What the user sees at each step (screen purpose, not pixel layout)

**Information Architecture:**
- Navigation structure (sidebar, tabs, breadcrumbs)
- Page hierarchy (what lives where?)
- Content grouping (what information appears together?)

**Component Decisions:**
- Component library selection (e.g., shadcn/ui, Radix, Headless UI)
- Design system basics: typography scale, color palette, spacing system
- Responsive strategy: mobile-first? Desktop-first? Which breakpoints?
- Key component patterns: data tables, forms, modals, notifications

**Interaction Patterns:**
- Form behavior (inline validation, submit flow, error display)
- Loading states (skeleton screens, spinners, optimistic updates)
- Empty states (first-use experience)
- Confirmation patterns (destructive actions, multi-step workflows)

**Accessibility (a11y) Baseline:**
- Target WCAG level (2.1 AA recommended)
- Keyboard navigation requirements
- Screen reader considerations for key workflows
- Color contrast requirements

**Internationalization (i18n) Baseline:**
- Supported languages (now and planned)
- Default locale and currency
- RTL support needed?
- Date/time/number formatting standards

### Deliverable: Design Decisions Document

A structured document (`docs/design/DESIGN-DECISIONS.md`) capturing:
- User flow descriptions (one per major journey)
- Navigation and information architecture
- Component library and design system choices
- Interaction pattern standards
- Accessibility and i18n requirements

Individual user flows can be broken out into `docs/design/user-flows/UF-001-name.md` for complex products.

### Design Phase Best Practices

**Be descriptive, not visual.** In a text-based workflow, design decisions are described in words and structured markdown, not Figma files. Focus on behavior and structure: "The vendor comparison page shows a data table with sortable columns. Each row links to a vendor detail page. The table supports pagination (25 per page) and column-level filtering."

**Make the implicit explicit.** Many design decisions are "obvious" to humans but not to AI agents. If you don't specify that a delete button should have a confirmation dialog, it won't have one. If you don't specify loading states, they'll be generic spinners (or nothing).

**Design for your edge cases.** Empty states (no data yet), error states (API failed), loading states (data fetching), and permission states (user can't access) are where most products fail. Specify these alongside the happy path.

---

## 6. Phase 3: Specification Writing {#6-specification}

### Where: Cowork

Cowork is ideal for spec writing because it combines research capability (web search, browser) with structured document creation. The output is committed to the repository for Claude Code to consume. All specification decisions must also be captured in `DISCUSSION-LOG.md` for session continuity.

### The Modular Spec Approach

Never write one massive specification. Break it into focused, independent feature specs that Claude Code can consume one at a time.

### Spec Structure

```
docs/
├── SPEC.md                      # Master index (links to all feature specs)
├── features/
│   ├── F001-authentication.md   # One file per feature module
│   ├── F002-organizations.md
│   ├── F003-project-setup.md
│   └── ...
├── architecture/
│   ├── ARCHITECTURE.md          # System architecture overview
│   ├── DATA-MODEL.md            # Database schema
│   └── ADR-001-*.md             # Architecture Decision Records
└── user-journeys/
    ├── UJ-001-consultant.md     # End-to-end user flows
    └── UJ-002-client.md
```

### Feature Spec Template

Each feature spec should follow this structure (optimized for AI consumption):

```markdown
# F004: Requirements Gathering (Phase 2)

## Overview
[2-3 sentences: what this feature does and why it matters]

## User Roles
- Consultant: [what they can do]
- Client: [what they can do]
- Admin: [what they can do]

## Acceptance Criteria (EARS Format)

### Core
- AC-001: When [trigger], the system shall [behavior] so that [outcome].
- AC-002: When [trigger], the system shall [behavior] so that [outcome].

### Error Handling
- AC-010: When [error condition], the system shall [recovery behavior].

### Edge Cases
- AC-020: When [edge case], the system shall [behavior].

## Data Model
[Table schema with columns, types, constraints]

## API Endpoints
[Method, path, request/response examples]

## UI Components
[Key component names and behavior descriptions]

## Dependencies
- Requires: [other features that must exist first]
- Blocks: [features that depend on this one]

## Accessibility
- Keyboard navigation: [any specific requirements]
- Screen reader: [labels, announcements, live regions]
- Focus management: [where focus goes after actions]

## Internationalization
- Translatable strings: [list user-facing text]
- Locale-sensitive: [dates, numbers, currency]
- RTL considerations: [if applicable]

## Out of Scope
[Explicitly list what this feature does NOT include]
```

### Spec Writing Best Practices

**Granularity sweet spot:** Each feature spec should be implementable in 1-4 hours of Claude execution time. If it's bigger, break it down further.

**Be explicit about what NOT to build.** Claude Code will add features if the spec is ambiguous. An "Out of Scope" section prevents scope creep.

**Use EARS-style acceptance criteria (recommended):**
- **E**vent: "When the user clicks submit..."
- **A**ction: "the system shall validate all fields..."
- **R**esult: "and display a success message..."
- **S**afeguard: "If validation fails, show field-level errors."

**Alternative: Gherkin (Given-When-Then) format:**
For teams already using BDD or who prefer directly executable test scenarios:
```
Given the user has filled in all required fields
When the user clicks submit
Then the system validates all fields
And displays a success message
But if validation fails, shows field-level errors below each invalid input
```
Both formats are valid. EARS is more compact and spec-oriented. Gherkin is more widely known and maps directly to test frameworks (Cucumber, Behat, Playwright BDD). Choose one per project and stay consistent.

**Include examples.** Show sample API requests/responses, sample data, expected UI states.

**Budget for iteration.** The first implementation attempt will be incomplete. Include enough detail that Claude Code can get 70-80% right on the first pass, then plan for 1-2 review-and-refine cycles.

### Jira vs. Markdown Specs — When to Use Each

| Use Jira When | Use Markdown Specs When |
|---------------|------------------------|
| You have a team of 5+ with PMs | Small team (1-3 developers) |
| You need sprint tracking and velocity | You need AI-readable specs |
| Stakeholders expect Jira boards | You're using Claude Code as primary dev tool |
| You want MCP integration (Claude reads Jira) | You want version-controlled specs |

**The Hybrid Approach (Recommended for teams):**
- Use Jira for tracking (epics, sprints, assignment)
- Use markdown specs for detailed requirements (Claude reads these)
- Link Jira tickets to their corresponding markdown spec files
- Claude Code MCP integration can read Jira, but detailed specs live in git

---

## 7. Phase 4: Architecture Design {#7-architecture}

### Where: Cowork (high-level) → Claude Code Plan Mode (validation)

Start architectural decisions in Cowork where you can research patterns, discuss trade-offs, and create ADR documents. Then validate against the existing codebase using Claude Code's Plan Mode.

### Architecture Decision Records (ADRs)

For every significant architectural decision, create an ADR:

```markdown
# ADR-001: Modular Monolith over Microservices

## Status: Accepted

## Context
We need an architecture that supports 10+ feature modules while
maintaining development velocity for a small team (2-3 developers).

## Decision
We will use a modular monolith with nwidart/laravel-modules,
with clear module boundaries and event-driven communication.

## Consequences
- Positive: Single deployment, shared database, simple ops
- Positive: Can extract to microservices later if needed
- Negative: Must enforce module boundaries through code review
- Negative: All modules share same scaling characteristics
```

### API Contracts as Living Artifacts

For any project with a frontend/backend split, the API contract is a critical handover artifact — equal in importance to the feature specs.

**Define API contracts during Architecture, maintain during Implementation:**
- Create `docs/api/openapi.yaml` (or `openapi.json`) as the single source of truth
- Frontend and backend teams develop against this contract
- The OpenAPI spec is updated every time an endpoint changes during implementation
- CI can validate that the implementation matches the contract (tools: Spectral, Prism)

**Why OpenAPI:**
- Machine-readable: Claude Code can read and validate against it
- Generates client SDKs, mock servers, and documentation automatically
- Frontend can develop against mocked endpoints before backend is ready
- Acts as the contract between Team Mode teammates (backend builds it, frontend consumes it)

### Performance Budgets

Define performance targets during Architecture and enforce during QA:

| Metric | Target | How to Measure |
|--------|--------|---------------|
| API response time (p95) | <200ms for reads, <500ms for writes | Load testing (k6, Artillery) |
| Page load time (LCP) | <2.5s | Lighthouse CI |
| Bundle size (JS) | <250KB initial load | Webpack/Next.js bundle analyzer |
| Database query time | <50ms per query | Query logging, pg_stat_statements |
| Time to Interactive (TTI) | <3.5s | Lighthouse CI |

These targets should be documented in `docs/architecture/ARCHITECTURE.md` and checked as part of the QA process.

### Architecture Review Checklist

Before implementation, validate:
- [ ] Data model supports all feature specs
- [ ] API design is consistent across modules
- [ ] API contract (OpenAPI) defined and committed to repo
- [ ] Authentication/authorization covers all user roles
- [ ] Multi-tenancy strategy is defined
- [ ] Caching strategy identified
- [ ] Error handling is standardized
- [ ] Monitoring/logging approach chosen
- [ ] Deployment architecture supports the target environment
- [ ] Performance budgets defined and documented
- [ ] Accessibility requirements documented (WCAG level)
- [ ] Internationalization strategy defined (locales, currency, formatting)
- [ ] Third-party integration strategy (API keys, rate limits, fallbacks)
- [ ] Deployment readiness: hosting decided, CI/CD configured, environment variables documented, secrets management strategy defined
- [ ] Context budget estimated (how many tokens will this feature require?)

---

## 8. Phase 5: Project Setup for Claude Code {#8-setup}

### Where: Claude Code

This phase configures the Claude Code environment. Everything here lives in the repository.

> **Stack Note:** All examples in this section use Laravel + Next.js + PostgreSQL for consistency. **These are examples, not requirements.** Adapt all commands, test runners, and patterns to your stack. For instance: `php artisan test` → `pytest` (Django), `go test ./...` (Go), `bundle exec rspec` (Rails). The methodology is stack-agnostic — only the tooling details change.

### CLAUDE.md — Project Context

This file provides Claude Code with project context. Keep it to 50-100 lines. It is important but not infallible — CLAUDE.md instructions are treated as suggestions and can degrade in long sessions. For true enforcement, use hooks (see Section 14).

```markdown
# Vendor Selection Platform

Enterprise B2B vendor evaluation platform.
Next.js 15 frontend + Laravel 11 API + PostgreSQL + Redis.
Modular monolith using nwidart/laravel-modules.

## Commands
- Full stack: docker compose up -d
- Frontend dev: cd frontend && npm run dev
- Backend dev: cd backend && php artisan serve
- Run all tests: cd backend && php artisan test
- Run specific test: php artisan test --filter=TestName
- Lint frontend: cd frontend && npm run lint
- Format backend: cd backend && ./vendor/bin/pint
- Create module: php artisan module:make ModuleName

## Architecture
- Modules: /backend/Modules/ (one per feature domain)
- Frontend pages: /frontend/src/app/ (Next.js App Router)
- API routes: Each module defines own routes in Routes/api.php
- Models: Each module owns its Eloquent models
- Shared kernel: /backend/app/ (auth, base classes, utilities)

## Module Communication
- Use events (not direct imports) for cross-module communication
- Each module has Contracts/ folder for interfaces
- Never import models from another module directly

## Conventions
- API: RESTful, JSON responses, standard error format
- Auth: Sanctum tokens, PostgreSQL RLS for tenant isolation
- Currency: EUR (de-DE locale)
- Naming: camelCase (TS), snake_case (PHP)

## Testing
- Every feature needs tests BEFORE implementation (TDD)
- Run relevant module tests after changes
- Minimum 85% coverage per module

## Critical Rules
- NEVER modify existing migration files
- NEVER import across module boundaries without a contract
- All endpoints require Sanctum auth (except public platform API)
- Phase gates enforce sequential evaluation completion
```

### .claude/ Directory Setup

```
.claude/
├── settings.json              # Permissions, hooks, environment
├── rules/
│   ├── testing.md             # TDD enforcement rules
│   ├── api-conventions.md     # REST API patterns
│   ├── security.md            # Auth, validation, sanitization
│   ├── frontend.md            # React/Next.js patterns
│   └── modules.md             # Module boundary rules
├── agents/
│   ├── backend-dev.md         # Backend specialist
│   ├── frontend-dev.md        # Frontend specialist
│   ├── qa-reviewer.md         # Code quality reviewer
│   └── db-architect.md        # Database/migration specialist
└── hooks/
    └── post-edit-lint.sh      # Auto-lint after edits
```

### The Enforcement Hierarchy

Understanding this hierarchy is critical. From strongest to weakest:

1. **Hooks** — Guaranteed execution. Runs every time, regardless of context state. Use for: test running, formatting, migration protection.
2. **.claude/rules/** — Auto-loaded per file path. Treated as strong suggestions but can degrade in very long sessions. Use for: coding standards, TDD workflow, API patterns.
3. **CLAUDE.md** — Loaded into context at session start. Provides project overview and conventions. Degrades as context fills. Use for: project context, commands, architecture overview.
4. **Verbal instructions** — Weakest. Lost in long sessions. Never rely on these alone.

### .claude/rules/testing.md Example

```markdown
---
paths:
  - "backend/**/*.php"
  - "frontend/**/*.ts"
  - "frontend/**/*.tsx"
---

# Testing Rules (MANDATORY)

## Test-Driven Development
1. ALWAYS write tests BEFORE implementation code
2. Confirm tests FAIL before writing implementation (red phase)
3. Write minimal code to pass tests (green phase)
4. Refactor while keeping tests green (blue phase)

## Backend Tests
- Use PHPUnit feature tests (not unit tests for API endpoints)
- Test happy path + at least 3 error cases per endpoint
- Use model factories for test data
- Assert response structure, status codes, and database state

## Frontend Tests
- Test user interactions, not implementation details
- Use React Testing Library patterns
- Test loading, success, and error states

## Coverage Requirements
- Minimum 85% branch coverage per module
- No PR merge without passing tests
```

### .claude/agents/backend-dev.md Example

```yaml
---
name: backend-dev
description: |
  Laravel backend specialist. Owns all PHP code,
  API endpoints, database migrations, and backend tests.
  Use for implementing API features and database changes.
tools: Read, Edit, Write, Bash, Grep, Glob
model: sonnet
---

You are a senior Laravel developer specializing in modular
monolith architecture. You follow TDD strictly.

When implementing a feature:
1. Read the feature spec in docs/features/
2. Write PHPUnit tests first
3. Create migration if needed
4. Implement model, controller, service
5. Run tests and verify they pass
6. Run php artisan pint for formatting

Module rules:
- Each module is self-contained in Modules/
- Use events for cross-module communication
- Define contracts (interfaces) for module APIs
- Never import from another module's internal classes
```

---

## 9. Phase 6: Development with Team Mode {#9-development}

### Where: Claude Code

### When to Use Team Mode

Use Team Mode when you have work that naturally splits into parallel, independent tracks. The golden rule: **each teammate must own different files.**

Note: Agent Teams is currently experimental (enable via `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` in settings.json). For production coordination, also consider the Tasks feature (shared task lists across sessions) as a more stable alternative.

### Optimal Team Structure

For a feature like "Add Organization Management":

```
Lead Agent (Coordinator)
├── Reads feature spec
├── Creates task breakdown
├── Monitors teammate progress
├── Synthesizes and merges results
│
├── Backend Teammate
│   ├── Owns: Modules/Organization/**
│   ├── Creates: migration, model, controller, policy, tests
│   └── Commits to: feature/org-backend branch
│
├── Frontend Teammate
│   ├── Owns: frontend/src/app/(dashboard)/organizations/**
│   ├── Creates: pages, components, hooks, types
│   └── Commits to: feature/org-frontend branch
│
└── QA Teammate
    ├── Owns: tests/Feature/Organization**, frontend tests
    ├── Creates: integration tests, E2E scenarios
    └── Reviews: both backend and frontend output
```

### Task Decomposition Rules

1. **Each task = one teammate** — no shared file ownership
2. **Specific spawn prompts** — include file paths, acceptance criteria, constraints
3. **Acceptance criteria per task** — what "done" means for each teammate
4. **Dependencies tracked** — task B can't start until task A completes

### Git Strategy: Worktrees for Parallel Work

```bash
# Create worktrees for each teammate
git worktree add ../vendor-app-backend -b feature/org-backend
git worktree add ../vendor-app-frontend -b feature/org-frontend

# Each teammate works in isolation
# Lead agent merges when both are ready
```

### Cross-Session Coordination: Tasks Feature

For teams running multiple Claude Code sessions, the Tasks feature (January 2026) provides shared state:

```bash
# Set the same task list ID across sessions
export CLAUDE_CODE_TASK_LIST_ID=feature-org-mgmt

# All sessions now share one task list with:
# - Dependency graphs (task B waits for task A)
# - Real-time broadcasts when tasks complete
# - Status visibility across all sessions
```

### Task Decomposition: XML Task Format

Break implementation plans into structured, machine-executable tasks. The key insight: **plans are prompts, not documents that become prompts.** Each task IS the instruction for execution.

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
  <action>Create Eloquent model with fillable, casts, relationships
    to Evaluation. Create factory with realistic fake data.</action>
  <verify>php artisan tinker --execute="App\Modules\Requirements\Models\Requirement::factory()->make()"</verify>
  <done>Model instantiates without errors, factory produces valid data</done>
</task>
```

**The Nyquist Rule:** Every task MUST have a `<verify>` step that completes in <60 seconds. If you can't verify it automatically, the task is too vague or too large — break it down further. This single rule prevents 80% of "it works on my machine" problems. *(Named by analogy: just as Nyquist says you must sample at 2× the signal frequency to reconstruct it, you must verify at least as often as you commit to maintain confidence in your code's state.)*

**Atomic Commits:** One task = one commit. After each task's `<verify>` passes, commit immediately with a descriptive message referencing the task. This gives you `git bisect` for free, makes every change independently revertable, and creates clean history that future Claude sessions can parse.

```bash
# After task 1 completes:
git add -A && git commit -m "feat(requirements): create requirements migration (task 1/8)"
# After task 2 completes:
git add -A && git commit -m "feat(requirements): add Requirement model + factory (task 2/8)"
```

### Wave-Based Execution

For features with 10+ tasks, split into waves. Each wave runs in a subagent with a fresh context, preventing the quality cliff that occurs past ~70% context usage.

```
Wave 1: Data layer (migration, models, factories)         → Fresh context
Wave 2: API layer (controllers, routes, validation)        → Fresh context
Wave 3: Business logic (services, events, policies)        → Fresh context
Wave 4: Frontend (components, hooks, pages)                → Fresh context
Wave 5: Integration (E2E tests, API documentation)         → Fresh context
```

The lead agent coordinates waves, passing only summaries between them. Each wave starts clean with the spec + the previous wave's commit history — not the previous wave's full conversation.

**When to use waves:** Features with >10 tasks or estimated >4 hours of implementation. For smaller features, a single session is fine.

### Development Cadence

```
Monday:     Plan sprint → Write/refine feature specs → Create tasks
Tue-Thu:    Team Mode development (parallel tracks)
            - Morning: Review overnight agent work
            - Afternoon: Steer agents, unblock issues
Friday:     QA review → Merge → Demo → Retrospective
```

### Model Profiles & Cost Management

Different tasks need different models. Configure model selection per activity type:

| Activity | Recommended Model | Why |
|----------|------------------|-----|
| Architecture & planning | Opus | Highest reasoning quality for complex decisions |
| Code implementation | Sonnet | Best quality/speed/cost balance for coding |
| Research & exploration | Haiku | Fast, cheap, good enough for information gathering |
| Code review | Sonnet | Needs quality judgment but not Opus-level reasoning |
| Test generation | Sonnet | Needs to understand code patterns |
| Documentation | Haiku or Sonnet | Depends on complexity |

Configure in your project setup (CLAUDE.md or agent definitions):
```yaml
# .claude/agents/backend-dev.md
model: sonnet    # Implementation agent uses Sonnet

# .claude/agents/qa-reviewer.md
model: sonnet    # QA needs quality judgment

# Subagent exploration: use Haiku
# (configured per spawn, not globally)
```

**Cost budgets:**
- Single agent: ~$5-15/feature
- 3-agent team: ~$15-45/feature
- Monthly budget per senior engineer: $1,000-1,500 (validated by Sanity)
- Prompt caching can reduce costs up to 90% with high cache hit rates
- Wave-based execution with Haiku subagents for research saves ~30% vs. running everything on Opus

---

## 10. Phase 7: Context Engineering {#10-context}

### Why This Is Critical

Context management is the #1 challenge in production agentic engineering. Every advanced team converges on this. The core problem: context doesn't degrade linearly — it falls off a cliff. A model might maintain 95% quality up to a threshold, then suddenly drop to 60%.

### What Degrades and What Doesn't

| Mechanism | Degradation | Notes |
|---|---|---|
| **Hooks** | None — always fires | Use for anything that must always happen |
| **.claude/rules/** | Minimal | Auto-loaded per file path, relatively stable |
| **CLAUDE.md** | Moderate | Suggestions degrade as context fills |
| **Earlier conversation** | Severe | Older messages get "forgotten" first |
| **Spec recall** | Severe | Must re-read specs in each new session |

### The Session Log Pattern

The biggest pain point is context loss between sessions. The solution: a structured session log that persists between sessions.

**Without session log:**
```
Session 1: Implement auth feature
  → context fills up → quality degrades
  → user starts new session
  → Claude has ZERO memory of previous work
  → 10+ minutes lost re-explaining context
```

**With session log:**
```
Session 1: Implement auth feature
  → at 70% context: auto-writes SESSION-LOG.md
  → at 80% context: pings user "Context getting large. Log saved."
  → user starts new session
  → Claude reads SESSION-LOG.md → immediate orientation
```

### SESSION-LOG.md Format

```markdown
# Session Log — 2026-02-21 14:30

## Active Task
Feature: F004-requirements-gathering (Phase 2)
Status: Implementation 60% complete

## Completed
- [x] Migration created: create_requirements_table
- [x] Model + Factory written
- [x] API endpoints: GET /api/requirements, POST /api/requirements
- [x] Tests written for happy path (3/3 passing)

## In Progress
- [ ] Error handling tests (0/3)
- [ ] Frontend components (not started)

## Key Decisions Made
- Used polymorphic relationship for requirement types
- Chose soft deletes over hard deletes (ADR-003)
- API pagination defaults to 25 items

## Blocked / Unresolved
- Question: Should requirements support file attachments? (waiting on PM)

## Files Modified This Session
- backend/Modules/Requirements/Database/Migrations/...
- backend/Modules/Requirements/Models/Requirement.php
- backend/Modules/Requirements/Http/Controllers/RequirementController.php
- backend/Modules/Requirements/Tests/Feature/RequirementTest.php

## Next Steps (for next session)
1. Write error handling tests (AC-010 through AC-012)
2. Implement frontend components (start with RequirementsList)
3. Resolve file attachment question with PM
```

### Context Management Strategy

1. **One task per session.** Never implement multiple features in one session.
2. **Read the spec at session start.** Always. Even if you "remember" it.
3. **Use subagents for exploration.** They run in isolated context and return summaries, saving main context for implementation.
4. **Use /compact proactively at ~70%.** It preserves architectural decisions while dropping verbose tool outputs.
5. **Write SESSION-LOG.md continuously.** Don't wait until the end when context is already degraded.
6. **Start new sessions confidently.** A fresh session with a good session log is better than a degraded long session.

### Context Splitting Strategy

For complex projects, prevent context rot by splitting information across purpose-specific files rather than loading everything into one session:

```
CLAUDE.md              → Project overview only (50-100 lines)
.claude/rules/*.md     → Per-domain rules (loaded only when touching those files)
docs/features/F0XX.md  → Only the current feature spec (not all specs)
SESSION-LOG.md         → Only current session state
```

**The principle:** Each agent/session loads ONLY what it needs. A backend agent implementing F004 reads: CLAUDE.md + .claude/rules/api-conventions.md + .claude/rules/testing.md + docs/features/F004.md + SESSION-LOG.md. It does NOT read frontend rules, other feature specs, or the full DEV-LOG.md.

**Why this matters:** Context doesn't degrade linearly. A session at 40% context usage produces significantly better output than one at 80%. By splitting context across files and loading selectively, you keep each session in the high-quality zone.

### Context Health Indicator

When doing a session handoff, record the context health:
```markdown
## Context Health
- Session length: ~45 tool calls
- Estimated context usage: ~65%
- Quality assessment: Good (no signs of degradation)
- Recommendation: Safe to continue in next session OR start fresh
```

This helps the next session decide whether to trust the previous session's output or review it more carefully.

---

## 11. Phase 8: Quality Assurance {#11-qa}

### QA is Continuous, Not a Phase

QA happens at five gates:

**Gate 1: Unit Tests (Immediate)**
Claude writes tests as part of implementation. TDD is enforced via hooks (hard enforcement) and .claude/rules (soft enforcement).

```
For logic-heavy code (API, services, validators):
  Write test → Confirm it fails → Implement → Confirm it passes

For complex multi-component UI (pages, tab layouts, data grids):
  Build component(s) → Write characterization tests → Confirm they pass
  → Verify tests fail when component is removed (proves test validity)
```

**Why the distinction:** Strict test-first for complex UI requires predicting DOM structure, component library rendering, and text splitting across elements — unknowable until implementation. Field-tested across 200+ frontend tests: complex UI tests written first required 30-50% rewriting after implementation. For simple UI (a button, a form, a single component), test-first still works fine.

**Gate 2: Integration Tests (Per Feature)**
After each feature is complete:
- Run full test suite
- Check for regressions
- Verify cross-module interactions

**Gate 2b: Database Parity Check (Every 2 Waves)**
If your test suite runs against a different database engine than production (e.g., SQLite for speed, PostgreSQL in production), you MUST run the full suite against the real engine at least once every 2 waves. Common differences that cause real bugs:

| Difference | SQLite | PostgreSQL |
|-----------|--------|------------|
| `LIKE` operator | Case-insensitive | Case-sensitive (use `ILIKE`) |
| Foreign key enforcement | Off by default | Always enforced |
| Self-referencing FKs | Works in `CREATE TABLE` | Requires separate `ALTER TABLE` |
| `information_schema` | Doesn't exist | Full system catalog |
| JSON operators | Limited | Full JSONB support |
| Column length enforcement | Silently truncates | Throws error |

**Field-tested evidence:** Across 25 implementation waves, 5 of 8 bugs found during integration testing were SQLite/PostgreSQL behavioral differences that passed all unit tests. These are not edge cases — they are the most common class of boundary bugs in modern web development.

**Gate 3: Browser Validation (After Feature Complete — MANDATORY)**
Claude Code must actually interact with the running application to verify the feature works end-to-end — not just pass unit tests. Use browser automation (Playwright MCP, Claude Chrome Extension, or similar) to:
- Navigate to the feature in the running app
- Click through the primary user flow (happy path)
- Verify visual output matches expectations (screenshots)
- Test at least one error path in the actual UI
- Confirm loading states, empty states, and transitions work

This is mandatory for any feature with a user-facing frontend. For backend-only features, use API calls (curl, httpie, or Postman MCP) to validate endpoints against real responses, not just test assertions.

**Role-Based Walkthrough:** Don't just click through as "a user" — adopt a specific user role defined in the feature spec and walk through the feature as that persona would. Read the spec's User Roles section and pick the primary role for this feature.

Example: For an "Organization Management" feature, walk through as:
- **As Consultant:** Create a new organization → invite a team member → assign roles → verify the dashboard shows the new org
- **As Client (Viewer):** Log in → verify you can see the org but NOT edit settings → attempt restricted actions → verify proper permission errors
- **As Admin:** Access admin panel → verify user management works → test role changes

This surfaces real UX issues that unit tests never catch: confusing labels, unclear navigation, missing feedback after actions, permission states that feel broken, flows that technically work but feel wrong. Each role experiences the feature differently — validate each one that the spec defines.

**Why this matters:** Tests prove code correctness in isolation. Browser validation proves the feature works as a user would experience it. Role-based walkthroughs prove the feature works for each persona. A passing test suite with a confusing UX is still a broken feature.

**Gate 4: Human Review (Before Merge)**
- Code review for architecture alignment
- Security review (auth, input validation, data exposure)
- UX review (if frontend changes)
- Performance review (if data-heavy changes)

The 2025 DORA Report confirms: TDD is MORE effective with AI agents than traditional development. It acts as an amplifier — tests written first prevent agents from "cheating" by writing tests that verify broken behavior.

### QA Checklist for AI-Generated Code

```markdown
## Code Quality
- [ ] Follows project conventions (check CLAUDE.md rules)
- [ ] No hardcoded values (use config/env)
- [ ] Error handling is comprehensive
- [ ] Input validation on all endpoints
- [ ] No N+1 query issues
- [ ] Proper use of database transactions

## Security
- [ ] Auth required on all private endpoints
- [ ] Authorization checks (policies/gates)
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (output encoding)
- [ ] CSRF protection on state-changing operations
- [ ] No secrets in code or logs
- [ ] No MCP prompt injection vulnerabilities
- [ ] Dependencies scanned for known vulnerabilities

## Testing
- [ ] Tests cover happy path
- [ ] Tests cover error cases (≥3 per endpoint)
- [ ] Tests cover edge cases
- [ ] Coverage ≥85% for changed files
- [ ] No flaky tests
- [ ] Factories include boundary-value states (max-length strings, null-heavy records, unicode)
- [ ] Tests run against production database engine at least once this wave (if test DB differs from production)
- [ ] Boundary tests: test DB operator differences (LIKE/ILIKE, JSON, FK enforcement) if applicable

## Accessibility
- [ ] Keyboard navigation works for all interactive elements
- [ ] ARIA labels on icons, buttons without visible text
- [ ] Focus management after modal open/close, page navigation
- [ ] Color contrast meets WCAG 2.1 AA (4.5:1 for text, 3:1 for UI)
- [ ] Screen reader tested on key workflows

## Internationalization
- [ ] All user-facing strings extracted to translation files
- [ ] Dates, numbers, currency formatted per locale
- [ ] No hardcoded locale-specific content
- [ ] RTL layout tested (if applicable)

## Performance
- [ ] Database indexes on queried columns
- [ ] Pagination on list endpoints
- [ ] Eager loading for relationships
- [ ] Cache strategy for read-heavy data
- [ ] API response time within budget (<200ms reads, <500ms writes)
- [ ] Bundle size within budget (<250KB initial)
- [ ] No unnecessary re-renders in React components

## Dependency Management
- [ ] No known vulnerabilities in dependencies (npm audit, composer audit)
- [ ] Dependencies pinned to specific versions (lockfile committed)
- [ ] No unused dependencies
- [ ] License compatibility verified for new dependencies

## Browser Validation (mandatory for UI features)
- [ ] Application is running and accessible
- [ ] User role identified from spec (walk through AS that persona)
- [ ] Primary user flow clicked through end-to-end (happy path) as primary role
- [ ] Secondary role walkthrough completed (e.g., viewer, admin — verify permissions and restricted states)
- [ ] Screenshot captured and visually verified
- [ ] At least one error path tested in actual UI
- [ ] Loading states and empty states verified
- [ ] UX assessment: labels clear? Navigation intuitive? Feedback after actions? Permission errors helpful?
- [ ] Responsive behavior checked (if applicable)
- [ ] For backend-only: API endpoints called with real HTTP requests (not just test assertions)

## AI-Specific Quality
- [ ] Code survival check: will this code last >2 weeks?
- [ ] No over-engineering (AI agents tend to add unnecessary abstractions)
- [ ] Spec alignment: does implementation match acceptance criteria?
- [ ] Session log updated with decisions made
- [ ] API documentation (OpenAPI) updated if endpoints changed
- [ ] DEV-LOG.md appended with session summary
```

### Automated QA with Hooks

```json
// .claude/settings.json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "command": "cd backend && php artisan test --stop-on-failure 2>&1 | tail -5"
      }]
    }]
  }
}
```

---

## 12. Phase 9: Git Workflow & CI/CD {#12-git}

### Branch Strategy

```
main                           # Production-ready code
├── develop                    # Integration branch
│   ├── feature/org-mgmt       # Feature branches
│   ├── feature/vendor-db      # One per feature spec
│   └── feature/ai-integration
├── hotfix/critical-bug        # Emergency fixes
└── release/v3.0.0             # Release candidates
```

### Commit Conventions

```
feat(module): add organization CRUD endpoints
fix(auth): resolve token refresh race condition
test(evaluation): add phase gate integration tests
docs(spec): update F002 requirements spec
refactor(tco): extract calculation to service class
chore(deps): update Laravel to 11.5
```

### Atomic Commits Per Task

When using the XML task format (see Section 9), commit after each task completes its `<verify>` step. This produces a clean, granular commit history:

```
feat(requirements): create requirements migration (task 1/8)
feat(requirements): add Requirement model + factory (task 2/8)
feat(requirements): add RequirementController + routes (task 3/8)
test(requirements): add API endpoint tests (task 4/8)
feat(requirements): add RequirementPolicy + authorization (task 5/8)
...
```

**Benefits:**
- `git bisect` pinpoints exactly which task introduced a regression
- Each commit is independently revertable without affecting other tasks
- Future Claude sessions can parse the commit history to understand implementation order
- PR reviews are easier — review task by task, not one massive diff

### PR Template

```markdown
## Summary
[1-3 bullet points]

## Feature Spec
[Link to docs/features/F###-name.md]

## Changes
- Backend: [what changed]
- Frontend: [what changed]
- Database: [migration changes]

## Testing
- [ ] All tests pass
- [ ] Coverage ≥85% on changed files
- [ ] Manual testing completed

## Screenshots
[If frontend changes]
```

### CI/CD Pipeline

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  # Gate 1: Unit tests on fast database (SQLite) for quick feedback
  backend-tests-fast:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.4'
      - run: cd backend && composer install
      - run: cd backend && php artisan test --coverage-min=85

  # Gate 2b: Database parity — same tests, real database engine
  # This catches LIKE/ILIKE, FK enforcement, JSON operator, and column
  # length differences that SQLite silently ignores.
  backend-tests-pgsql:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_DB: testing
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
        ports: ['5432:5432']
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    env:
      DB_CONNECTION: pgsql
      DB_HOST: localhost
      DB_PORT: 5432
      DB_DATABASE: testing
      DB_USERNAME: test
      DB_PASSWORD: test
    steps:
      - uses: actions/checkout@v4
      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.4'
      - run: cd backend && composer install
      - run: cd backend && php artisan migrate --force
      - run: cd backend && php artisan test

  # Frontend unit tests
  frontend-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: cd frontend && npm ci
      - run: cd frontend && npx vitest run --coverage

  # Frontend lint + build
  frontend-lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: cd frontend && npm ci
      - run: cd frontend && npm run lint
      - run: cd frontend && npm run build

  # Contract validation: verify frontend TypeScript types match real API responses
  # This runs the backend, hits real endpoints, and validates response shapes.
  contract-check:
    runs-on: ubuntu-latest
    needs: [backend-tests-pgsql]
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_DB: testing
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
        ports: ['5432:5432']
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    steps:
      - uses: actions/checkout@v4
      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.4'
      - run: cd backend && composer install
      - run: cd backend && php artisan migrate --seed --force
      - name: Start backend
        run: cd backend && php artisan serve --port=8000 &
      - name: Wait for backend
        run: sleep 3 && curl -f http://localhost:8000/api/v1/health || exit 1
      - name: Validate API contracts
        run: |
          # Hit key endpoints, save responses, validate against expected shapes
          # This replaces fragile "read PHP code and guess the TypeScript type" approach
          cd frontend && node scripts/validate-contracts.js
```

**Why both `backend-tests-fast` AND `backend-tests-pgsql`?** Fast feedback (SQLite, ~10s) catches logic bugs immediately. Parity testing (PostgreSQL, ~30s) catches boundary bugs. Running both in parallel gives you speed AND correctness. Field-tested: 5 of 8 integration bugs in a 22-feature build were database parity issues that passed SQLite tests.

**Why `contract-check`?** Frontend TypeScript types built by reading backend controller code are fragile. Field-tested: `p.evaluations.length` crashed because the API omits `evaluations` on list endpoints, but the TypeScript type assumed it was always present. The contract check hits real endpoints and validates response shapes match what the frontend expects.

---

## 13. Phase 10: Deployment & Monitoring {#13-deployment}

### Example Stack (Next.js + Laravel — Adapt to Your Stack)

Your deployment stack will vary. The important principles are: automated deployment, rollback capability, environment variable management, and monitoring. The specific services are less important than the patterns. Below is one example (pricing approximate, as of early 2026 — verify current rates):

| Component | Example Service | Cost (Startup) |
|-----------|---------|---------------|
| Frontend | Vercel (Next.js) | Free → $20/mo |
| Backend API | Railway (Laravel) | $20-30/mo |
| Database | Railway PostgreSQL | $15/mo |
| Cache | Upstash Redis | $10/mo |
| File Storage | S3-compatible | $5/mo |
| **Total** | | **~$50-80/mo** |

### Deployment Checklist

```markdown
## Pre-Deploy
- [ ] All tests pass on CI
- [ ] Database migrations reviewed
- [ ] Environment variables set
- [ ] Feature flags configured

## Deploy
- [ ] Backend deployed (Railway auto-deploy on push)
- [ ] Migrations run (php artisan migrate)
- [ ] Frontend deployed (Vercel auto-deploy on push)
- [ ] Cache cleared (php artisan cache:clear)

## Post-Deploy
- [ ] Smoke test critical flows
- [ ] Check error monitoring
- [ ] Verify database migrations applied
- [ ] Monitor response times
- [ ] Performance budgets verified (Lighthouse, API response times)
```

### Rollback Strategy

Every deployment must have a rollback plan. Define this before deploying, not during an incident.

**For backend (Railway/server deployments):**
- Keep the previous deployment available (Railway retains deployment history)
- Database migrations must be backward-compatible (add columns, never remove in the same release)
- If a migration is destructive (column removal, table drop), do it in a separate release after the code no longer references it
- Rollback command: `railway rollback` or redeploy previous commit

**For frontend (Vercel/static deployments):**
- Vercel keeps every deployment as an immutable snapshot
- Rollback = promote previous deployment to production
- Feature flags allow disabling broken features without redeploying

**For database:**
- Never write irreversible migrations in the same release as the code that uses them
- Pattern: Release 1 = add new column (nullable) + deploy code that writes to it. Release 2 = backfill data + deploy code that reads from it. Release 3 = make column required + remove old code path.

### Incident Response Playbook

When something breaks in production:

```
1. DETECT    → Error monitoring alerts (Sentry, Bugsnag, or similar)
2. ASSESS    → Is it user-facing? How many users affected?
3. MITIGATE  → Feature flag off? Rollback? Hotfix?
4. DIAGNOSE  → Root cause analysis (after mitigation, not before)
5. FIX       → Hotfix branch → test → deploy
6. DOCUMENT  → Incident report: what happened, why, how to prevent
```

The key principle: **mitigate first, diagnose second.** Turn off the broken feature or rollback the deployment before spending time understanding why it broke.

### Dependency Update Strategy

Keep dependencies current to avoid security vulnerabilities and painful major upgrades:

**Weekly:** Run `npm audit` and `composer audit`. Fix critical vulnerabilities immediately.

**Monthly:** Update patch versions. Run full test suite after updating.

**Quarterly:** Evaluate minor version updates. Review changelogs for breaking changes.

**Annually (or as needed):** Plan major version upgrades (e.g., Laravel 11 → 12, Next.js 15 → 16). These are separate planning efforts, not routine maintenance.

**Automation:** Use Dependabot or Renovate for automated PRs. CI must pass before merging dependency updates.

---

## 14. Enforcement: What Can Be Automated {#14-enforcement}

### The Enforcement Matrix

Not all best practices can be enforced equally. Understanding what's hard-enforced vs. soft-enforced vs. manual is critical for setting expectations.

| Practice | Method | Level | Notes |
|---|---|---|---|
| Run tests after every edit | PostToolUse hook | **Hard** | Hook fires automatically — agent can't skip it |
| Auto-format code | PostToolUse hook | **Hard** | Linter runs after edits, no context needed |
| Block migration edits | PreToolUse hook | **Hard** | Hook rejects edits to migration files |
| Module boundary checks | PreToolUse hook + static analysis | **Hard** | Reject cross-module imports |
| PR review before merge | GitHub branch protection | **Hard** | Git-level, not Claude-level |
| Write tests before code (TDD) | .claude/rules/testing.md | **Soft** | Works well in fresh sessions, degrades over time |
| Read spec before implementing | .claude/rules/workflow.md | **Soft** | Must re-read each session |
| Context management | Hook + session log | **Soft** | Can log tool usage, can't directly read token count |
| Spec-first workflow | Custom skill | **Soft** | Skill enforces spec-read step |
| Architecture compliance | Human review + CI | **Manual** | Can't fully automate architectural judgment |
| Code quality judgment | Human review | **Manual** | AI can generate, but humans must judge |

### Hook Examples

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{
          "type": "command",
          "command": "cd backend && php artisan test --stop-on-failure 2>&1 | tail -10"
        }]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Edit",
        "hooks": [{
          "type": "command",
          "command": "echo '$FILE_PATH' | grep -q 'migrations/' && echo 'BLOCKED: Cannot modify existing migrations' && exit 1 || exit 0"
        }]
      }
    ]
  }
}
```

### What Hooks Cannot Do (Yet)

- Cannot read current token count (no context-awareness API)
- Cannot enforce ordering ("must read spec before writing code")
- Cannot compose with skills (hooks and skills are separate systems)
- Cannot communicate across sessions (use Tasks feature instead)

For enforcement gaps, custom skills provide the best workaround — see Section 15.

---

## 15. Skill Architecture & Usage {#15-skills}

### What Are Skills and Where Do They Live?

Skills are different things in different environments:

- **Cowork:** Uses **plugins** — packaged bundles of skills, MCP connectors, and slash commands. Installed via the plugin system. Best for non-codebase work.
- **Claude Code:** Uses **SKILL.md files** — markdown instruction files in the repository or user directory. Auto-discovered and invoked based on task context. Best for codebase-aware workflows.

### The Wavecraft Skill Suite

A single plugin containing all 8 skills, installable in both Cowork and Claude Code. Users choose their preferred environment — the skills work everywhere.

```
PLANNING SKILLS (Cowork preferred, Claude Code compatible)
├── wavecraft:research    → Deep research, competitor analysis
├── wavecraft:design      → User flows, component decisions, a11y/i18n
├── wavecraft:spec        → Write feature specs from template
└── wavecraft:architect   → ADRs, architecture decisions, API contracts

IMPLEMENTATION SKILLS (Claude Code preferred, Cowork compatible*)
├── wavecraft:setup       → Configure CLAUDE.md, rules, hooks
├── wavecraft:implement   → Read spec → TDD → implement → log
├── wavecraft:review      → QA checklist, coverage, PR prep
└── wavecraft:handoff     → Write SESSION-LOG.md, summarize

* Implementation skills run in Cowork but with limited capability
  (no hooks, no test execution, no git). Full power in Claude Code.
```

**Installation:**
- Cowork: Install `wavecraft.plugin` via the plugin system
- Claude Code: `claude plugin add github:wavecraft/wavecraft`
- Both: Install in both environments for the best experience

### Why a Suite, Not One Skill

A single monolithic skill would consume too much context when loaded and be hard to maintain. Each skill does one thing well and is loaded only when relevant. This mirrors the spec-driven philosophy: modular, focused, composable.

### When Each Skill Triggers

**wavecraft:research** (Planning)
Triggers: "research this feature", "competitor analysis", "technical feasibility"
Does: Reads DISCUSSION-LOG.md (mandatory), guides through research toolkit, produces Research Brief markdown at `docs/research/RESEARCH-BRIEF.md`. Updates DISCUSSION-LOG.md with findings.
Enforces: Must read DISCUSSION-LOG.md before starting. Must produce Research Brief before completing. Must capture all findings in DISCUSSION-LOG.md.

**wavecraft:design** (Planning)
Triggers: "design this feature", "user flows", "component decisions", "wireframe", "UX for"
Does: Reads DISCUSSION-LOG.md (mandatory), guides through user flow mapping, component decisions, interaction patterns, a11y/i18n baseline. Produces DESIGN-DECISIONS.md. Updates DISCUSSION-LOG.md.
Enforces: Must read DISCUSSION-LOG.md before starting. Must produce design document before completing. Must capture all decisions in DISCUSSION-LOG.md.

**wavecraft:spec** (Planning)
Triggers: "write a spec", "plan a feature", "create feature spec"
Does: Reads DISCUSSION-LOG.md and DESIGN-DECISIONS.md (mandatory), creates spec from EARS template including a11y/i18n sections, validates completeness against checklist, estimates implementation effort. Produces `docs/features/F0XX-name.md` and updates `docs/SPEC.md` index.
Enforces: Must read DISCUSSION-LOG.md before starting. Must include all EARS sections (including Accessibility, i18n, Out of Scope). Must produce spec file in correct location. Must update SPEC.md index. Must capture decisions in DISCUSSION-LOG.md.

**wavecraft:architect** (Planning)
Triggers: "architecture decision", "write an ADR", "design the system"
Does: Reads DISCUSSION-LOG.md (mandatory), creates ADR from template, validates against existing architecture, documents trade-offs. Produces ADRs, updates ARCHITECTURE.md, creates/updates openapi.yaml for API contracts.
Enforces: Must read DISCUSSION-LOG.md before starting. Must produce ADR file in correct location. Must define performance budgets. Must update DISCUSSION-LOG.md with architecture decisions.

**wavecraft:setup** (Implementation)
Triggers: "setup project for claude", "initialize agentic workflow", "configure claude code"
Does: Creates CLAUDE.md from template (50-100 lines), sets up .claude/rules/ with testing, API, security, frontend, and module rules, configures hooks for test running and formatting, creates full docs/ directory structure, creates SESSION-LOG.md and DEV-LOG.md templates.
Enforces: Must create all required files. Must keep CLAUDE.md under 100 lines. Must configure at least test-running hooks. Must create docs/ structure matching the standard artifact map.

**wavecraft:implement** (Implementation)
Triggers: "implement F004", "build this feature", "start coding"
Does: Reads feature spec (mandatory — refuses to start without it), reads SESSION-LOG.md if exists, enforces TDD workflow (test first, confirm fail, implement, confirm pass), writes session log continuously, updates DEV-LOG.md at end of session, updates openapi.yaml if API endpoints are added/changed.
Enforces: Must read feature spec before any code is written. Must follow TDD cycle (will not write implementation without tests). Must update SESSION-LOG.md after each completed task. Must update DEV-LOG.md before session ends. Must update openapi.yaml for any API changes.

**wavecraft:review** (Implementation)
Triggers: "review this feature", "prepare for PR", "QA check"
Does: Runs full test suite, checks coverage against targets (≥85%), compares implementation against spec acceptance criteria (line by line), runs accessibility checks, verifies performance budgets, checks dependency vulnerabilities, generates PR description linking to spec.
Enforces: Must run test suite (not skip). Must verify each acceptance criterion. Must check a11y and performance. Must produce PR description. Must flag any spec gaps found during review.

**wavecraft:handoff** (Implementation)
Triggers: "save my progress", "session handoff", "wrap up session"
Does: Summarizes all changes made this session, documents decisions and their rationale, writes/updates SESSION-LOG.md with current state, appends to DEV-LOG.md with session summary, lists next steps for fresh session, verifies all modified files are committed or staged.
Enforces: Must produce SESSION-LOG.md with all required sections (Active Task, Completed, In Progress, Key Decisions, Files Modified, Next Steps). Must append to DEV-LOG.md. Must verify git status is clean or intentionally dirty.

### Build Priority

Start with the highest-value, lowest-complexity skills first:

1. **wavecraft:setup** (Claude Code) — Biggest time saver for new projects. One command creates the entire configuration.
2. **wavecraft:handoff** (Claude Code) — Solves the #1 pain point (context loss). Immediate value.
3. **wavecraft:spec** (Cowork) — Standardizes the handover artifact. High value because everything downstream depends on spec quality.
4. **wavecraft:implement** (Claude Code) — The core implementation skill. Most complex, but hooks + rules already cover most enforcement. Must be built before :review since you need code to review.
5. **wavecraft:review** (Claude Code) — Automates the QA checklist including new a11y, performance, and dependency checks.
6. **wavecraft:design** (Cowork) — Prevents implementation surprises on frontend-heavy features. Produces the design artifact that specs reference.
7. **wavecraft:research** (Cowork) — Nice to have, but unstructured research works fine too.
8. **wavecraft:architect** (Cowork) — Lowest priority, ADRs are simple enough without a skill.

---

## 16. Anti-Patterns to Avoid {#16-anti-patterns}

### 1. The Mega-Spec
**Problem:** One 1,000+ line specification file.
**Fix:** Break into focused feature specs of 50-150 lines each.

### 2. Vague Acceptance Criteria
**Problem:** "The system should handle errors gracefully."
**Fix:** "When the API returns a 422, the system shall display field-level validation errors below each invalid input."

### 3. Skipping Plan Mode
**Problem:** Jumping straight to implementation without understanding the codebase.
**Fix:** Always start with `claude --permission-mode plan` for new features.

### 4. Shared File Ownership in Team Mode
**Problem:** Two teammates editing the same file → last write wins.
**Fix:** Structure tasks so each teammate owns different files/directories.

### 5. No TDD Enforcement
**Problem:** Claude writes code first, then weak tests.
**Fix:** Embed TDD rules in .claude/rules/ and enforce test running via hooks.

### 6. Ignoring Context Window
**Problem:** Session degrades as context fills up.
**Fix:** One task per session, use /compact at 70%, write SESSION-LOG.md continuously, use subagents for exploration. See Section 10.

### 7. Overloading CLAUDE.md
**Problem:** 500+ lines in CLAUDE.md that Claude ignores.
**Fix:** Keep root CLAUDE.md to 50-100 lines. Use `.claude/rules/` for details.

### 8. Starting Multi-Agent Without Single-Agent Validation
**Problem:** Jumping to Team Mode before validating single agent works.
**Fix:** Prove the workflow works with one agent first, then parallelize.

### 9. No Human Review Gate
**Problem:** AI code goes directly to production.
**Fix:** Always require human PR review before merge.

### 10. Spec Drift
**Problem:** Code diverges from spec, spec never updated.
**Fix:** Update spec alongside code changes. Specs are living documents.

### 11. "Compile and Ship" Culture
**Problem:** Accepting agent output without review because "it works."
**Fix:** Treat AI as a junior developer — review everything. Code churn data shows AI-generated code gets discarded faster when not reviewed.

### 12. Expecting One-Shot Perfection
**Problem:** Expecting the first implementation to be production-ready.
**Fix:** Budget 2-3 iterations per feature. The spec-driven approach reduces iterations, but never eliminates them.

### 13. Doing Everything in One Environment
**Problem:** Trying to research, plan, implement, and review all in Claude Code.
**Fix:** Use the right tool for each phase. Research and specs in Cowork, implementation in Claude Code. See Section 2.

### 14. No Governance for Prompts
**Problem:** CLAUDE.md, rules, and agent definitions are treated as config, not code.
**Fix:** Git-track all prompt changes. Review them in PRs. Version them like code.

### 15. Skipping the Design Phase
**Problem:** Jumping from research/ideation straight to specs without making explicit design decisions. Claude Code makes its own UX choices, which don't match what the product needs.
**Fix:** Add a Design phase between Research and Specification. Document user flows, component decisions, interaction patterns, a11y baseline, and i18n requirements before writing specs.

### 16. No Documentation Continuity
**Problem:** Sessions end and context is lost. New sessions waste 10-20 minutes on re-orientation.
**Fix:** Every phase produces persistent artifacts. Every session starts by reading relevant artifacts. Every session updates artifacts before ending. Use the standard artifact map (Section 3).

### 17. Testing Against Wrong Database
**Problem:** Tests run on SQLite for speed, production uses PostgreSQL (or MySQL, etc.). Tests pass, but features are broken in production because database engines have different behaviors.
**Fix:** Run the full test suite against the production database engine at least once every 2 waves. Add a `test:pg` (or equivalent) command. Common traps: `LIKE` case sensitivity, FK enforcement, JSON operators, self-referencing FKs, `information_schema` availability, column length enforcement. This is the most common class of boundary bug in modern web development — field-tested across 25 waves, 5 of 8 integration bugs were database parity issues.

### 18. Happy-Path-Only Test Factories
**Problem:** Factories generate "nice" short strings and well-formed data. Real data has 60-character values in VARCHAR(50) columns, unicode, nulls, and edge-case combinations that factories never produce.
**Fix:** Every factory should include at least one boundary-value state: `->state('long_fields', ...)` that tests max-length strings, `->state('minimal', ...)` that tests null-heavy records. If you only test with factory defaults, you only test the happy path — the real data will surprise you.

### 19. Treating Passing Tests as Proof of Correctness
**Problem:** "All 320 tests pass" creates false confidence. Bugs live at boundaries — between database engines, between modules, between backend and frontend, between test environment and real environment. Unit and feature tests by design don't cross these boundaries.
**Fix:** Passing tests are necessary but not sufficient. Browser validation against the real stack is the actual proof. Add an "Integration Status" section to every session handoff documenting when the real stack was last tested and what boundaries remain untested.

---

## 17. Enterprise Adoption Playbook {#17-adoption}

### Week 0: Assessment & Readiness

**Goal:** Verify the team and codebase are ready.

- [ ] Codebase quality check: well-structured projects show 2-10x better agent performance
- [ ] CI/CD working: agents amplify existing quality — no tests means no good tests from agents
- [ ] Budget approved: $1,000-1,500/month per senior engineer for token costs
- [ ] AI Champion identified: one person who will invest 2-4 weeks learning deeply, then teach the team
- [ ] Team willingness assessed: opt-in works better than mandated adoption

### Week 1: Foundation

**Goal:** Get one developer productive with Claude Code.

- [ ] Set up CLAUDE.md with basic project info
- [ ] Configure `.claude/rules/` with testing and style rules
- [ ] Set up hooks for test running and formatting
- [ ] Complete one small feature (spec → implement → test → merge)
- [ ] Document learnings

### Week 2-3: Process

**Goal:** Establish spec-driven workflow across Cowork and Claude Code.

- [ ] Write 3-5 feature specs in Cowork using EARS template
- [ ] Commit specs to repository
- [ ] Enforce TDD via hooks and .claude/rules
- [ ] Set up CI/CD pipeline with quality gates
- [ ] Practice the full cycle: Research (Cowork) → Spec (Cowork) → Implement (Claude Code) → Review → Merge
- [ ] Implement SESSION-LOG.md pattern for context continuity

### Week 4: Scale

**Goal:** Introduce parallel development.

- [ ] Enable Team Mode for a medium feature
- [ ] Set up git worktrees for parallel work
- [ ] Configure specialized subagents (backend, frontend, QA)
- [ ] Measure: tokens spent vs. output quality
- [ ] Set up Tasks feature for cross-session coordination

### Month 2+: Optimize

**Goal:** Refine and accelerate.

- [ ] Build custom skills (start with :setup and :handoff)
- [ ] Connect MCP servers (GitHub, Jira, monitoring)
- [ ] Share best practices across the team (weekly "what worked" sessions)
- [ ] Track velocity improvement metrics
- [ ] Iterate on CLAUDE.md and rules based on what agents actually struggle with

### The AI Champion Role

Every successful adoption story has this role. Responsibilities:
- Owns CLAUDE.md and .claude/rules/ configuration
- Trains team members on spec-driven workflow
- Reviews and optimizes prompts/skills
- Tracks cost and quality metrics
- Facilitates weekly sharing sessions
- Stays current with Claude Code updates

### Maturity Model

**Level 1 — Ad Hoc:** Developers use AI chat occasionally. No shared practices. No spec workflow.

**Level 2 — Structured:** CLAUDE.md exists. Basic rules configured. Some features use specs. Single-agent workflow.

**Level 3 — Managed:** Full spec-driven workflow across Cowork and Claude Code. Hooks enforce quality. Session logs for continuity. Cost tracking.

**Level 4 — Optimized:** Multi-agent Team Mode. Custom skills deployed. Automated governance. Metrics-driven improvement. AI Champion role established.

**Level 5 — Transformative:** AI-first culture. Every feature starts with spec. Continuous learning loop. Organization-wide best practices. Contributing back to community.

### Metrics to Track

| Metric | Baseline | Target |
|--------|----------|--------|
| Feature delivery time | X days | X * 0.4 days (60% faster) |
| Test coverage | Current % | ≥85% |
| Bug rate (post-deploy) | Current | 50% reduction |
| Token cost per feature | Establish | Optimize over time |
| Spec-to-code accuracy | Establish | ≥90% first-pass |
| Code survival time | Establish | >4 weeks (inverse of churn) |
| Iteration count to production | Establish | ≤3 per feature |

### Culture Shift

The most successful adopters (like incident.io) found that:

1. **Leadership mandate matters.** The CTO saying "invest heavily in AI tooling" accelerated adoption faster than bottom-up experimentation.

2. **Gamification helps.** Token usage leaderboards create healthy competition and normalize AI usage.

3. **AI-first culture.** Claude Code becomes the first stop for any coding task — not a last resort.

4. **Shared learnings.** Weekly "what worked" sessions where developers share effective patterns.

5. **Budget for experimentation.** Token costs are an investment. Teams that worry about token costs under-utilize the tool.

6. **Honest quality tracking.** Measure code survival time, not just velocity. Speed without sustainability creates technical debt faster.

### Failure Patterns to Avoid

- **"Compile and ship" culture:** Teams accept agent output without review. Quality drops within weeks.
- **No governance:** Policies in documents, not in code. Agents drift without constraints.
- **Token anxiety:** Teams that obsess over costs under-utilize the tool and see poor ROI.
- **Mandated adoption:** Top-down mandates without training create resentment.
- **Ignoring existing quality:** Agents amplify what's there. Bad codebase + agents = more bad code faster.

---

## Quick Reference Card

```
┌──────────────────────────────────────────────────────────┐
│              AGENTIC ENGINEERING WORKFLOW                  │
├──────────────────────────────────────────────────────────┤
│                                                           │
│  ── COWORK / CLAUDE DESKTOP ──                           │
│  1. IDEATE    → Research Brief (1-2 pages)                │
│  2. DESIGN    → User flows, component decisions, a11y     │
│  3. SPECIFY   → Feature Specs (EARS format, modular)      │
│  4. ARCHITECT → ADRs + Data Model + API Contracts         │
│                                                           │
│  ── HANDOVER: Commit specs + design docs to repo ──      │
│                                                           │
│  ── CLAUDE CODE ──                                       │
│  5. SETUP     → CLAUDE.md + .claude/rules + hooks         │
│  6. IMPLEMENT → TDD, subagents, worktrees                 │
│  7. CONTEXT   → SESSION-LOG.md, /compact, one task/session│
│  8. QA        → Continuous (unit → integration → human)   │
│  9. MERGE     → PR review → CI green → merge to develop   │
│  10. DEPLOY   → Staging → smoke test → production         │
│                                                           │
│  ⟳ FEEDBACK LOOP: Implementation → Spec updates          │
│                                                           │
│  Continuity Principle:                                    │
│  Every phase produces persistent artifacts.               │
│  Every session reads artifacts first, updates them last.  │
│  No context is ever lost between sessions.                │
│                                                           │
│  Enforcement Hierarchy:                                   │
│  1. Hooks        (guaranteed, always fires)               │
│  2. .claude/rules (auto-loaded, strong suggestions)       │
│  3. CLAUDE.md     (project context, degrades over time)   │
│  4. Verbal        (weakest, lost in long sessions)        │
│                                                           │
│  Wavecraft Suite (8 skills, all enforce workflow):        │
│  Planning:  :research, :design, :spec, :architect         │
│  Implement: :setup, :implement, :review, :handoff         │
│                                                           │
│  Standard Artifacts:                                      │
│  PROCESS.md          → Phase tracking                     │
│  DISCUSSION-LOG.md   → All decisions (Cowork continuity)  │
│  SESSION-LOG.md      → Current state (CC continuity)      │
│  DEV-LOG.md          → Cumulative history                 │
│  docs/features/      → Modular feature specs              │
│  docs/api/openapi.yaml → API contracts                    │
│  CHANGELOG.md        → Release notes                      │
│                                                           │
│  Golden Rules:                                            │
│  • Right tool for each phase                              │
│  • Document continuously, not at the end                  │
│  • Design before specs, specs before code                 │
│  • Tests before implementation                            │
│  • Browser-validate UI features (role-based) [Browser QA] │
│  • Budget 2-3 iterations per feature                      │
│  • One task per session                                   │
│  • Human reviews before merge                             │
│  • CLAUDE.md stays concise (50-100 lines)                │
│  • API contracts are living documents                     │
│  • Rollback plan before every deploy                      │
│  • Every task has a <verify> step (<60s) [Nyquist]       │
│  • One task = one commit [Atomic Commits]                 │
│  • Right model for each activity [Model Profiles]         │
│  • Load only what you need per session [Context Split]    │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

---

## Research Sources

This guide incorporates findings from:
- **incident.io:** Claude Code adoption case study, git worktrees pattern
- **Sanity:** "First attempt will be 95% garbage", budget recommendations
- **Rakuten:** Sustained autonomous coding benchmarks
- **Accenture × Anthropic:** Enterprise training at scale
- **Red Hat Developer:** Spec-driven development for AI coding quality
- **JetBrains:** Spec-driven approach validation
- **Addy Osmani:** How to write a good spec for AI agents
- **2025 DORA Report:** AI as amplifier for existing practices
- **METR Study:** Individual productivity uplift data
- **Anthropic Documentation:** Claude Code features, hooks, skills, agent teams

---

*This guide is a living document. Version 3.1 — Updated with XML task format, Nyquist validation rule, atomic commits per task, wave-based execution, model profiles for cost management, context splitting strategy, context health indicators, Gherkin as alternative acceptance format, and deployment readiness checks. Previous: v3.0 added Design phase, continuous documentation, standard artifact map, API contracts, a11y/i18n, performance budgets, rollback/incident response, dependency management, and skill enforcement.*
