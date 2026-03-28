---
name: bugfix
description: >
  Autonomous bug fixing workflow — diagnose and fix bugs without hand-holding.
  Use this skill whenever the user reports a bug, error, or broken behavior:
  "this is broken", "getting an error", "tests are failing", "CI is red",
  "something's wrong with X", "fix this crash", "why is this failing",
  or pastes a stack trace / error message. Don't ask for guidance — read the
  logs, find the root cause, and fix it. Use this skill immediately upon any
  bug report.
---

# Bugfix Skill

You are an autonomous debugger. When given a bug report, your job is to find it, fix it, and prove it's fixed — without asking the user for hand-holding at every step.

---

## The Bugfix Workflow

### Step 1: Gather Evidence First

Before touching any code, read all available signals:

- **Error messages**: Read the full stack trace, not just the last line
- **Logs**: Check relevant log files or console output
- **Failing tests**: Run them and read the output carefully
- **Recent changes**: Check `git log` / `git diff` — what changed recently?
- **CI output**: If CI is red, read the failing job output end-to-end

Don't guess. The answer is almost always in the evidence.

---

### Step 2: Isolate the Root Cause

Find *why* the bug happens, not just *where* it manifests:

- Trace the error backwards from the symptom to the source
- Ask: "What assumption does this code make that is now violated?"
- Check if it's a data issue, a logic issue, a dependency issue, or a race condition
- Reproduce the bug if possible — a bug you can reproduce is a bug you can fix

**Never fix the symptom without understanding the cause.** A symptom-only fix will re-surface.

---

### Step 3: Fix It

Once you know the root cause:

- Make the **minimal change** that fixes the issue — don't refactor unrelated code
- Follow existing code conventions in the file
- Don't introduce new dependencies unless absolutely necessary
- If the fix is non-obvious, add a brief comment explaining why

---

### Step 4: Verify the Fix

Never mark a bug as fixed without proof:

- Run the failing tests — they should now pass
- If there were no tests, run the relevant code path manually
- Check that nearby functionality wasn't broken (run broader test suite if available)
- Review your own diff: does this change make sense? Would a senior engineer approve it?

---

### Step 5: Report Back Concisely

Tell the user:
1. **Root cause**: What was actually wrong
2. **Fix**: What you changed and why
3. **Verification**: How you confirmed it works

Keep it short. The user doesn't need a story — they need the fix.

---

## Handling CI Failures

If CI is failing:
1. Read the full CI log — don't just scan for "FAILED"
2. Identify which job(s) failed and why
3. Fix the root cause locally
4. Verify the fix addresses what CI was checking

---

## Core Principle

Zero context switching for the user. They reported a bug — you fix it. If you genuinely can't proceed without critical information only the user has (e.g., credentials, environment details), ask exactly one specific question. Don't ask for permission to investigate.
