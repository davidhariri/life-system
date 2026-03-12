---
name: setup
description: "Set up the life system — choose a directory, scaffold files, and configure paths. Run this once before using other life-system skills."
user-invocable: true
allowed-tools: Read, Write, Bash, Glob, AskUserQuestion
---

# Life System Setup

This skill sets up the user's personal life system directory and config.

## Step 1: Ask for Directory

Use AskUserQuestion to ask the user where they want to store their life system files.

Suggest `~/Documents/life-system/` as the default. Let the user type a custom path. Expand `~` to the user's home directory.

## Step 2: Create Config

Write a config file at `~/.config/life-system/config.json`:

```json
{
  "base_dir": "/absolute/path/to/chosen/directory"
}
```

Create the directory if it doesn't exist: `mkdir -p ~/.config/life-system`

## Step 3: Scaffold Directory Structure

Create the following directories and files in the chosen directory. Use the templates bundled with this plugin at `${CLAUDE_PLUGIN_ROOT}/templates/`.

### Directories to create:
```
<base_dir>/
├── journal/<current-year>/
├── reference/
├── templates/
├── decisions/
├── people/
├── research/
```

### Files to copy from plugin templates:

| Source (plugin) | Destination (user dir) |
|----------------|----------------------|
| `templates/plan.md` | `<base_dir>/plan.md` |
| `templates/inbox.md` | `<base_dir>/inbox.md` |
| `templates/goals.md` | `<base_dir>/journal/<current-year>/goals.md` |
| `templates/values.md` | `<base_dir>/reference/values.md` |
| `templates/habits.md` | `<base_dir>/reference/habits.md` |
| `templates/daily-journal.md` | `<base_dir>/templates/daily-journal.md` |
| `templates/decision.md` | `<base_dir>/templates/decision.md` |
| `templates/person.md` | `<base_dir>/templates/person.md` |
| `templates/research.md` | `<base_dir>/templates/research.md` |

Read each template from `${CLAUDE_PLUGIN_ROOT}/templates/` and write it to the destination path. Do NOT overwrite existing files — skip them and tell the user.

## Step 4: Confirm

Tell the user setup is complete. Show them:
- Where their files live
- Available skills: `/ls:morning`, `/ls:evening`, `/ls:log`, `/ls:decide`, `/ls:person`, `/ls:weekly-review`
- Suggest running `/ls:morning` to start their first day
