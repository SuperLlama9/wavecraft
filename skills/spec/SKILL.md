---
name: spec
description: >
  Create modular, AI-consumable feature specifications using EARS or Gherkin format. This skill
  should be used when the user says "write a spec", "plan a feature", "create feature spec",
  "specify this", "write the requirements for", "document what we need to build", or any variation
  of writing structured requirements for a feature. Also trigger when the user mentions "feature
  spec", "acceptance criteria", "EARS", "Gherkin", or references a feature ID like "F004". Each
  spec is a self-contained document that Claude Code can implement in 1-4 hours.
version: 0.1.0
---

# wavecraft:spec — Feature Specification

Create modular, AI-consumable feature specifications. Each spec is a self-contained document with acceptance criteria, data model, API endpoints, and UI components — everything Claude Code needs to implement the feature without guesswork.

## Why This Matters

Without a spec, Claude Code makes assumptions. It guesses at edge cases, invents error handling, and builds UI that nobody asked for. A good spec eliminates this: every acceptance criterion is testable, every API endpoint is defined, every error state is documented. The spec becomes the contract between planning and implementation.

## When to Trigger

- "write a spec", "plan a feature", "create feature spec"
- "specify this", "write the requirements for", "document what we need to build"
- References to "acceptance criteria", "EARS", "Gherkin", "feature ID"
- After `:research` and/or `:design` have produced their artifacts

## Workflow

### Step 1: Read Context Files (Mandatory)

Read these files before writing any spec content. Refuse to proceed if DISCUSSION-LOG.md doesn't exist — offer to create it (bootstrap mode).

```
Read (mandatory):
├── DISCUSSION-LOG.md      → Decisions made, project context
│   (or PROJECT-LOG.md     → Lightweight mode equivalent)
├── PROCESS.md             → Current lifecycle phase
│   (or PROJECT-LOG.md     → Lightweight mode equivalent)

Read (if they exist):
├── docs/design/DESIGN-DECISIONS.md   → Design choices to reference
├── docs/design/user-flows/*.md       → User flows to implement
├── docs/SPEC.md                      → Existing spec index (to avoid ID conflicts)
├── docs/features/*.md                → Existing specs (for context and consistency)
└── docs/research/RESEARCH-BRIEF*.md  → Research findings
```

**Bootstrap mode:** If DISCUSSION-LOG.md doesn't exist, create it with: `# Discussion Log\n\n## [date]\nProject started. First spec session.` Then proceed.

If PROCESS.md doesn't exist, create it with a minimal template: project name, lifecycle phases, current status ("Phase 3: Specification"). Then proceed.

### Step 2: Identify Feature Scope

Ask the user:

1. **What feature are we specifying?** Get a clear description.
2. **What's the feature ID?** Follow the convention `F0XX-[name]` (e.g., F002-organizations). Check `docs/SPEC.md` to avoid ID conflicts.
3. **Who are the user roles?** Which roles interact with this feature and what permissions do they have?

### Step 3: Assess Scope and Granularity

Estimate implementation time. If the feature would take Claude Code more than 4 hours to implement, break it into sub-specs:

| Estimated Effort | Action |
|-----------------|--------|
| 1-4 hours | Single spec. Proceed normally. |
| 4-8 hours | Consider splitting into 2 specs. Ask the user. |
| 8+ hours | Must split. Identify natural boundaries (backend/frontend, CRUD/advanced, core/extensions). |

**Target:** Each spec should be 50-150 lines. Longer specs are harder for Claude Code to hold in context.

### Step 4: Choose Acceptance Criteria Format

Ask the user: "EARS or Gherkin format for acceptance criteria?" Provide a brief explanation:

**EARS (Event → Action → Result → Safeguard):**
Best for system behavior descriptions. Each criterion follows: "When [event], the system shall [action], resulting in [result]. If [safeguard condition], then [safeguard behavior]."

```
AC-001: When a user submits the registration form with valid data,
  the system shall create a new account and send a verification email,
  resulting in a redirect to the "check your email" page.
  If the email is already registered, the system shall display
  "An account with this email already exists" and link to the login page.
```

