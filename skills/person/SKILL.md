---
name: person
description: "Create a new person note. Use when user says 'research this person', 'meeting with someone new', 'add person', or wants to capture notes about someone."
user-invocable: true
allowed-tools: Read, Write, Glob, AskUserQuestion, WebSearch, WebFetch
argument-hint: "[person name]"
---

# New Person Note

Create a structured note about a person — for meeting prep, relationship context, or research.

## Step 0: Load Config

Read `~/.config/life-system/config.json` to get the user's base directory. If the config file doesn't exist, tell the user to run `/ls:setup` first and stop.

## Step 1: Get the Person

If `$ARGUMENTS` contains a name, use it. Otherwise, use AskUserQuestion to ask: "Who do you want to create a note for?"

## Step 2: Check for Existing Note

Search `<BASE_DIR>/people/` for an existing file matching the person's name. If found, ask if the user wants to update it or create a new one.

## Step 3: Gather Context

Use AskUserQuestion to ask: "What's the context? (meeting prep, new contact, research, etc.)"

Based on context:
- **Meeting prep:** Offer to research the person online (use WebSearch) and fill in background, key views, notable work
- **New contact:** Ask what the user knows — how they met, what they discussed, anything to remember
- **Research:** Do a deep dive — search for interviews, talks, articles, and compile findings

## Step 4: Create the Document

Read the person template from `<BASE_DIR>/templates/person.md`.

Create a new file at `<BASE_DIR>/people/<slugified-name>.md` with whatever information was gathered. Don't fill in sections that have no data — leave them as template placeholders.

## Step 5: Confirm

Say: "Created person note at people/<slugified-name>.md"

If today's journal exists, add a log entry: `- HH:MM — Created note for [[<slugified-name>]]`
