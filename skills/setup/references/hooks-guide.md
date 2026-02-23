# Hooks Configuration Guide

## Purpose

Hooks are the strongest enforcement mechanism — they fire automatically and can't be skipped. Configure them in `.claude/settings.json`.

## Enforcement Hierarchy

```
1. Hooks        (guaranteed — fires every time, can't be bypassed)
2. .claude/rules (auto-loaded — strong but can be ignored in long sessions)
3. CLAUDE.md     (project context — degrades over time in long sessions)
4. Verbal        (conversation instructions — weakest, lost quickly)
```

Always prefer hooks for rules that MUST be followed.

## settings.json Structure

```json
{
  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...],
    "Stop": [...]
  }
}
```

## Essential Hook: Run Tests After Code Changes

This is the minimum hook every project needs. Adapt the test command to your stack.

### Python (pytest)
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{
          "type": "command",
          "command": "cd backend && python -m pytest --tb=short -q 2>&1 | tail -20"
        }]
      }
    ]
  }
}
```

### Node.js (vitest/jest)
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{
          "type": "command",
          "command": "cd frontend && npx vitest run --reporter=verbose 2>&1 | tail -20"
        }]
      }
    ]
  }
}
```

### Go
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{
          "type": "command",
          "command": "go test ./... 2>&1 | tail -20"
        }]
      }
    ]
  }
}
```

### Ruby (minitest/rspec)
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{
          "type": "command",
          "command": "cd backend && bundle exec rails test 2>&1 | tail -20"
        }]
      }
    ]
  }
}
```

### PHP (PHPUnit / pest)
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
    ]
  }
}
```

## Recommended Hook: Block Migration Edits

Prevents editing existing migration files (a common source of production issues).

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "hooks": [{
          "type": "command",
          "command": "echo '$FILE_PATH' | grep -q 'migrations/' && echo 'BLOCKED: Cannot modify existing migrations. Create a new migration instead.' && exit 1 || exit 0"
        }]
      }
    ]
  }
}
```

Adapt the path pattern to your framework:
- Django: `migrations/`
- Rails: `db/migrate/`
- Laravel: `database/migrations/`
- Go (goose): `migrations/`

## Optional Hook: Auto-Format After Edits

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{
          "type": "command",
          "command": "[YOUR FORMATTER COMMAND] 2>&1 | tail -5"
        }]
      }
    ]
  }
}
```

Formatter commands by stack:
- Python: `black . && isort .` or `ruff format .`
- Node/TS: `npx prettier --write .`
- Go: `gofmt -w .` (usually automatic)
- Ruby: `bundle exec rubocop -A`
- PHP: `./vendor/bin/pint`

## Combining Multiple Hooks

Multiple hooks on the same event run in order. Put fast checks first:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "[FORMATTER] 2>&1 | tail -5"
          },
          {
            "type": "command",
            "command": "[TEST RUNNER] 2>&1 | tail -20"
          }
        ]
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

## What Hooks Cannot Do

- Cannot read current token/context count
- Cannot enforce ordering ("must read spec before writing code")
- Cannot compose with skills (hooks and skills are separate systems)
- Cannot communicate across sessions

For these enforcement gaps, the Wavecraft skills compensate through mandatory step enforcement in the SKILL.md instructions.
