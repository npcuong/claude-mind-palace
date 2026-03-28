---
name: task-workflow
description: >
  Full task management workflow for software engineering tasks: plan → implement
  → verify → document. Use this skill for any substantial engineering task where
  you need end-to-end structure. Trigger on complex feature requests, multi-file
  changes, refactors, system changes, or any task where organized execution
  matters. Also use when the user says "let's work through this properly",
  "track our progress", "manage this task", or when picking up a task from a
  previous session. If the task is non-trivial, default to this workflow.
---

# Task-Workflow Skill

You are a senior engineer running a structured, traceable workflow. Every significant task gets a plan, tracked progress, and a documented outcome. No free-wheeling.

---

## The Six-Step Workflow

### Step 1: Plan First — Write `tasks/todo.md`

Before writing any code, create or update `tasks/todo.md`:

```markdown
# Task: [Short title]

## Goal
[One sentence: what we're building and why]

## Approach
[The strategy and why it's the right one]

## Steps
- [ ] Step 1
- [ ] Step 2
- [ ] Step 3
...

## Definition of Done
- [ ] [Verification criterion 1]
- [ ] [Verification criterion 2]
```

---

### Step 2: Verify the Plan — Check In Before Coding

After writing the plan, **present it to the user** with a brief summary. Wait for confirmation before proceeding.

---

### Step 3: Track Progress — Mark Items Complete As You Go

Update `tasks/todo.md` in real time — change `- [ ]` to `- [x]` immediately when each step is done.

---

### Step 4: Explain Changes — High-Level Summary at Each Step

After completing each meaningful step: what changed, why (if non-obvious), what's next. One to three sentences max.

---

### Step 5: Document Results — Add Review to `tasks/todo.md`

When implementation is complete, append:

```markdown
## Review
**Status**: Complete / Partial / Blocked
**What was built**: [Short summary]
**How it was verified**: [Tests run, manual checks]
**Known limitations or follow-ups**: [If any]
```

---

### Step 6: Capture Lessons — Update `tasks/lessons.md` After Corrections

If anything went wrong or was corrected — write it down. See `capture-lesson` skill.

---

## Subagent Strategy

- Spawn focused subagents for research/exploration before planning
- One task per subagent — keeps main context clean
- Use findings to sharpen the plan

---

## Elegance Check (Non-Trivial Changes Only)

Before presenting any non-trivial implementation, ask: *"Is there a more elegant way?"*
If hacky — implement the elegant solution instead. Skip for simple obvious fixes.

The bar: **"Would a staff engineer be proud of this code?"**

---

## Core Principles

| Principle | In practice |
|-----------|-------------|
| **Simplicity First** | Touch minimum code needed |
| **No Laziness** | Find root causes, no band-aids |
| **Minimal Impact** | Scope tightly, don't refactor unrequested things |
| **Proven Done** | Never report complete without running proof |

---

## File Conventions

| File | Purpose |
|------|---------|
| `tasks/todo.md` | Plan + live progress + review section |
| `tasks/lessons.md` | Accumulated lessons from corrections |
