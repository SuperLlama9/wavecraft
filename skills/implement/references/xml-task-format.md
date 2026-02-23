# XML Task Format Guide

Use this format when breaking a feature spec into implementation tasks (Step 6 of the :implement workflow).

## Format

```xml
<task id="[sequential number]" depends="[comma-separated task IDs, or empty]">
  <name>[Short descriptive name]</name>
  <files>[Files this task creates or modifies]</files>
  <action>[What to do — specific enough to implement without ambiguity]</action>
  <verify>[Automated command that proves the task is done — must complete in <60s]</verify>
  <done>[Human-readable definition of done]</done>
</task>
```

## Rules

1. **Every task has a `<verify>` step.** No exceptions. If you can't write one, the task is too vague.
2. **Verify completes in <60 seconds** (Nyquist Rule). If it takes longer, break the task down.
3. **One commit per task.** The task boundary IS the commit boundary.
4. **Dependencies are explicit.** `depends="1,2"` means tasks 1 and 2 must be complete first.
5. **Files are specific.** List actual file paths, not directories with wildcards.

## Ordering Strategy

```
Layer 1: Data (migrations, models, factories)
Layer 2: API (controllers, routes, request validation)
Layer 3: Business logic (services, events, policies, authorization)
Layer 4: Frontend (components, hooks, pages, state)
Layer 5: Integration (E2E tests, API documentation, browser validation)
```

Each layer depends on the previous — don't write frontend before the API exists.

## Example: Organization Management Feature

```xml
<task id="1" depends="">
  <name>Create organizations migration</name>
  <files>database/migrations/2026_02_22_create_organizations_table.php</files>
  <action>Create migration: id (uuid, PK), tenant_id (uuid, FK → tenants),
    name (varchar 255, NOT NULL), slug (varchar 255, NOT NULL),
    settings (jsonb, default {}), timestamps, soft_deletes.
    Add unique index on (tenant_id, slug).</action>
  <verify>php artisan migrate --pretend 2>&1 | grep -q "create_organizations"</verify>
  <done>Migration exists, dry-run shows CREATE TABLE statement</done>
</task>

<task id="2" depends="1">
  <name>Create Organization model + factory</name>
  <files>app/Models/Organization.php, database/factories/OrganizationFactory.php</files>
  <action>Create model with: fillable (name, slug, settings), casts (settings → array),
    relationships (belongsTo Tenant, hasMany Member). UUID trait.
    Factory: realistic org names, auto-generated slugs.</action>
  <verify>php artisan tinker --execute="Organization::factory()->make()->toArray()" 2>&1 | grep -q "name"</verify>
  <done>Model instantiates, factory produces valid data with all fields</done>
</task>

<task id="3" depends="2">
  <name>Write Organization CRUD tests</name>
  <files>tests/Feature/OrganizationTest.php</files>
  <action>Write tests for: create org (valid data → 201), create org (duplicate slug → 409),
    list orgs (returns only tenant's orgs), get org (valid → 200, not found → 404),
    update org (owner → 200, member → 403), delete org (owner → 200, member → 403).
    All tests should FAIL initially (TDD red phase).</action>
  <verify>php artisan test --filter=OrganizationTest 2>&1 | grep -q "FAIL"</verify>
  <done>6+ tests exist, all failing (no implementation yet)</done>
</task>

<task id="4" depends="3">
  <name>Implement Organization CRUD controller</name>
  <files>app/Http/Controllers/OrganizationController.php, routes/api.php</files>
  <action>Create controller with index, store, show, update, destroy.
    Register routes: GET/POST /api/organizations, GET/PUT/DELETE /api/organizations/{org}.
    Implement authorization via policy. Input validation via FormRequest.</action>
  <verify>php artisan test --filter=OrganizationTest 2>&1 | grep -q "OK"</verify>
  <done>All OrganizationTest tests pass (TDD green phase)</done>
</task>

<task id="5" depends="4">
  <name>Create OrganizationPolicy for authorization</name>
  <files>app/Policies/OrganizationPolicy.php</files>
  <action>Create policy: viewAny (any authenticated), view (tenant member),
    create (any authenticated), update (org owner only), delete (org owner only).
    Register in AuthServiceProvider.</action>
  <verify>php artisan test --filter=OrganizationTest 2>&1 | grep -q "OK"</verify>
  <done>Authorization tests pass, policy is registered</done>
</task>
```

## Verify Step Patterns

| Task Type | Verify Pattern |
|-----------|---------------|
| Migration | `migrate --pretend \| grep -q table_name` |
| Model | `tinker --execute="Model::factory()->make()"` |
| Tests (red phase) | `test --filter=TestClass \| grep -q "FAIL"` |
| Implementation (green) | `test --filter=TestClass \| grep -q "OK"` |
| API endpoint | `curl -s localhost/api/resource \| jq .status` |
| Frontend component | `npx vitest run ComponentName --reporter=verbose` |
| Config/env | `tinker --execute="config('key')"` |
