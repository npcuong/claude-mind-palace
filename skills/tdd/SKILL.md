---
name: tdd
description: >
  Test-driven development workflow — RED → GREEN → REFACTOR. Use this skill
  when writing new features, fixing bugs with a reproducible case, or when the
  user says "write tests first", "TDD this", "test-driven", "add tests before
  implementing", or "I want good test coverage". Also trigger when a bug was
  caused by missing tests — the fix should include a regression test written
  before the code change. If code is written before tests, this skill will
  flag it and correct the order.
---

# TDD Skill

Test-driven development is not about having tests — it's about using tests to *drive* the design. Writing tests first forces you to think about the interface before the implementation, which consistently produces cleaner code.

---

## The RED → GREEN → REFACTOR Cycle

```
RED    → Write a test that fails (for the right reason)
GREEN  → Write the minimum code to make it pass
REFACTOR → Clean up, knowing the test will catch regressions
```

Never skip phases. Never write code before a failing test exists.

---

## Phase 1: RED — Write the Failing Test

Before any implementation code:

1. **Write the test** that describes the expected behavior
2. **Run it** — confirm it fails with the right error
3. **Read the failure message** — does it fail because the code doesn't exist yet? (correct) Or because the test itself is wrong? (fix the test first)

**A test in RED for the right reason looks like:**
```
Expected: "user@example.com"
Received: TypeError: Cannot read property 'email' of undefined
```
This means the function doesn't exist yet — correct.

**A test in RED for the wrong reason looks like:**
```
Expected: "user@example"
Received: "user@example.com"
```
This means the test has a typo in the expected value — fix the test, not the code.

<HARD-GATE>
Do NOT write implementation code until there is a failing test.
If code already exists without a test: write the test first, confirm it tests the right behavior, then proceed.
</HARD-GATE>

---

## Phase 2: GREEN — Minimum Code to Pass

Write **only enough code** to make the test pass:

- No extra features
- No handling of cases the test doesn't cover yet
- No "I'll add this now since I'm here" additions

This feels uncomfortable. That discomfort is intentional — it keeps scope tight and reveals what actually needs to be built vs. what you assumed would be needed.

**Common mistakes in GREEN phase:**
- Writing the full implementation when only a stub is needed
- Adding error handling not covered by any test yet
- Refactoring while making the test pass (refactoring belongs in the next phase)

---

## Phase 3: REFACTOR — Clean Up Under Green

With a passing test as a safety net, now improve the code:

- Extract duplicated logic
- Rename for clarity
- Simplify over-engineered solutions
- Improve test readability

**Rules for refactor phase:**
- Tests must stay green throughout
- Do NOT add new behavior — that requires a new RED test first
- Do NOT skip this phase — RED → GREEN without REFACTOR produces working but messy code

---

## Anti-Patterns to Avoid

These patterns make tests useless. Avoid them:

| Anti-pattern | Problem |
|-------------|---------|
| **Testing implementation details** | Tests break on refactoring even when behavior is correct |
| **Mocking everything** | Tests pass but real integration is broken |
| **Testing only the happy path** | Edge cases and error states are uncovered |
| **One giant test** | Hard to diagnose which behavior broke |
| **Tests that always pass** | No assertion, or assertion on wrong value |
| **Copy-paste tests** | Different names, same logic — doesn't add coverage |
| **Skipped tests** | `it.skip` / `xit` — graveyard of never-fixed issues |

---

## When to Write Tests (Decision Guide)

| Scenario | Approach |
|----------|----------|
| New feature | TDD: test first |
| Bug fix | Write failing test that reproduces bug, then fix |
| Refactoring | Ensure tests exist before touching code |
| Exploratory spike | Write tests after to lock in behavior |
| Trivial getter/setter | Use judgment — may not need a test |

---

## Test Quality Bar

A good test suite has:
- [ ] Tests for the happy path
- [ ] Tests for edge cases (empty, null, boundary values)
- [ ] Tests for error/failure paths
- [ ] Each test has exactly one reason to fail
- [ ] Test names describe behavior, not implementation (`"returns empty array when no users found"` not `"test getUserList"`)

---

## Core Principle

Tests written after code verify that the code works. Tests written before code define what "works" means. The latter produces better-designed software because the interface is designed from the perspective of its user (the test), not its implementer.
