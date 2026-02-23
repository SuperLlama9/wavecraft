---
name: design
description: >
  Capture structural and interaction design decisions before writing specs. This skill should be
  used when the user says "design this feature", "user flows", "component decisions", "wireframe",
  "UX for", "interaction design", "what should this look like", "how should this work", or any
  variation of making design decisions for a feature. Also trigger when the user mentions "user
  journey", "navigation structure", "component library", or "accessibility requirements". This
  skill ensures UI/UX choices are explicit rather than left to Claude Code's imagination.
version: 0.1.0
---

# wavecraft:design — Design Decisions

Capture structural and interaction design decisions before writing specs. Maps user flows, defines information architecture, selects component patterns, and establishes accessibility and internationalization baselines. This prevents implementation surprises by making every design choice explicit.

## Why This Matters

Without explicit design decisions, specs become ambiguous about layout, interaction patterns, and visual hierarchy. Claude Code will make its own design decisions if the spec doesn't specify — and those decisions may not match what the product needs. This skill prevents that: every user flow is mapped, every component pattern is chosen, every edge state is documented.

## When to Trigger

- "design this feature", "user flows", "component decisions"
- "wireframe", "UX for", "interaction design"
- "what should this look like", "how should this work"
- After `:research` has produced findings, before `:spec`

## Workflow

### Step 1: Read Context Files (Mandatory)

```
Read (mandatory):
├── DISCUSSION-LOG.md          → Decisions made, project context
│   (or PROJECT-LOG.md         → Lightweight mode equivalent)
├── PROCESS.md                 → Current lifecycle phase
│   (or PROJECT-LOG.md)

Read (if they exist):
├── docs/research/RESEARCH-BRIEF*.md   → Research findings to inform design
├── docs/design/DESIGN-DECISIONS.md    → Existing design decisions (don't contradict)
└── docs/design/user-flows/*.md        → Existing user flows (for consistency)
```

**Bootstrap mode:** If DISCUSSION-LOG.md or PROCESS.md don't exist, create them with minimal content (same as other Cowork skills). Then proceed.

### Step 2: Identify Design Scope

Ask the user:
1. **What are we designing?** Get a clear description of the feature or product area.
2. **Which user journeys are involved?** Who uses this and what do they need to accomplish?
3. **Is there an existing design system?** Component library, colors, typography already decided?

### Step 3: Map User Flows

For each major user journey, document the step-by-step flow:

```
For each flow:
├── Entry point: How does the user get here?
├── Steps: Numbered sequence of user actions → system responses
├── Decision points: Where does the flow branch?
├── Completion: What does the user see when done?
├── Error states: What can go wrong and what does the user see?
└── Edge cases: Empty state, permission denied, concurrent edit
```

Walk through each flow with the user. Discuss alternatives at decision points. Get confirmation before documenting.

Write individual flows to `docs/design/user-flows/UF-0XX-[name].md` using this format:

```markdown
# UF-001: [Flow Name]

## Actor: [User role]
## Trigger: [What initiates this flow]
## Preconditions: [What must be true before this flow starts]

## Happy Path
1. User [action] → System [response]
2. User [action] → System [response]
3. ...
→ **End state:** [What the user sees when done]

## Alternative Paths
- If [condition]: [what happens instead]

## Error States
- If [error]: User sees [message/screen]. Recovery: [what they can do].

## Edge Cases
- [Empty state]: [what the user sees when there's no data]
- [Permission denied]: [what happens if user lacks access]
- [Concurrent edit]: [what happens if two users act simultaneously]
```

### Step 4: Information Architecture

Document the navigation and content structure:

```markdown
## Navigation
- Sidebar: [items and hierarchy]
- Top bar: [items]
- Breadcrumbs: [pattern]

## Page Hierarchy
- [Page 1]: [purpose, what content lives here]
  - [Sub-page]: [purpose]
- [Page 2]: [purpose]

## Content Grouping
- [What information appears together on each page/section]
```

### Step 5: Component Decisions