**Gherkin (Given → When → Then → But):**
Best for scenario-based testing. Maps directly to BDD test frameworks.

```
AC-001: Registration with valid data
  Given a visitor on the registration page
  When they submit the form with a valid email and password
  Then a new account is created
  And a verification email is sent
  And they are redirected to the "check your email" page
  But if the email is already registered
  Then "An account with this email already exists" is displayed
  And a link to the login page is shown
```

Default to EARS unless the user prefers Gherkin or the project already uses Gherkin.

### Step 5: Walk Through Acceptance Criteria

This is the core of the spec. Go through each requirement systematically:

**For each user action or system behavior:**

1. **Event:** What triggers this? (user action, system event, time-based trigger)
2. **Action:** What should the system do? (create, update, delete, display, send, validate)
3. **Result:** What's the observable outcome? (UI change, data change, notification, redirect)
4. **Safeguard:** What could go wrong? (invalid input, unauthorized access, race condition, network failure)

**Minimum requirements:**
- At least 3 error handling criteria (validation errors, auth errors, system errors)
- At least 2 edge cases documented (empty states, boundary conditions, concurrent access)
- Every criterion must be testable — if you can't write a test for it, it's too vague

**Walk through with the user.** Don't write all ACs in isolation — discuss each one, get confirmation, and refine. This is a conversation, not a monologue.

### Step 6: Define Data Model

For each entity this feature introduces or modifies:

```markdown
## Data Model

### [Entity Name] (table: entity_name)
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK | |
| name | VARCHAR(255) | NOT NULL | |
| created_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | |
| tenant_id | UUID | FK → tenants.id, NOT NULL | RLS policy |

### Relationships
- [Entity A] has many [Entity B]
- [Entity B] belongs to [Entity A] and [Entity C]

### Indexes
- UNIQUE(tenant_id, name) — prevent duplicate names per tenant
- INDEX(created_at) — for sorting/pagination
```

If this feature doesn't modify the data model, write: "No data model changes. Uses existing [entity] from [spec reference]."

### Step 7: Define API Endpoints

For each endpoint this feature introduces or modifies:

```markdown
## API Endpoints

### POST /api/[resource]
**Auth:** Required. Role: [role].
**Request:**
```json
{
  "name": "string (required, 1-255 chars)",
  "description": "string (optional, max 1000 chars)"
}
```
**Response (201):**
```json
{
  "id": "uuid",
  "name": "string",
  "created_at": "ISO 8601"
}
```
**Errors:**
- 400: Validation failed (name too long, missing required fields)
- 401: Not authenticated
- 403: Insufficient permissions
- 409: Duplicate name for this tenant
```

Include request/response examples with realistic data, not just type annotations. Claude Code will use these examples as reference during implementation.

If this feature has no API endpoints (pure frontend, or process automation), mark this section N/A with a reason.

### Step 8: Define UI Components (If Applicable)

For each component this feature introduces:

```markdown
## UI Components

### [Component Name]
**Location:** [where in the app this appears]
**Behavior:** [what it does, how users interact with it]
**States:**
- Default: [what it looks like normally]
- Loading: [skeleton/spinner/placeholder]
- Empty: [what shows when there's no data]
- Error: [what shows when something fails]
**Responsive:** [how it adapts to mobile/tablet]
```

Reference DESIGN-DECISIONS.md for component library, patterns, and interaction decisions.

If backend-only: Mark N/A — "Backend-only feature, no user-facing UI."

### Step 9: Define Accessibility Requirements (If Applicable)

```markdown
## Accessibility
- Keyboard navigation: [requirements — tab order, shortcuts]
- Screen reader: [ARIA labels, landmark regions, live regions]
- Focus management: [what gets focus after actions — modal open, form submit, error]
- Color contrast: [any specific requirements beyond WCAG AA baseline]
```

If backend-only or non-UI: Mark N/A with reason.

