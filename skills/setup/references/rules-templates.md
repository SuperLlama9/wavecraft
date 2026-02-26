# .claude/rules/ Templates

## Purpose

Rule files in `.claude/rules/` are auto-loaded by Claude Code and provide enforcement that's stronger than CLAUDE.md. They don't degrade over long sessions because they're re-read from disk. Each file focuses on one concern.

## testing.md — Always Create This

Adapt the test runner and patterns to the project's stack.

```markdown
# Testing Rules

## TDD Workflow (Mandatory)
1. Write a failing test FIRST
2. Confirm the test fails (run it)
3. Write the minimal implementation to pass
4. Confirm the test passes (run it)
5. Refactor while keeping tests green
6. Commit

## Test Patterns
- One test file per source file
- Test names describe the behavior, not the method: `test_user_cannot_delete_others_projects`
- Use factories/fixtures for test data — never hardcode IDs or specific values
- Each test is independent — no shared mutable state between tests
- Test edge cases: empty input, null values, boundary conditions, permission denied

## Coverage
- Target: ≥85% per module/package
- Run coverage after completing a feature, not after every file
- Coverage command: [INSERT COMMAND]

## What to Test
- Every public API endpoint: happy path + at least 2 error cases
- Every model validation and business rule
- Every authorization check (who can and who cannot)
- Database constraints (unique, foreign key, not null)

## What NOT to Test
- Framework internals (don't test that the router routes)
- Getter/setter methods with no logic
- Third-party library behavior
```

## plan-completeness.md — Always Create This

```markdown
# Plan Completeness Gate

## Before Presenting Any Implementation Plan

Verify the plan covers EVERY section of the feature spec:

| Spec Section | Required Plan Coverage |
|---|---|
| Data Model | Migration + model + factory tasks |
| API Endpoints | Controller + route + form request tasks |
| UI Components | Frontend component + page tasks |
| Accessibility | a11y verification task (keyboard nav, ARIA, focus) |
| OpenAPI / API docs | openapi.yaml update task (if API endpoints added) |
| Browser Validation | Playwright smoke test task (if UI components added) |

## Rules

1. **Count all tasks first.** If >10, propose wave splitting before proceeding.
2. **Never silently omit spec sections.** If you plan to skip a section (e.g., "frontend later"), say so explicitly and get user approval.
3. **The user decides scope — not you.** Present the full picture, let them choose what to build now vs. later.
4. **After each wave, state what's pending.** Example: "Backend complete. Remaining: frontend (tasks 11-18), browser validation, OpenAPI update."
```

## security.md — Always Create This

```markdown
# Security Rules

## Authentication
- Every endpoint requires authentication unless explicitly marked as public
- Verify auth is checked in tests: request without token → 401

## Authorization
- Check object-level permissions, not just role-level
- Test: User A cannot access User B's resources
- Use policies/permissions (not inline checks in controllers)

## Input Validation
- Validate ALL input at the API boundary
- Never trust client-side validation alone
- Sanitize output to prevent XSS (use framework defaults)

## Data Protection
- Never log sensitive data (passwords, tokens, PII)
- Never commit secrets (.env, API keys, credentials)
- Use parameterized queries — NEVER interpolate SQL strings
- Hash passwords with bcrypt/argon2 — NEVER store plaintext

## Headers & CORS
- Set appropriate CORS origins (never wildcard in production)
- Include security headers (CSP, X-Frame-Options, etc.)
```

## api-conventions.md — Create If Project Has an API

```markdown
# API Conventions

## URL Structure
- RESTful: /api/v1/{resource} (plural nouns, not verbs)
- Nested resources max 2 levels: /api/v1/projects/{id}/tasks
- Use query params for filtering: ?status=active&sort=-created_at

## Request/Response Format
- Content-Type: application/json
- Use consistent envelope: { "data": ..., "meta": ... }
- Pagination: cursor-based preferred, offset OK for simple cases
- Include total count in meta for paginated responses

## Error Responses
- Standard format: { "error": { "code": "VALIDATION_ERROR", "message": "...", "details": [...] } }
- Use appropriate HTTP status codes:
  - 400: Bad request (validation failed)
  - 401: Unauthorized (no/invalid token)
  - 403: Forbidden (valid token, insufficient permissions)
  - 404: Not found
  - 409: Conflict (duplicate, state conflict)
  - 422: Unprocessable entity (semantic validation)
  - 500: Internal server error (never expose stack traces)

## Naming
- JSON keys: camelCase (JS convention) or snake_case (Python/Ruby convention) — pick one, be consistent
- Endpoint paths: kebab-case (e.g., /api/v1/user-profiles)
- Timestamps: ISO 8601 with timezone (e.g., 2026-01-15T14:30:00Z)

## API Documentation
- Maintain openapi.yaml in docs/api/
- Update openapi.yaml whenever endpoints change
- Include request/response examples for every endpoint
```

## frontend.md — Create If Project Has a Frontend

```markdown
# Frontend Rules

## Component Structure
- One component per file
- Colocate styles, tests, and types with the component
- Use the project's component library consistently (don't mix UI libraries)

## State Management
- Server state: [React Query / SWR / TanStack Query / Pinia / etc.]
- Client state: [Zustand / Redux / Context / Vuex / etc.]
- Form state: [React Hook Form / Formik / VeeValidate / etc.]
- Never store server data in client state — use the query cache

## Styling
- Use the project's styling approach consistently
- Responsive: mobile-first breakpoints
- Support dark mode if the project uses it

## Accessibility
- All interactive elements must be keyboard-navigable
- Use semantic HTML (button for actions, a for navigation)
- Images need alt text, icons need aria-label
- Form inputs need associated labels
- Color contrast ratio ≥ 4.5:1 (WCAG AA)
- Test with keyboard-only navigation

## Performance
- Lazy-load routes and heavy components
- Optimize images (WebP, proper sizing)
- Use loading states (skeleton screens, not spinners)
- Debounce search inputs and rapid-fire events
```

## database.md — Create If Using Database Migrations

```markdown
# Database Rules

## Migrations
- NEVER modify an existing migration file — create a new one
- NEVER write destructive migrations (drop column, drop table) in the same release as the code change
- Pattern for removing a column:
  1. Release 1: Deploy code that no longer reads the column
  2. Release 2: Migration to drop the column
- Always make new columns nullable or provide a default

## Queries
- NEVER use N+1 queries — always eager-load/join related data
- Use pagination for all list endpoints (never return unbounded results)
- Add database indexes for columns used in WHERE, ORDER BY, JOIN
- Wrap multi-table writes in transactions

## Naming
- Tables: plural snake_case (users, project_tasks)
- Columns: singular snake_case (created_at, user_id)
- Foreign keys: {singular_related_table}_id
- Indexes: idx_{table}_{column(s)}
```

## modules.md — Create If Using Modular Architecture

```markdown
# Module Boundary Rules

## Communication
- Modules communicate through defined interfaces/contracts only
- NEVER import models or services from another module directly
- Use events/messages for cross-module side effects
- Each module owns its database tables — no direct queries across modules

## Structure
- Each module has its own: models, controllers/handlers, services, tests
- Shared code lives in a designated shared/core module
- Module dependencies must be explicit and documented

## Adding a New Module
1. Create the module structure following existing patterns
2. Define public interfaces in contracts/interfaces directory
3. Register event listeners for cross-module communication
4. Update ARCHITECTURE.md with the new module's purpose
```
