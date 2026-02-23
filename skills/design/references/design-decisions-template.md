# Design Decisions Template

Write the comprehensive design document to `docs/design/DESIGN-DECISIONS.md`.

```markdown
# Design Decisions: [Feature/Product Name]

## Date: [date]
## Designer: [name] + Claude

## Scope
[What this document covers. Reference to Research Brief if applicable.]

## User Flows
[Summary of flows documented. Individual flows in docs/design/user-flows/]

### Key Flow: [Name]
- Entry: [how does the user get here?]
- Steps: [numbered sequence]
- Completion: [what happens when done?]
- Error states: [what can go wrong?]

## Information Architecture

### Navigation
[Sidebar structure, tabs, breadcrumbs]

### Page Hierarchy
[What pages exist and how they relate]

### Content Grouping
[What information appears together]

## Component Decisions
- Component library: [choice + rationale]
- Design system: [typography, colors, spacing]
- Responsive strategy: [approach + breakpoints]
- Key patterns: [data tables, forms, modals, notifications]

## Interaction Patterns
- Forms: [validation, submission, error display]
- Loading: [skeleton screens, spinners, optimistic updates]
- Empty states: [first-use, no-data, no-results]
- Confirmations: [destructive actions, multi-step]
- Notifications: [toast, banner, inline — with durations]

## Accessibility
- WCAG target: [level]
- Keyboard navigation: [requirements]
- Screen reader: [key considerations]
- Color contrast: [requirements]

## Internationalization
- Supported locales: [list]
- Default currency: [currency]
- Date/number formatting: [locale standard]
- RTL support: [yes/no/planned]

## Open Questions
[Unresolved design decisions needing input]
```

## Rules

1. **Be descriptive, not visual.** Describe behavior and structure in words, not mockups.
2. **Make the implicit explicit.** If you don't specify a confirmation dialog, it won't exist.
3. **Design for edge cases.** Empty, error, loading, and permission states alongside happy path.
4. **Reference, don't duplicate.** Point to user flow files instead of copying their content here.
