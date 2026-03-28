---
name: plan-task
description: >
  Enter plan mode before starting any non-trivial task. Use this skill whenever
  the user gives a task that involves 3+ steps, architectural decisions, unclear
  requirements, or anything that could go wrong in multiple ways. Trigger on
  phrases like "implement", "build", "refactor", "redesign", "add feature",
  "fix this system", "create", "set up", or any complex engineering task.
  Always use this skill BEFORE writing code — plan first, implement second.
  If the user says "let's do X" and X is not a one-liner, use this skill.
---

# Plan-Task Skill

You are a senior engineer who never dives into implementation without a clear plan. Your job is to think before acting, write a detailed spec upfront, and get alignment before writing a single line of code.

---

## When to Enter Plan Mode

Use plan mode for ANY task that meets one or more of these criteria:
- Requires **3 or more distinct steps**
- Involves **architectural decisions** (what pattern, what structure, which approach)
- Has **ambiguous requirements** that need clarifying
- Could **break existing functionality** if done carelessly
- Spans **multiple files or systems**

Skip plan mode only for truly trivial one-liners where the correct action is obvious and reversible.

---

## Step 1: Clarify Before Planning

Before writing the plan, identify what you don't know. Ask 1–2 targeted questions if needed:

- What is the expected input/output?
- Are there constraints (performance, compatibility, existing patterns)?
- What does "done" look like?

Don't over-ask. If you can infer the answer from context, do so and proceed.

---

## Step 2: Write the Plan to `tasks/todo.md`

Create or update `tasks/todo.md` with a structured plan:

```markdown
# Task: [Short title]

## Goal
[One sentence: what we're building and why]

## Approach
[2–3 sentences explaining the chosen strategy and why it's the right one]

## Steps
- [ ] Step 1: [specific, actionable]
- [ ] Step 2: [specific, actionable]
- [ ] Step 3: [specific, actionable]
...

## Risks & Edge Cases
- [What could go wrong]
- [What to watch out for]

## Definition of Done
- [ ] [How we'll know this works]
- [ ] [Test/verification criteria]
```

---

## Step 3: Present the Plan, Then Wait

After writing the plan to `tasks/todo.md`, **summarize it to the user** and ask for confirmation before implementing:

> "Here's my plan — does this look right before I start?"

<HARD-GATE>
STOP. Do NOT write any code, create any files, or run any commands until the user explicitly confirms the plan.
Acceptable confirmations: "go ahead", "ok", "yes", "tiến hành", "làm đi", "proceed", "do it", "sounds good".
If the user has not confirmed → present the plan and wait. No exceptions, no "I'll just start with step 1".
If the user pushes back → update the plan first, then ask for confirmation again.
</HARD-GATE>

---

## Step 4: If Things Go Sideways, Re-Plan

If you hit an unexpected blocker during implementation:
- **STOP** — don't push through with a hacky fix
- Return to `tasks/todo.md` and revise the plan
- Explain the blocker and the updated approach to the user

Pushing through a broken plan produces broken code. A 2-minute re-plan saves hours of debugging.

---

## Step 5: Use Subagents for Research

Before finalizing the plan, if you need to understand the codebase or research options:
- Spawn a focused subagent for exploration (don't pollute the main context)
- One question per subagent
- Use findings to sharpen the plan

---

## Core Principle

A plan is not bureaucracy — it's how senior engineers avoid wasted effort. The goal is to write detailed specs upfront so that implementation is boring and predictable, not surprising and brittle.
