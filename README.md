# Life System — Claude Code Plugin

A personal life operating system powered by Claude Code. Inspired by Carmack's .plan files and Franklin's systematic self-improvement.

No apps, no subscriptions. Just markdown files, a terminal, and an AI that pushes back.

## What You Get

- **Life plan** — 10-year vision, life chapters, what you're optimizing for
- **Annual goals** — Yearly bets, anti-goals, who you're becoming
- **Daily journal** — Franklin's morning question + Carmack-style timestamped log + evening reflection
- **Decision records** — Structured docs for important decisions so you can trace your reasoning later
- **Inbox** — Quick capture for tasks, ideas, and things to process later
- **Values & habits** — Your principles and daily routines, written down so Claude can hold you to them
- **People** — Notes on people you're meeting, working with, or researching
- **Research** — Deep dives on any topic — companies, technologies, markets, ideas

## Install

**From GitHub (2 steps):**
```bash
# Step 1: Add repo as a marketplace
/plugin marketplace add ilumin/life-system

# Step 2: Install the plugin
/plugin install ls@ilumin-life-system
```

**From a local clone:**
```bash
git clone https://github.com/ilumin/life-system.git
# Add local path as marketplace, then install
/plugin marketplace add ./life-system
/plugin install ls@life-system
```

**For development/testing (session only, no install):**
```bash
claude --plugin-dir ./life-system
```

Then run setup to choose where your files live:

```
/ls:setup
```

This will:
1. Ask you to choose a directory (default: `~/Documents/life-system/`)
2. Create the folder structure and starter files
3. Save your config to `~/.config/life-system/config.json`

## Skills

| Skill | What it does |
|-------|-------------|
| `/ls:setup` | One-time setup — choose directory, scaffold files |
| `/ls:morning` | Daily planning — review yesterday, set today's priorities, alignment check |
| `/ls:evening` | End-of-day reflection — Franklin's evening question, carry forward |
| `/ls:log` | Quick-add a timestamped entry to today's journal |
| `/ls:decide` | Create a structured decision record |
| `/ls:person` | Create a person note (with optional web research) |
| `/ls:weekly-review` | Weekly patterns, goal progress, next week priorities |

## How It Works

### Morning
Say "morning" or run `/ls:morning`. Claude will:
- Review yesterday's journal
- Create today's journal from the template
- Ask Franklin's question: "What good shall I do this day?"
- Challenge your priorities against your annual goals

### During the Day
- `/ls:log Fixed the auth bug` — timestamped entry added to today's journal
- `/ls:decide` — think through a significant decision
- `/ls:person Jane Smith` — research someone before a meeting
- Claude auto-logs important moments when working with you

### Evening
Run `/ls:evening`. Claude will:
- Summarize accomplishments vs. morning plan
- Ask Franklin's question: "What good have I done today?"
- Carry forward incomplete items

### Weekly
Run `/ls:weekly-review` for pattern analysis, goal progress, and next-week priorities.

## Directory Structure

After setup, your chosen directory contains:

```
<your-dir>/
├── plan.md                        # 10-year life vision
├── inbox.md                       # Quick capture
├── journal/
│   └── YYYY/
│       ├── goals.md               # Annual goals
│       └── MM/
│           └── YYYY-MM-DD.md      # Daily entries
├── reference/
│   ├── values.md                  # Core principles
│   └── habits.md                  # Daily routines
├── templates/                     # Document templates
│   ├── daily-journal.md
│   ├── decision.md
│   ├── person.md
│   └── research.md
├── decisions/                     # Decision records
├── people/                        # People notes
└── research/                      # Research docs
```

## The Key Insight

The system works because Claude reads your plan, goals, and values before every session. It holds you accountable to what you said matters. When your daily actions drift from your annual goals, it names it. When your goals drift from your life plan, it names that too.

## Wiki-Links

Files can reference each other using `[[wiki-links]]`. For example:
- `Met with [[jane-smith]] about the project`
- `Based on [[market-analysis]]`

Claude resolves these by searching `people/`, `research/`, `decisions/`, and `journal/` for the matching file.

## Journal Shell Script

For quick terminal access without Claude Code:

```bash
cp scripts/journal.sh ~/.scripts/journal.sh
chmod +x ~/.scripts/journal.sh
echo "alias jrn='~/.scripts/journal.sh'" >> ~/.zshrc
```

The script reads your config from `~/.config/life-system/config.json` — no hardcoded paths. Type `jrn` to open today's journal.

Set your editor with `LIFE_SYSTEM_EDITOR` env var, or it falls back to `$EDITOR`, then `code`.

## Optional: QMD for Search

Once you accumulate journal entries, decision docs, and notes, you can use [QMD](https://github.com/tobi/qmd) for local semantic search:

```bash
brew install tobi/tap/qmd
cd <your-life-system-dir>
qmd update && qmd embed
```

Add QMD as an MCP server in `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "qmd": {
      "command": "qmd",
      "args": ["mcp"],
      "cwd": "/path/to/your/life-system"
    }
  }
}
```

## Customizing

Everything is a starting point. Delete what doesn't resonate, add what does:

- Don't care about Franklin's questions? Remove them from the template.
- Want weekly reviews? Run `/ls:weekly-review`.
- Have a different morning routine? Update `reference/habits.md`.
- The skills are plain markdown — edit them to match how you think.
