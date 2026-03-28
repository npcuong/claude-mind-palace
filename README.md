# 🧠 claude-mind-palace

> A personal AI operating system — skills, memory, and behavioral rules that turn Claude into a true personal assistant.
> Meet **Sonmi452**: your Claude, with memory, skills, and a personality.

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
| [`plan-task`](skills/plan-task/SKILL.md) | "implement", "build", "create X" | Enters plan mode, writes `tasks/todo.md`. **HARD-GATE** before any code. |
| [`task-workflow`](skills/task-workflow/SKILL.md) | Complex multi-step tasks | Full loop: plan → **HARD-GATE** → implement → track → verify → document |
| [`bugfix`](skills/bugfix/SKILL.md) | Error reports, stack traces, "CI is red" | Autonomously diagnoses root cause → fixes → verifies |
| [`systematic-debug`](skills/systematic-debug/SKILL.md) | "still broken", "no idea why", recurring bugs | Deep root-cause tracing: hypothesis → evidence → fix → prevention |
| [`tdd`](skills/tdd/SKILL.md) | "write tests first", "TDD this", bug fixes | RED → GREEN → REFACTOR with anti-pattern enforcement |
| [`code-review`](skills/code-review/SKILL.md) | "review this", "PR is up", review feedback | Two-sided: requesting (self-review + spec + quality) and receiving |
| [`verify-done`](skills/verify-done/SKILL.md) | Before saying "done" | Checklist: correctness, regressions, staff engineer standard |
| [`capture-lesson`](skills/capture-lesson/SKILL.md) | After any correction | Writes lesson to `tasks/lessons.md`, reviews at session start |
| [`writing-skills`](skills/writing-skills/SKILL.md) | "make this a skill", "create a skill for X" | Meta: how to design, write, and register new skills |
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

### Quick install (recommended)

```bash
git clone https://github.com/npcuong/claude-mind-palace.git
cd claude-mind-palace
bash install.sh
```

Restart Claude Desktop. Done — all skills are active.

**With memory system (first-time setup):**
```bash
bash install.sh --memory
```

Then edit `~/.claude/memory/identity.md` — fill in your name, role, and goals. Lines with `_(...)_` are placeholders.

---

### Manual install

#### 1. Install the skills

Find your Claude Skills plugin directory:
- **macOS**: `~/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin/<UUID>/<UUID>/skills/`
- **Linux**: `~/.config/Claude/local-agent-mode-sessions/skills-plugin/<UUID>/<UUID>/skills/`

The UUIDs are generated per-machine — use `find` to locate them:
```bash
find ~/Library/Application\ Support/Claude/local-agent-mode-sessions/skills-plugin \
  -mindepth 3 -maxdepth 3 -type d -name "skills"
```

Copy skills:
```bash
cp -r skills/* <your-skills-plugin-path>/
```

#### 2. Set up the memory system (optional)

```bash
mkdir -p ~/.claude/memory

cp memory-system/CLAUDE.md ~/.claude/CLAUDE.md
cp memory-system/identity.md ~/.claude/memory/identity.md
cp memory-system/working-style.md ~/.claude/memory/working-style.md
cp memory-system/relationships.md ~/.claude/memory/relationships.md
cp memory-system/decisions.md ~/.claude/memory/decisions.md
cp memory-system/recurring-context.md ~/.claude/memory/recurring-context.md
```

#### 3. Set up the auto-memory hook

```bash
mkdir -p ~/.claude/hooks
cp memory-system/hooks/save_session.py ~/.claude/hooks/save_session.py
```

Add to `~/.claude/settings.json`:
```json
"hooks": {
  "Stop": [{ "matcher": "", "hooks": [{ "type": "command", "command": "python3 ~/.claude/hooks/save_session.py" }] }]
}
```

---

### Updating skills

To pull the latest skills from this repo:
```bash
git pull
bash install.sh
```

The script only updates skills that have changed — safe to re-run anytime.

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
