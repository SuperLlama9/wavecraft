# Feature Spec Template

Use this template when producing the final spec file at `docs/features/F0XX-[name].md`.

```markdown
# F0XX: [Feature Name]

## Overview
[2-3 sentences: What does this feature do? Why does it exist? Who benefits?]

## User Roles
| Role | Permissions |
|------|------------|
| [Role 1] | [What this role can do with this feature] |
| [Role 2] | [What this role can do] |

## Acceptance Criteria

### Core Functionality
AC-001: [criterion in EARS or Gherkin format]
AC-002: [criterion]
AC-003: [criterion]

### Error Handling
AC-010: [error scenario — validation, auth, system]
AC-011: [error scenario]
AC-012: [error scenario]

### Edge Cases
AC-020: [edge case — empty state, boundary, concurrent access]
AC-021: [edge case]

## Data Model

### [Entity] (table: entity_name)
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK | |
| [column] | [type] | [constraints] | [notes] |

### Relationships
- [Entity relationships]

### Indexes
- [Index definitions with rationale]

## API Endpoints

### [METHOD] /api/[resource]
**Auth:** [Required/Public]. Role: [role].
**Request:**
[JSON example with realistic data]
**Response ([status]):**
[JSON example with realistic data]
**Errors:**
- [status]: [description]

## UI Components
[Component definitions with behavior and states — or "N/A — [reason]"]

## Accessibility
[Keyboard nav, screen reader, focus management — or "N/A — [reason]"]

## Internationalization
[Translatable strings, formatting — or "N/A — [reason]"]

## Dependencies
- [What must exist before this feature]

## Out of Scope
- [What this feature explicitly does NOT include]
```

## Rules

1. Every spec must have ALL sections present — use "N/A — [reason]" for inapplicable sections
2. Every acceptance criterion must be independently testable
3. API examples must use realistic data, not just type annotations
4. Target length: 50-150 lines. If longer, split into sub-specs.
5. Estimated implementation time: 1-4 hours. If longer, split.
