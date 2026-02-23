# User Flow Template

Write individual user flows to `docs/design/user-flows/UF-0XX-[name].md`.

```markdown
# UF-0XX: [Flow Name]

## Actor: [User role — e.g., "Consultant", "Admin", "Viewer"]
## Trigger: [What initiates this flow — e.g., "User clicks 'Create Organization' button"]
## Preconditions: [What must be true — e.g., "User is authenticated and has 'owner' role"]

## Happy Path
1. User [action] → System [response]
2. User [action] → System [response]
3. User [action] → System [response]
→ **End state:** [What the user sees when the flow completes successfully]

## Alternative Paths
- If [condition]: [what happens instead — e.g., "If user has no organizations, show onboarding wizard instead of dashboard"]
- If [condition]: [what happens instead]

## Error States
- If [error condition]: User sees [error message or screen]. Recovery: [what the user can do to fix it].
- If [error condition]: User sees [error message or screen]. Recovery: [recovery action].

## Edge Cases
- [Empty state]: [What the user sees when there's no data yet]
- [Permission denied]: [What happens if the user lacks access — distinguish "hidden" vs "visible but disabled" vs "error message"]
- [Concurrent edit]: [What happens if two users act on the same resource simultaneously]
- [Network failure]: [What happens if the connection drops mid-flow]
```

## Tips

- **One flow per file.** Complex features may have 3-5 flows.
- **Be specific about system responses.** "Shows a success message" → "Shows a green toast: 'Organization created successfully' that auto-dismisses after 3 seconds"
- **Error recovery is critical.** Every error state must tell the user what they can do next.
- **Name flows after the user goal, not the UI element.** "UF-001: Create Organization" not "UF-001: Organization Form"
