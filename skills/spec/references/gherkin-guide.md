# Gherkin Acceptance Criteria Guide

Gherkin = Given → When → Then (→ And / But)

## Format

```
AC-XXX: [Scenario Name]
  Given [precondition / initial state]
  When [action / event]
  Then [expected outcome]
  And [additional outcome]
  But [exception / negative case]
  Then [exception handling]
```

## Examples

### User Action (most common)
```
AC-001: Creating an organization with valid data
  Given an authenticated user on the "Create Organization" page
  When they enter a valid organization name and click "Create"
  Then a new organization is created with the user as owner
  And the user is redirected to the new organization's dashboard
  And a "Organization created" success toast is displayed
  But if the name is already taken within the tenant
  Then "An organization with this name already exists" is displayed inline
  And the form remains open with the user's input preserved
```

### System Event
```
AC-005: Subscription expiration handling
  Given a user whose subscription has expired
  When the system processes the expiration
  Then the account is downgraded to the free tier
  And a notification email is sent to the account owner
  And premium features become restricted within 1 hour
  But if the email fails to send
  Then the system retries 3 times over 24 hours
  And the failure is logged for admin review
```

### Scenario Outline (parameterized)
```
AC-010: Form validation for required fields
  Given a user on the registration form
  When they submit with <field> empty
  Then "<field> is required" is displayed below the field
  And the form is not submitted

  Examples:
  | field    |
  | email    |
  | password |
  | name     |
```

### Permission-Based
```
AC-015: Member cannot delete organization
  Given an authenticated user with the "member" role
  When they attempt to access the "Delete Organization" action
  Then the action is not available in the UI
  But if they call the API directly (DELETE /api/organizations/:id)
  Then a 403 Forbidden response is returned
  And the organization is not deleted
```

## Tips

- **Given = preconditions only.** Don't put actions in Given.
- **When = a single action.** If you have multiple Whens, split into separate scenarios.
- **Then = observable outcomes.** Must be verifiable by a test.
- **But = exceptions/negative cases.** Use for error handling within the same scenario.
- **Scenario Outline** saves repetition when the same flow applies to multiple inputs.
- **One scenario per AC.** Complex flows get multiple ACs, not one giant Gherkin block.
- **Number sequentially by category:** AC-001-009 for core, AC-010-019 for errors, AC-020-029 for edge cases.
