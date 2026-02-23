# TDD Workflow Guide

Test-Driven Development is mandatory in the Wavecraft framework. This isn't dogma — it's the most effective way to use AI for implementation. Tests written first prevent Claude from "cheating" by writing tests that verify broken behavior. The 2025 DORA Report confirms TDD is MORE effective with AI agents than traditional development.

## The Three Phases

```
RED    → Write a test that fails (defines expected behavior)
GREEN  → Write minimum code to make the test pass
BLUE   → Refactor while keeping tests green
```

### Red Phase: Write Failing Tests

For each acceptance criterion in the spec:

1. Write a test that asserts the expected behavior
2. Run the test → **it MUST fail**
3. If the test passes without implementation, the test is wrong (it's testing nothing useful)

```
What to test for each AC:
├── Happy path (the thing works correctly)
├── Error cases (invalid input, unauthorized, missing data)
├── Edge cases (empty state, boundary values, concurrent access)
├── Authorization (correct role succeeds, wrong role gets 403)
└── Validation (invalid input gets proper error messages)
```

### Green Phase: Implement Minimally

Write the minimum code to make the failing tests pass. No more, no less.

**Rules:**
- Do not add features the tests don't cover
- Do not optimize prematurely
- Do not refactor during green phase
- If a test fails unexpectedly, fix the implementation, not the test
- Follow project conventions from CLAUDE.md and .claude/rules/

### Blue Phase: Refactor Safely

With all tests green, clean up the code:

- Remove duplication
- Improve variable and function names
- Simplify complex conditionals
- Extract shared patterns into helpers/utilities
- Improve code organization

**Critical rule:** Run tests after EVERY refactoring change. If any test breaks:
1. **Immediately revert** the refactoring change
2. Tests must stay green — refactoring is optional, passing tests are not
3. Try a smaller refactoring step
4. If the refactoring can't be done without breaking tests, skip it and note it for later

## Test Naming Conventions

Follow the project's convention from `.claude/rules/testing.md`. If none exists, use descriptive names:

```
// PHP (PHPUnit)
test_user_can_create_organization_with_valid_data()
test_user_cannot_create_organization_with_duplicate_slug()
test_member_cannot_delete_organization()

// JavaScript/TypeScript (Vitest/Jest)
it('should create an organization with valid data')
it('should return 409 when slug is duplicated')
it('should deny delete for non-owners')

// Python (pytest)
def test_create_organization_with_valid_data():
def test_reject_duplicate_organization_slug():
def test_member_cannot_delete_organization():
```

## Coverage Targets

| Scope | Target |
|-------|--------|
| Changed files | ≥85% |
| New modules | ≥90% |
| Overall project | ≥80% |

Coverage is a floor, not a ceiling. If a critical path needs 100% coverage, write the tests.

## Accessibility in TDD (UI Features)

If the spec has an Accessibility section, write a11y tests during the Red phase alongside functional tests. These are behavior tests — they verify that the UI is usable, not just visible.

**What to test:**

```
Accessibility tests per AC:
├── Keyboard operability — interactive elements reachable via Tab, activatable via Enter/Space
├── ARIA attributes — roles, labels, and states on custom components
├── Focus management — focus moves correctly after modal open, form submit, route change
├── Error announcement — validation errors are linked to inputs (aria-describedby)
└── Semantic structure — headings, landmarks, lists used appropriately
```

**Example tests:**

```javascript
// React Testing Library + jest-dom
it('should be keyboard operable', () => {
  render(<OrganizationForm />);
  const submitBtn = screen.getByRole('button', { name: /create/i });
  submitBtn.focus();
  expect(submitBtn).toHaveFocus();
  fireEvent.keyDown(submitBtn, { key: 'Enter' });
  // assert form submits
});

it('should announce validation errors to screen readers', () => {
  render(<OrganizationForm />);
  fireEvent.click(screen.getByRole('button', { name: /create/i }));
  const errorMsg = screen.getByText(/name is required/i);
  expect(errorMsg).toHaveAttribute('id');
  const input = screen.getByRole('textbox', { name: /name/i });
  expect(input).toHaveAttribute('aria-describedby', errorMsg.id);
});

it('should trap focus inside modal when open', () => {
  render(<DeleteConfirmModal open={true} />);
  const modal = screen.getByRole('dialog');
  expect(modal).toBeInTheDocument();
  expect(document.activeElement).toBe(within(modal).getAllByRole('button')[0]);
});
```

**When to skip:** Backend-only tasks, API-only features, or when the spec's Accessibility section says "N/A."

## Common TDD Mistakes with AI

**Mistake: Writing tests after implementation.**
Fix: The skill enforces red-then-green. Tests must fail first.

**Mistake: Tests that test implementation details instead of behavior.**
Fix: Test observable outcomes (API responses, UI state) not internal methods.

**Mistake: Tests that are too tightly coupled to the implementation.**
Fix: If refactoring breaks tests without changing behavior, the tests are testing the wrong thing.

**Mistake: Skipping error case tests.**
Fix: The spec requires ≥3 error handling ACs. Each one needs a test.
