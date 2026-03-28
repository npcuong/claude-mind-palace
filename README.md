# 🧠 claude-mind-palace

> A personal AI operating system — skills, memory, and behavioral rules that turn Claude into a true personal assistant.

## What is this?

Most AI assistants forget everything between sessions. This repo fixes that.

`claude-mind-palace` is a collection of:
- **Skills** — specialized workflows Claude follows for specific tasks
- **Memory system** — persistent context that survives across sessions
- **Operating instructions** — behavioral rules so Claude works *your* way

Built for [Claude Code](https://claude.ai/code) with the Skills plugin.

---

## Skills

| Skill | Trigger | What it does |
|-------|---------|-------------|
| [`plan-task`](skills/plan-task/SKILL.md) | "implement", "build", "create X" | Enters plan mode, writes `tasks/todo.md` before writing any code |
| [`bugfix`](skills/bugfix/SKILL.md) | Error reports, stack traces, "CI is red" | Autonomously diagnoses root cause → fixes → verifies |
| [`verify-done`](skills/verify-done/SKILL.md) | Before saying "done" | Runs verification checklist: tests, regressions, staff engineer standard |
| [`capture-lesson`](skills/capture-lesson/SKILL.md) | After any correction | Writes lesson to `tasks/lessons.md`, reviews at session start |
| [`task-workflow`](skills/task-workflow/SKILL.md) | Complex multi-step tasks | Full loop: plan → implement → track → verify → document |
| [`brainstorm`](skills/brainstorm/SKILL.md) | "brainstorm", "ý tưởng", "có nên..." | Deep structured brainstorming with multi-angle analysis |

---

## Memory System

A global persistent memory layer at `~/.claude/`:

```
~/.claude/
├── CLAUDE.md                 ← Operating instructions (auto-loaded every session)
└── memory/
    ├── identity.md           ← Who you are, goals, decision-making style
    ├── working-style.md      ← Output preferences, tool stack, behavioral triggers
    ├── relationships.md      ← People: team, clients, mentors
    ├── decisions.md          ← Finalized decisions (Claude won't re-suggest)
    └── recurring-context.md  ← Active projects, deadlines, in-progress tasks
```

Claude reads memory silently at the start of every session and writes updates at the end.

### Commands
| Command | Action |
|---------|--------|
| `remember: [X]` | Save X to the right memory file |
| `forget [X]` | Remove X from memory |
| `review memory` | Read all memory, report summary, suggest cleanup |
| `my memory` | Show what Claude currently knows about you |

---

## Setup

### 1. Install the skills

Copy each skill directory into your Claude Skills plugin folder, or import the `.skill` files directly.

### 2. Set up the memory system

```bash
mkdir -p ~/.claude/memory

# Copy templates
cp memory-system/CLAUDE.md ~/.claude/CLAUDE.md
cp memory-system/identity.md ~/.claude/memory/identity.md
cp memory-system/working-style.md ~/.claude/memory/working-style.md
cp memory-system/relationships.md ~/.claude/memory/relationships.md
cp memory-system/decisions.md ~/.claude/memory/decisions.md
cp memory-system/recurring-context.md ~/.claude/memory/recurring-context.md
```

### 3. Fill in the blanks

Open `~/.claude/memory/identity.md` and fill in your actual details. Lines with `_(...)_` are placeholders — replace them with your information.

---

## Philosophy

> *"A good assistant doesn't need to be told twice."*

- **Skills** handle *how* to approach a type of task
- **Memory** handles *who you are* and *what's going on*
- **CLAUDE.md** handles *how Claude should behave* with you specifically

Together they make Claude feel less like a chatbot and more like a senior colleague who's been working with you for months.

---

## File conventions

Every project using this system can have:
```
tasks/
├── todo.md        ← Current task plan + progress tracking
└── lessons.md     ← Accumulated lessons from corrections
```

---

*Built with Claude Code + Skills plugin.*