### Step 10: Define i18n Requirements (If Applicable)

```markdown
## Internationalization
- Translatable strings: [list of user-facing strings that need translation keys]
- Date/time formatting: [locale-sensitive? which format?]
- Number/currency formatting: [locale-sensitive?]
- Pluralization: [any strings that change with count?]
```

If not applicable: Mark N/A with reason.

### Step 11: Define Dependencies and Out of Scope

```markdown
## Dependencies
- Requires: [F001-auth] (user authentication must be implemented)
- Requires: [ADR-002] (multi-tenancy architecture must be in place)
- External: [SendGrid API for email sending — API key needed]

## Out of Scope
- Bulk import of [entity] (will be F005)
- Advanced permissions beyond role-based (will be F006)
- Real-time collaboration on [entity] (not planned)
```

"Out of Scope" is critical — it prevents Claude Code from gold-plating. If something isn't explicitly in scope, it shouldn't be built.

### Step 12: Validate Completeness

Before producing the final spec file, run through this checklist. Every item must pass:

```
Completeness Checklist:
├── [ ] Overview clearly states what and why
├── [ ] User roles defined with specific permissions
├── [ ] Every AC follows chosen format (EARS or Gherkin)
├── [ ] At least 3 error handling criteria
├── [ ] At least 2 edge cases documented
├── [ ] Data model: all columns, types, constraints
├── [ ] API endpoints: method, path, request/response examples
├── [ ] UI components: behavior and state variations (or N/A with reason)
├── [ ] Accessibility section completed (or N/A with reason)
├── [ ] i18n section completed (or N/A with reason)
├── [ ] Dependencies listed
├── [ ] Out of Scope explicitly excludes likely assumptions
├── [ ] Spec is 50-150 lines (if longer, consider splitting)
└── [ ] Estimated Claude execution time: 1-4 hours (if longer, split)
```

Report any failures to the user. Fix before producing the file.

### Step 13: Produce Spec File

Write the spec to `docs/features/F0XX-[name].md`.

Read `references/spec-template.md` for the canonical template structure.

### Step 14: Update SPEC.md Index

Add an entry to `docs/SPEC.md`:

```markdown
| F0XX | [Feature Name] | [Status: Draft/Ready/In Progress/Done] | [Date] | [Brief description] |
```

If `docs/SPEC.md` doesn't exist, create it:

```markdown
# Feature Specifications

| ID | Feature | Status | Date | Description |
|----|---------|--------|------|-------------|
| F001 | [name] | [status] | [date] | [description] |
```

### Step 15: Update Discussion Log

Append to DISCUSSION-LOG.md (or PROJECT-LOG.md in lightweight mode):

```markdown
## [date] — Spec: F0XX-[name]

**Decisions:**
- [Key decisions made during spec writing]
- [AC format chosen: EARS/Gherkin, with rationale]

**Open questions:**
- [Anything unresolved that came up during spec writing]

**Next:** Ready for implementation via `wavecraft:implement F0XX`
```

## Adaptation

**Backend-only project (Scenario C):**
Mark UI Components, Accessibility (visual), and Interaction Patterns as N/A. Emphasize API Endpoints, Data Model, and Error Handling. API response format decisions replace UI component decisions.

**Process automation (Scenario D):**
Replace UI Components with Process Steps. Replace API Endpoints with Integration Points / Trigger Conditions. Add a "Monitoring & Alerting" section.

**Single feature addition (Scenario B):**
Same template, just smaller scope. Reference existing specs for consistency. Check existing data model and API patterns.

**No prior research or design:**
The skill can work without :research or :design output. It will ask more questions to fill the gaps. Note in the spec which sections are based on assumptions vs. documented decisions.

## Reference Files

| Reference | When to Read |
|-----------|-------------|
| `references/spec-template.md` | When producing the final spec file (Step 13) |
| `references/ears-guide.md` | When the user chooses EARS format and needs examples |
| `references/gherkin-guide.md` | When the user chooses Gherkin format and needs examples |
