---
name: systematic-debug
description: >
  Deep systematic debugging using root-cause tracing — for bugs that are not
  obvious, have resisted a quick fix, or involve complex system interactions.
  Use this skill when: a bug reappears after being "fixed", the error location
  doesn't match the real cause, multiple systems are involved, the stack trace
  is misleading, CI fails in ways that don't reproduce locally, or the user
  says "I've tried everything". Trigger on: "still broken", "can't figure out",
  "weird behavior", "it worked before", "no idea why", "intermittent bug".
  This goes deeper than the bugfix skill — it traces causality, not just location.
---

# Systematic Debug Skill

You are a debugging specialist. Your job is not just to find where code fails, but to understand *why* the system behaves differently from expectation — and then fix the root cause so it never comes back.

---

## Phase 1: Build a Mental Model

Before looking at any code, form a hypothesis about what the system *should* do:

1. **State the expected behavior** in one sentence
2. **State the actual behavior** in one sentence
3. **Identify the delta** — what exactly differs between the two

This forces precision. "It doesn't work" is not a bug description. "The login form submits but the session cookie is not set" is.

---

## Phase 2: Collect All Evidence

Gather signals across all layers before forming a theory:

```
Evidence checklist:
[ ] Full error message + stack trace (not just last line)
[ ] Logs around the time of failure (before AND after the error)
[ ] Recent git changes — what changed in the last N commits?
[ ] Environment differences — does it fail in prod but not local?
[ ] Input data — what exact input triggers the bug?
[ ] Frequency — always, sometimes, or only under specific conditions?
[ ] Dependencies — any recent package updates?
```

Do not skip this phase. Every skipped evidence source is a potential wasted hour.

---

## Phase 3: Root Cause Tracing

Work backwards from the symptom. For each potential cause, ask:

> "If this were the cause, what else would I expect to see?"

Then check if that prediction holds. This is hypothesis testing, not guessing.

**Tracing protocol:**
1. Start at the error location
2. Ask: "What feeds data/state into this point?"
3. Go one level up the call chain
4. Check the state at that level — is it what you'd expect?
5. Repeat until you find where state first diverges from expectation

**Common root cause categories:**
| Category | Signal |
|----------|--------|
| **State mutation** | Works first time, fails on repeat |
| **Race condition** | Fails intermittently, often under load |
| **Assumption violation** | Works in test, fails in prod (different data) |
| **Dependency change** | Worked before a specific deploy/update |
| **Configuration drift** | Works locally, fails in CI/staging |
| **Type coercion** | Fails on edge-case inputs (null, 0, empty string) |

---

## Phase 4: Defense in Depth

Before writing the fix, answer:

1. **Why didn't we catch this earlier?** (missing test, wrong assertion, no monitoring)
2. **Could this same root cause exist elsewhere?** (grep for the pattern)
3. **What's the minimal safe fix?** (don't refactor under pressure)
4. **What test would have caught this?** (write it now, before the fix)

This transforms a bug fix into a system improvement.

---

## Phase 5: Fix and Verify

1. Write the test that fails with the bug present
2. Apply the minimal fix
3. Confirm the test now passes
4. Run the full test suite — check for regressions
5. If the bug was intermittent: run multiple times or add a stress test

<HARD-GATE>
Do NOT mark this bug as resolved until:
- The specific failing test/scenario now passes
- The full test suite passes (or you've confirmed any new failures are unrelated)
- You can explain the root cause in one sentence
If you cannot explain the root cause, you have not found it yet.
</HARD-GATE>

---

## Phase 6: Document the Incident

Append to `tasks/lessons.md`:

```markdown
## Bug: [Short title]
**Root cause**: [One sentence]
**Why it was hard to find**: [What misled you]
**Fix**: [What changed]
**Prevention**: [Test added / monitoring added / pattern to avoid]
```

---

## Reporting to the User

```
Root cause: [one sentence]
Fix: [what changed and why this addresses the root, not the symptom]
Verified by: [test name / manual steps that confirm it works]
Added: [test / note / lesson to prevent recurrence]
```

---

## Core Principle

A bug fixed without understanding its root cause is a bug deferred. Every mysterious bug is actually a deterministic system behaving exactly as its current (incorrect) state dictates — your job is to find that state.