```markdown
## Component Library
- Library: [e.g., shadcn/ui, Radix, Headless UI, Material UI]
- Rationale: [why this library]

## Design System Basics
- Typography: [scale, font families]
- Colors: [palette, semantic colors]
- Spacing: [system, base unit]
- Responsive strategy: [mobile-first / desktop-first, breakpoints]

## Key Component Patterns
- Data tables: [pattern — sortable? filterable? paginated?]
- Forms: [pattern — inline validation? multi-step?]
- Modals: [pattern — when to use modal vs. new page?]
- Notifications: [pattern — toast? banner? inline?]
```

### Step 6: Interaction Patterns

```markdown
## Forms
- Validation: [inline as-you-type / on-blur / on-submit]
- Submission: [optimistic updates? loading state?]
- Error display: [inline per-field / summary at top / both]

## Loading States
- Lists: [skeleton screens / spinners / placeholder content]
- Pages: [full skeleton / progress bar / spinner]
- Actions: [button loading state / optimistic update]

## Empty States
- First use: [onboarding message / call to action]
- No results: [helpful message / suggestion to broaden search]
- No data: [explanation / create button]

## Confirmations
- Destructive actions: [confirmation dialog with type-to-confirm?]
- Multi-step workflows: [stepper / progress indicator?]
- Success feedback: [toast / redirect / inline message]

## Notifications
- Success: [toast / banner / inline]
- Error: [toast / banner / inline with retry]
- Warning: [banner / inline]
- Duration: [auto-dismiss after Xs / manual dismiss]
```

### Step 7: Accessibility Baseline

```markdown
## WCAG Target: [2.1 AA recommended]

## Keyboard Navigation
- All interactive elements reachable via Tab
- [Specific keyboard shortcuts if any]
- Focus visible on all interactive elements
- Focus trap in modals

## Screen Reader
- Landmark regions: [header, nav, main, footer]
- ARIA labels on: [icons, buttons without text, custom components]
- Live regions for: [dynamic content, notifications]

## Color & Contrast
- Text contrast: 4.5:1 minimum
- UI component contrast: 3:1 minimum
- [Any specific color considerations]
```

### Step 8: Internationalization Baseline

```markdown
## Supported Locales
- Default: [e.g., en-US]
- Planned: [e.g., de-DE, fr-FR]

## Formatting
- Dates: [locale-sensitive, ISO 8601 for APIs]
- Numbers: [locale-sensitive decimal/thousands separators]
- Currency: [e.g., EUR with locale formatting]

## Text
- All strings: [extracted to translation files]
- RTL support: [yes / no / planned]
- Text expansion: [accommodate 30% longer for de/fr]
```

### Step 9: Produce Design Decisions Document

Write the comprehensive document to `docs/design/DESIGN-DECISIONS.md`. This aggregates all decisions from steps 3-8 into a single reference.

### Step 10: Update Discussion Log

Append to DISCUSSION-LOG.md (or PROJECT-LOG.md):

```markdown
## [date] — Design: [Feature/Product Name]

**Decisions:**
- [Component library chosen: X, because Y]
- [User flows documented: UF-001, UF-002, ...]
- [Accessibility target: WCAG 2.1 AA]

**Open questions:**
- [Unresolved design decisions needing input]

**Next:** Ready for specification via `wavecraft:spec`
```

## Adaptation

**Backend-only (Scenario C):**
Replace user flows with API flow diagrams. Replace component decisions with API response format decisions. Mark accessibility (visual) and most interaction patterns as N/A. Focus on: API request/response flows, error response format, data flow between services.

**Process automation (Scenario D):**
Replace user flows with process flow maps. Focus on: integration points, trigger conditions, error handling flows, monitoring/alerting design. Component decisions become tool/platform decisions.

**Single feature (Scenario B):**
Only design the affected user flows, not the whole app. Reference existing DESIGN-DECISIONS.md for consistency. Only add/modify component decisions if the feature introduces new patterns.

**No prior research:**
The skill works without `:research` output. It will ask more exploratory questions during step 2 to fill the gap. Note in the design doc which decisions are based on assumptions.

## Reference Files

| Reference | When to Read |
|-----------|-------------|
| `references/user-flow-template.md` | When documenting individual user flows (Step 3) |
| `references/design-decisions-template.md` | When producing the comprehensive design doc (Step 9) |
