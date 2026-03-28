---
name: code-review
description: >
  Two-sided code review workflow — both requesting and receiving reviews.
  Use when: submitting code for review ("ready for review", "can you review",
  "PR is up"), receiving review feedback ("reviewer said", "got comments",
  "review feedback"), or when finishing an implementation and wanting a
  quality check before calling it done. Also trigger when the user asks
  "is this good code?", "what would you change?", "review this PR",
  or pastes a diff/code block asking for feedback.
---

# Code Review Skill

Two modes: **Requesting** (you wrote code, want feedback) and **Receiving** (you got feedback, need to respond). Both follow a structured process — reviews are only useful if they're honest, specific, and acted on.

---

## Mode A: Requesting a Review

Use when you've finished implementation and want it reviewed before merge.

### Stage 1: Self-Review First

Before asking anyone else, review your own diff with fresh eyes:

```
Self-review checklist:
[ ] Does the code do what was asked? (correctness)
[ ] Is the logic easy to follow? (readability)
[ ] Are there any obvious edge cases not handled?
[ ] Any debug prints, TODOs, or commented-out code left behind?
[ ] Does the diff include unintended changes (whitespace, unrelated files)?
[ ] Would a new engineer understand this in 6 months?
```

If you find issues during self-review — fix them before requesting external review. Never waste a reviewer's time on things you already know are wrong.

### Stage 2: Spec Compliance Review

Check the code against the original requirement:

> "Does this implementation match what was asked for — not just what I decided to build?"

Common drift patterns:
- Solved a harder problem than required
- Took a shortcut that misses an edge case in the spec
- Added scope that wasn't asked for (gold-plating)

### Stage 3: Code Quality Review

| Dimension | Questions to ask |
|-----------|-----------------|
| **Correctness** | Does it handle null, empty, error cases? |
| **Performance** | Any N+1 queries, unnecessary loops, missing indexes? |
| **Security** | User input validated? No injection vectors? Secrets hardcoded? |
| **Testability** | Can this be unit tested? Are dependencies injectable? |
| **Conventions** | Follows existing patterns in the codebase? |
| **Simplicity** | Could this be 20% shorter without losing clarity? |

### Stage 4: Write the PR Description

A good PR description makes reviews faster and merges safer:

```markdown
## What
[One sentence: what this PR does]

## Why
[The motivation — bug fix, feature request, tech debt]

## How
[Key technical decisions made and why]

## Testing
[How you verified this works]

## Screenshots / output (if relevant)
```

---

## Mode B: Receiving a Review

Use when you have review feedback and need to process and respond to it.

### Step 1: Categorize Each Comment

| Type | Response |
|------|----------|
| **Must fix** — correctness bug, security issue | Fix immediately, no debate |
| **Should fix** — code quality, missing test | Fix unless you have a good reason not to |
| **Consider** — style, alternative approach | Use judgment, explain if you disagree |
| **Nit** — minor style, naming | Fix if trivial, skip if not worth the noise |

### Step 2: For Each "Must Fix" or "Should Fix"

1. Understand *why* the reviewer flagged it — don't just apply the suggested change blindly
2. If you disagree, explain your reasoning — don't silently ignore
3. If the reviewer is right, apply the fix and move on

### Step 3: Respond to Every Comment

Never leave a review comment unacknowledged. Response options:
- **Fixed** — "Done, changed in [commit/line]"
- **Disagree** — "I kept it as-is because [reason]. Open to discussing."
- **Question** — "I'm not sure I understand — are you saying [interpretation]?"

<HARD-GATE>
Do NOT merge or mark the PR ready until:
- Every "must fix" comment has been addressed
- Every comment has a response (fixed / disagree with reason / question)
- You've re-run tests after all changes
</HARD-GATE>

### Step 4: Learn from the Review

After the PR is merged, if there were significant comments:
- Append to `tasks/lessons.md` any patterns the reviewer caught that you should watch for next time
- If the same type of issue came up multiple times, write a rule

---

## Core Principle

Code review is not a gatekeeping ritual — it's the cheapest way to catch bugs, spread knowledge, and raise the quality bar. Both requesting and receiving feedback well are skills that compound over time.
