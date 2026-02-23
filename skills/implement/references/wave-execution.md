# Wave-Based Execution Guide

For large features (10+ tasks), split implementation into waves. Each wave runs with fresh context, preventing the quality cliff that occurs past ~70% context usage.

## When to Use Waves

| Task Count | Strategy |
|------------|----------|
| 1-10 | Single session — no waves needed |
| 10-20 | Consider waves — ask the user |
| 20+ | Waves required — split into 5-8 task groups |

## How Waves Work

```
Wave 1: Data layer (migrations, models, factories, seeders)
  → Fresh context
  → Reads: spec + CLAUDE.md + relevant ADRs
  → Produces: data layer code + commits
  → Ends: SESSION-LOG.md updated, DEV-LOG.md appended

Wave 2: API layer (controllers, routes, validation, middleware)
  → Fresh context
  → Reads: spec + SESSION-LOG.md + git log from Wave 1
  → Produces: API code + commits
  → Ends: SESSION-LOG.md updated

Wave 3: Business logic (services, events, policies, jobs)
  → Fresh context
  → Reads: spec + SESSION-LOG.md + git log from Waves 1-2
  → Produces: business logic code + commits
  → Ends: SESSION-LOG.md updated

Wave 4: Frontend (components, hooks, pages, state)
  → Fresh context
  → Reads: spec + SESSION-LOG.md + git log from Waves 1-3
  → Produces: frontend code + commits
  → Ends: SESSION-LOG.md updated

Wave 5: Integration (E2E tests, API docs, browser validation)
  → Fresh context
  → Reads: spec + SESSION-LOG.md + git log from Waves 1-4
  → Produces: integration tests + updated openapi.yaml
  → Ends: Feature complete, ready for :review
```

## What Each Wave Reads

Each wave starts with a fresh context containing ONLY:
- The feature spec (always)
- SESSION-LOG.md (always — this is the bridge between waves)
- CLAUDE.md (always — project conventions)
- Git log from previous waves (`git log --oneline` for commit history)
- Relevant .claude/rules/ files

Each wave does NOT carry:
- The previous wave's full conversation
- The previous wave's tool call history
- Previous wave's in-memory reasoning

This is intentional — fresh context means sharp reasoning.

## SESSION-LOG.md Between Waves

The SESSION-LOG.md written at the end of each wave must be detailed enough for the next wave to start immediately. It must include:

- Which tasks are complete (with commit hashes if possible)
- Which tasks are next
- Any decisions made that affect later waves
- Any blockers or issues discovered
- The exact state of the codebase

## Wave Boundaries

Group tasks by layer, not by spec order. Within each layer, follow the dependency order from the XML task format.

**Don't split tightly coupled tasks across waves.** If task 4 (controller) depends on task 3 (tests), they should be in the same wave. The wave boundary should fall between natural layers.

**Good wave boundary:** Between "all API tests pass" and "start building frontend"
**Bad wave boundary:** Between "wrote 3 of 6 tests" and "write remaining 3 tests"

## Example: 15-Task Feature Split into 3 Waves

```
Wave 1 (Tasks 1-5): Data + API
  Task 1: Migration
  Task 2: Model + Factory
  Task 3: Write CRUD tests (red)
  Task 4: Implement controller (green)
  Task 5: Authorization policy

Wave 2 (Tasks 6-10): Business Logic + Frontend Setup
  Task 6: Service class for complex operations
  Task 7: Event listeners (notifications)
  Task 8: Frontend types + API client
  Task 9: List page component
  Task 10: Create/edit form component

Wave 3 (Tasks 11-15): Frontend Completion + Integration
  Task 11: Detail page component
  Task 12: Delete confirmation flow
  Task 13: E2E test for happy path
  Task 14: Update openapi.yaml
  Task 15: Browser validation (all roles)
```
