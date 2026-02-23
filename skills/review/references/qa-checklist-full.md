# Full QA Checklist

Complete checklist for AI-generated code review. Use this as the authoritative reference — the SKILL.md contains abbreviated versions of each section.

## Code Quality
- [ ] Follows project conventions (check CLAUDE.md and .claude/rules/)
- [ ] No hardcoded values (use config/env)
- [ ] Error handling is comprehensive (no silent failures)
- [ ] Input validation on all endpoints (server-side, never trust client)
- [ ] No N+1 query issues (use eager loading)
- [ ] Proper use of database transactions (multi-step writes wrapped in transactions)
- [ ] No over-engineering (AI agents tend to add unnecessary abstractions)
- [ ] Code survival check: will this code last >2 weeks without needing rewrite?
- [ ] Consistent naming conventions across the feature
- [ ] No TODO/FIXME comments left without corresponding tracked issues

## Security
- [ ] Auth required on all private endpoints
- [ ] Authorization checks (policies/gates) on all state-changing operations
- [ ] SQL injection prevention (parameterized queries only, no raw SQL with user input)
- [ ] XSS prevention (output encoding on all user-generated content)
- [ ] CSRF protection on state-changing operations
- [ ] No secrets in code, logs, or error messages
- [ ] No MCP prompt injection vulnerabilities
- [ ] Rate limiting on public or sensitive endpoints
- [ ] File upload validation (if applicable): type, size, content scanning
- [ ] CORS configured correctly (not wildcard in production)
- [ ] Sensitive data not logged or exposed in API responses

## Testing
- [ ] Tests cover happy path for all major operations
- [ ] Tests cover error cases (≥3 per endpoint)
- [ ] Tests cover edge cases (empty states, boundaries, concurrent access)
- [ ] Coverage ≥85% for changed files
- [ ] Coverage ≥90% for new modules
- [ ] No flaky tests (run suite 3 times if suspicious)
- [ ] Tests are independent (no order-dependent tests)
- [ ] Test names clearly describe what they test
- [ ] Factory/fixture data is realistic, not just "test123"

## Accessibility (skip if backend-only)
- [ ] Keyboard navigation works for all interactive elements
- [ ] Tab order follows visual layout
- [ ] ARIA labels on icons, buttons without visible text
- [ ] ARIA roles on custom components (dialogs, tabs, menus)
- [ ] Focus management after modal open/close, page navigation
- [ ] Focus trap inside modals (can't tab out of open modal)
- [ ] Color contrast meets WCAG 2.1 AA (4.5:1 for text, 3:1 for UI components)
- [ ] Screen reader tested on key workflows
- [ ] Error messages linked to form fields (aria-describedby)
- [ ] Skip navigation link present (if new page)
- [ ] Alt text on meaningful images
- [ ] Decorative images marked with empty alt or aria-hidden

## Internationalization (skip if not applicable)
- [ ] All user-facing strings extracted to translation files
- [ ] Dates, numbers, currency formatted per locale
- [ ] No hardcoded locale-specific content
- [ ] RTL layout tested (if applicable)
- [ ] Pluralization handled correctly
- [ ] Text expansion accommodated (German/French text is ~30% longer than English)

## Performance
- [ ] Database indexes on queried/filtered/sorted columns
- [ ] Pagination on list endpoints (no unbounded queries)
- [ ] Eager loading for relationships (verified with query log)
- [ ] Cache strategy for read-heavy data (if applicable)
- [ ] API response time within budget (<200ms reads, <500ms writes)
- [ ] Bundle size within budget (<250KB initial JS, if frontend)
- [ ] No unnecessary re-renders in React/Vue components
- [ ] Images optimized and lazy-loaded (if applicable)
- [ ] No synchronous blocking operations in request handlers

## Dependency Management
- [ ] No known vulnerabilities (npm audit / composer audit / pip-audit)
- [ ] Dependencies pinned to specific versions (lockfile committed)
- [ ] No unused dependencies
- [ ] License compatibility verified for new dependencies
- [ ] No duplicate packages at different versions

## Browser Validation (mandatory for UI features)
- [ ] Application is running and accessible
- [ ] Primary user role identified from spec
- [ ] Happy path clicked through end-to-end as primary role
- [ ] Secondary role walkthrough completed (verify permissions and restricted states)
- [ ] Screenshots captured and visually verified
- [ ] At least one error path tested in actual UI
- [ ] Loading states verified (skeleton/spinner appears, then resolves)
- [ ] Empty states verified (what shows when there's no data)
- [ ] UX assessment: labels clear? Navigation intuitive? Feedback after actions?
- [ ] Permission error messages helpful (not just "403 Forbidden")
- [ ] Responsive behavior checked (if applicable)
- [ ] For backend-only: ALL endpoints called with real HTTP requests

## AI-Specific Quality
- [ ] Spec alignment: implementation matches acceptance criteria
- [ ] No gold-plating: nothing built that's out-of-scope per the spec
- [ ] Session log updated with decisions made during implementation
- [ ] API documentation (openapi.yaml) updated if endpoints changed
- [ ] DEV-LOG.md has session summary
