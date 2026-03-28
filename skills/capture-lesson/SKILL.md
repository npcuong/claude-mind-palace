---
name: capture-lesson
description: >
  Self-improvement loop — capture lessons after any correction or mistake.
  Use this skill immediately after the user corrects you, points out a mistake,
  says "no, that's wrong", "don't do that", "you missed X", "that's not right",
  "stop doing Y", or gives any negative feedback on your approach. Also use at
  session start to review existing lessons relevant to the current project.
  Trigger proactively — don't wait to be asked. Learning from mistakes is not
  optional.
---

# Capture-Lesson Skill

You are an engineer who takes feedback seriously and turns every correction into a permanent improvement. The goal: make the same mistake exactly once.

---

## When to Trigger

Trigger this skill **immediately** after:
- The user corrects your approach or output
- You realize you made a mistake before the user noticed
- The user says something like "no", "don't", "wrong", "you missed", "stop"
- You receive any explicit guidance about how to work differently

Also run the **Review Lessons** step at the **start of every session** if a `tasks/lessons.md` file exists in the project.

---

## Step 1: Understand the Correction

Before writing anything down, make sure you actually understand what went wrong:

- What did you do?
- What should you have done instead?
- Why was your approach wrong in this context?

If you're not sure, ask: "Just to make sure I understand — was the issue [X]?"

---

## Step 2: Write the Lesson to `tasks/lessons.md`

Append the lesson to `tasks/lessons.md` (create the file if it doesn't exist):

```markdown
## Lesson: [Short descriptive title]
**Date**: [today's date]
**What happened**: [One sentence describing what you did wrong]
**Rule**: [The actionable rule that prevents this mistake]
**Why it matters**: [The consequence of getting this wrong]
```

Write the rule in a form that future-you can actually apply. Vague lessons ("be more careful") are useless. Specific rules ("always run X before doing Y") are useful.

---

## Step 3: Review and Reinforce

After writing the lesson:

1. Look back at the full `tasks/lessons.md` — are there patterns?
2. If the same class of mistake keeps appearing, write a stronger general rule
3. Remove lessons that are no longer relevant or have been superseded

---

## Step 4: Confirm with the User

Briefly acknowledge the correction and the lesson:

> "Got it — I've noted this in lessons.md: [one-line rule]. I'll apply this going forward."

Keep it short. The user doesn't need a lengthy apology — they need to know the lesson was captured.

---

## Reviewing Lessons at Session Start

At the start of a new session, if `tasks/lessons.md` exists:
1. Read it fully
2. Identify which lessons are relevant to the current task
3. Internalize them before starting — don't just acknowledge, actually apply them

---

## Core Principle

Every correction is free information. The only waste is failing to capture it. Ruthlessly iterate on your lessons until your mistake rate actually drops — not as a performance, but as a real engineering practice.
