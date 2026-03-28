---
name: verify-done
description: >
  Verification checklist before marking any task complete. Use this skill before
  saying "done", "finished", "completed", or closing out any implementation task.
  Trigger whenever you're about to mark a task complete, finish a feature, wrap
  up a bug fix, or tell the user the work is ready. Also use when the user asks
  "is this done?", "can we ship this?", "does this work?", or "is it ready?".
  Never skip verification — if it's not proven to work, it's not done.
---

# Verify-Done Skill

You are a staff engineer running a final check before signing off on any work. "It looks right" is not done. "It works and I can prove it" is done.

---

## The Verification Checklist

Run through each category before declaring completion:

### 1. Functional Correctness

- [ ] Does the code actually do what was asked?
- [ ] Have you tested the **happy path** (expected inputs)?
- [ ] Have you tested **edge cases** (empty inputs, nulls, boundaries)?
- [ ] Have you tested **error cases** (what happens when things fail)?

If there are existing tests — run them. If there aren't — write a quick manual test or add one.

---

### 2. No Regressions

- [ ] Does the existing test suite still pass?
- [ ] Did you check that nearby functionality still works?
- [ ] Review your diff: does anything look suspicious or unintended?

A change that fixes one thing and breaks another is not a fix.

---

### 3. Staff Engineer Standard

Ask yourself honestly: **"Would a staff engineer approve this PR?"**

- Is the code readable and appropriately simple?
- Are there any hacks, workarounds, or TODO comments that need addressing first?
- Is the change minimal — does it touch only what's necessary?
- Is there any duplication that shouldn't be there?

If the answer is "a staff engineer would wince at this" — fix it before calling it done.

---

### 4. Diff Review

Read your own changes one more time with fresh eyes:

- Does the diff tell a coherent story?
- Are there any accidental changes (debug prints, commented-out code, whitespace noise)?
- Is the intent clear from reading the code, or does it need a comment?

---

### 5. Definition of Done (from the plan)

If a plan was written in `tasks/todo.md`, check off each item in the **Definition of Done** section. Don't skip this — the plan was written for a reason.

---

## How to Report Completion

When everything checks out, report:

1. **What was done** — one sentence
2. **How it was verified** — what you ran / tested
3. **Any caveats** — known limitations or follow-ups (if any)

---

## If Verification Fails

If you find an issue during verification:
- Fix it before reporting done
- Don't report partial completion as full completion
- If the issue is out of scope, note it explicitly as a separate follow-up

---

## Core Principle

Verification is not overhead — it's what separates shipped code from broken code that shipped. The cost of a 5-minute check is nothing compared to the cost of a production incident.
