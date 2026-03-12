---
name: log
description: "Quick-add a timestamped log entry to today's journal. Use when user says 'log this', 'add to journal', 'note this', or wants to capture something quickly."
user-invocable: true
allowed-tools: Read, Edit, Write, Glob, Bash
argument-hint: "[entry text]"
---

# Quick Log Entry

Add a timestamped entry to today's journal without the full morning routine.

## Step 0: Load Config

Read `~/.config/life-system/config.json` to get the user's base directory. If the config file doesn't exist, tell the user to run `/ls:setup` first and stop.

## Step 1: Find or Create Today's Journal

Look for today's journal at `<BASE_DIR>/journal/YYYY/MM/YYYY-MM-DD.md`.

If it doesn't exist, create it from the template at `<BASE_DIR>/templates/daily-journal.md`, replacing `{{DATE}}` with today's date.

## Step 2: Add Log Entry

Read the journal file. Find the `## Log` section. Append a new timestamped entry:

```
- HH:MM — $ARGUMENTS
```

Use the current time. If `$ARGUMENTS` is empty, ask the user what to log.

## Step 3: Confirm

Say: "Added to log: [brief summary]"

Keep it short. Don't interrupt the user's flow.
