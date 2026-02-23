# CLAUDE.md Writing Guide

## Purpose

CLAUDE.md is the project context file loaded into every Claude Code session. It tells Claude what this project is, how to work with it, and what rules to follow. Keep it concise — every line costs tokens in every session.

## Hard Rules

- **Maximum 100 lines.** Anything longer wastes context across every session.
- **No tutorials or explanations.** Claude already knows how frameworks work. Only document what's specific to YOUR project.
- **Commands must be copy-pasteable.** Include the full command with directory context.
- **Critical rules must be NEVER/ALWAYS.** Vague guidance gets ignored in long sessions.

## Template

```markdown
# [Project Name]

[One sentence: what this is. Two sentences max: stack and architecture.]

## Commands
- Full stack: [command to start everything]
- Frontend dev: [command]
- Backend dev: [command]
- Run all tests: [command]
- Run specific test: [command with placeholder]
- Lint: [command]
- Format: [command]

## Architecture
- [Where backend code lives and how it's organized]
- [Where frontend code lives and how it's organized]
- [Key architectural pattern (modular monolith, microservices, etc.)]
- [How modules/packages communicate]

## Conventions
- API: [REST/GraphQL, response format, versioning]
- Auth: [mechanism, session/token type]
- Naming: [camelCase/snake_case per language]
- [Any other project-specific convention]

## Testing
- Every feature needs tests BEFORE implementation (TDD)
- Run relevant tests after changes
- Minimum [X]% coverage per module/package

## Critical Rules
- NEVER [thing that would break the project]
- NEVER [another dangerous action]
- ALWAYS [important invariant]
- ALWAYS [another important invariant]
```

## What NOT to Include

- Framework documentation (Claude knows React, Django, Laravel, etc.)
- Obvious things ("use git for version control")
- Long lists of all files or all endpoints
- Setup instructions for new developers (put those in README.md)
- Historical context or changelog

## Examples by Stack

### Python + Django + React
```markdown
# MyApp

SaaS analytics platform. Django 5 API + React 19 frontend + PostgreSQL.

## Commands
- Backend: cd backend && python manage.py runserver
- Frontend: cd frontend && npm run dev
- Tests: cd backend && pytest
- Specific test: pytest tests/test_file.py::test_name
- Lint: cd frontend && npm run lint
- Migrate: cd backend && python manage.py migrate

## Architecture
- Apps: backend/apps/ (one Django app per domain)
- Frontend: frontend/src/app/ (Next.js App Router)
- API: Django REST Framework, versioned at /api/v1/
- Shared: backend/core/ (base classes, utilities, mixins)

## Conventions
- API: REST, JSON, snake_case keys
- Auth: JWT via djangorestframework-simplejwt
- Naming: snake_case (Python), camelCase (TypeScript)

## Testing
- TDD: write tests first, verify they fail, then implement
- pytest with factory_boy for fixtures
- Minimum 85% coverage per app

## Critical Rules
- NEVER modify existing migration files
- NEVER import across app boundaries without an interface
- ALWAYS use select_related/prefetch_related for related objects
- ALWAYS validate input at the serializer level
```

### Go + htmx
```markdown
# InternalTool

Internal ops dashboard. Go 1.22 + htmx + SQLite.

## Commands
- Run: go run ./cmd/server
- Test: go test ./...
- Specific: go test ./internal/handlers -run TestName
- Build: go build -o bin/server ./cmd/server

## Architecture
- Handlers: internal/handlers/ (one file per resource)
- Models: internal/models/ (structs + DB methods)
- Templates: templates/ (Go html/template + htmx partials)
- Static: static/ (CSS, JS, images)

## Conventions
- Routes: net/http stdlib, no framework
- DB: sqlc for queries, goose for migrations
- Templates: base.html layout, partials for htmx swaps

## Testing
- Table-driven tests, httptest for handlers
- testcontainers for integration tests with real SQLite

## Critical Rules
- NEVER use ORM — all queries via sqlc
- NEVER return full pages for htmx requests — return partials only
- ALWAYS use context.Context for cancellation
```

### Ruby on Rails
```markdown
# Marketplace

Two-sided marketplace. Rails 7.2 API + Hotwire frontend + PostgreSQL.

## Commands
- Server: bin/rails server
- Console: bin/rails console
- Tests: bin/rails test
- Specific: bin/rails test test/models/user_test.rb
- Lint: bin/rubocop
- Migrate: bin/rails db:migrate

## Architecture
- Models: app/models/ (ActiveRecord, concerns in concerns/)
- Controllers: app/controllers/api/v1/ (API namespace)
- Views: app/views/ (Turbo Frames + Streams)
- Jobs: app/jobs/ (Sidekiq background processing)
- Services: app/services/ (business logic, one class per operation)

## Conventions
- API: JSON:API format via jsonapi-serializer
- Auth: Devise + doorkeeper for OAuth
- Naming: snake_case everywhere, plural controllers

## Testing
- Minitest + fixtures (not factories)
- System tests with Capybara for critical flows
- Minimum 90% line coverage

## Critical Rules
- NEVER put business logic in controllers — use services
- NEVER use callbacks for cross-model side effects — use events
- ALWAYS use strong parameters
- ALWAYS scope queries to current tenant
```
