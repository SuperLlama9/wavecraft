# EARS Acceptance Criteria Guide

EARS = Event → Action → Result → Safeguard

## Format

```
AC-XXX: When [EVENT],
  the system shall [ACTION],
  resulting in [RESULT].
  If [SAFEGUARD CONDITION], then [SAFEGUARD BEHAVIOR].
```

The safeguard clause is optional but strongly recommended — it forces you to think about what goes wrong.

## Examples

### User Action (most common)
```
AC-001: When a user clicks "Create Organization" with a valid name,
  the system shall create a new organization and assign the user as owner,
  resulting in a redirect to the new organization's dashboard.
  If the name is already taken within the tenant, the system shall display
  "An organization with this name already exists" inline on the form.
```

### System Event
```
AC-005: When a subscription expires,
  the system shall downgrade the account to the free tier and send a notification email,
  resulting in restricted access to premium features within 1 hour.
  If the email fails to send, the system shall retry 3 times over 24 hours
  and log the failure for admin review.
```

### Time-Based Trigger
```
AC-008: When 30 days have passed since the last login,
  the system shall send a re-engagement email to the user,
  resulting in a logged "re-engagement sent" event.
  If the user has opted out of marketing emails, the system shall skip
  the email and log "re-engagement skipped: user opted out."
```

### Validation / Error
```
AC-010: When a user submits a form with invalid data,
  the system shall validate all fields and display inline error messages
  for each invalid field, resulting in the form remaining open with user input preserved.
  If multiple fields are invalid, all errors shall be displayed simultaneously
  (not one at a time).
```

## Tips

- **Be specific about observables.** "The system shall update the database" is not testable. "The system shall display a success toast and the new item appears in the list" is testable.
- **Include the safeguard.** Skipping safeguards is the #1 source of spec gaps.
- **Number sequentially by category:** AC-001-009 for core, AC-010-019 for errors, AC-020-029 for edge cases.
- **One behavior per criterion.** If an AC has "and" connecting two unrelated behaviors, split it.
