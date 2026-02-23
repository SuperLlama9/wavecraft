# SESSION-LOG.md Template

Use this template when creating SESSION-LOG.md for a new project. This file is overwritten at the end of each session — it represents the CURRENT state, not history (history goes in DEV-LOG.md).

```markdown
# Session Log

## Active Task
[What we're currently working on. Feature spec reference if applicable.]

## Status
[One line: where we are right now.]

## Completed This Session
- [Task 1 completed]
- [Task 2 completed]

## In Progress
- [Task currently being worked on — what's done, what's left]

## Key Decisions Made
- [Decision 1]: [rationale]
- [Decision 2]: [rationale]

## Blocked / Unresolved
- [Blocker 1]: [what's needed to unblock]
- [Question 1]: [needs human input]

## Files Modified This Session
- `path/to/file1.ext` — [what changed]
- `path/to/file2.ext` — [what changed]

## Next Steps (for next session)
1. [First thing to do next session]
2. [Second thing]
3. [Third thing]

## Context Health
- Session length: [X tool calls]
- Estimated context usage: [low/medium/high]
- Quality assessment: [good/degrading/should-compact]
- Recommendation: [continue/compact/new-session]
```

## Rules for Updating

1. Update AFTER each completed task, not just at end of session
2. "Next Steps" must be specific enough that a fresh session can start immediately
3. "Files Modified" must include full paths — a fresh session needs to know exactly what changed
4. "Context Health" is estimated, not measured (Claude can't read token count)
5. When overwriting, preserve the structure — all sections must be present
