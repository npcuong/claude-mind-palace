---
name: writing-skills
description: >
  Meta skill for creating new Claude skills — use this when you want to build
  a new skill, improve an existing one, or turn a workflow you keep repeating
  into a reusable skill. Trigger when the user says "make this a skill",
  "create a skill for X", "turn this workflow into a skill", "I keep doing X
  manually", "add this to our skill library", or "how do I make a skill".
  Also use when reviewing an existing skill that isn't working as expected.
---

# Writing Skills — Meta Skill

You are building a skill that will run autonomously, without you present to clarify or correct. Write it for that context: clear enough that it works without hand-holding, flexible enough to handle real-world variation.

---

## Step 1: Capture Intent Before Writing

Answer these before touching a file:

1. **What does this skill enable Claude to do?** (one sentence)
2. **When should it trigger?** (specific phrases, contexts, file types)
3. **What's the expected output?** (file, report, action, question to user)
4. **What are the 2–3 most common failure modes?** (what would go wrong without explicit guidance)

If you can't answer these cleanly, the skill is not ready to write yet. Clarify first.

---

## Step 2: Anatomy of a Skill

```
skill-name/
└── SKILL.md        ← Required. Contains frontmatter + instructions.
    scripts/        ← Optional. Executable code for deterministic tasks.
    references/     ← Optional. Docs loaded into context as needed.
```

**SKILL.md frontmatter (required):**
```yaml
---
name: skill-name
description: >
  When to trigger (specific phrases and contexts) AND what the skill does.
  Make it slightly "pushy" — Claude undertriggers by default, so be explicit:
  "Use this whenever X, even if the user doesn't mention Y explicitly."
---
```

The `description` is the only thing Claude sees when deciding whether to invoke a skill. It's the most important part of the file. Write it last, after you know what the skill actually does.

---

## Step 3: Write the Skill Body

**Principles:**

- **Explain the why, not just the what.** Claude is smart enough to adapt if it understands the reasoning. "Always write the test before the code" is weaker than "Write the test before the code — this forces you to design the interface from the user's perspective, which consistently produces cleaner code."

- **Use HARD-GATEs for non-negotiable stops.** When the workflow must pause and cannot proceed without a specific condition:
```markdown
<HARD-GATE>
STOP. Do not proceed until [condition].
Acceptable inputs: [list].
</HARD-GATE>
```

- **Structure as phases, not a flat list.** Group related steps into named phases (Gather Evidence, Analyze, Fix, Verify). This gives Claude a mental model of the workflow, not just a checklist.

- **Include anti-patterns.** Often more useful than best practices — listing what NOT to do prevents the most common failures.

- **End with a Core Principle.** One sentence that captures the spirit of the skill. If Claude is uncertain how to handle an edge case, it should be able to derive the right answer from this principle.

**Length guide:**
- Simple workflow (3–5 steps): 50–100 lines
- Complex workflow (phases, decision trees): 100–200 lines
- If approaching 300 lines: split into main SKILL.md + `references/` files

---

## Step 4: Write the Description Last

After writing the body, come back and write the frontmatter `description`. It should:

1. State the **specific trigger phrases** (the actual words a user would say)
2. State **what the skill does** in one sentence
3. Include a "push" line that expands the trigger surface: "Use this even when..."

**Example of a weak description:**
```yaml
description: Helps with debugging.
```

**Example of a strong description:**
```yaml
description: >
  Deep systematic debugging for bugs that resist quick fixes. Use when a bug
  reappears after being "fixed", the stack trace is misleading, or the user
  says "still broken", "can't figure out", "weird behavior", "no idea why".
  Also trigger when CI fails in ways that don't reproduce locally, or any time
  multiple fix attempts have failed — systematic root cause tracing is needed.
```

---

## Step 5: Validate Before Saving

Before finalizing:

- [ ] Could a new Claude instance (no context from this conversation) follow these instructions correctly?
- [ ] Is there any step where Claude would have to guess what to do?
- [ ] Does the HARD-GATE (if any) have explicit "acceptable" and "unacceptable" states?
- [ ] Is the description specific enough to distinguish this skill from similar ones?
- [ ] Is the skill scoped tightly — does it do one thing well?

---

## Step 6: Register the Skill

After writing `SKILL.md`:

1. Place it in `skills/<skill-name>/SKILL.md` in the repo
2. Add a row to the skills table in `README.md`
3. Install it in the Claude Skills plugin directory

---

## Common Mistakes When Writing Skills

| Mistake | Better approach |
|---------|----------------|
| Instructions that only cover the happy path | Include edge cases and failure modes |
| Vague trigger description | List exact phrases users would say |
| MUST/ALWAYS without explanation | Explain why — Claude adapts better with reasoning |
| No stopping condition | Add explicit "when is this skill done?" |
| Skill tries to do too much | Split into focused single-purpose skills |
| Description written first | Write body first, description last |

---

## Core Principle

A skill is not a checklist — it's a mental model transfer. Your job is to give Claude enough understanding of a workflow that it can handle variation and edge cases, not just follow steps in the exact scenario you imagined.
