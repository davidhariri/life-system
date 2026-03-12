---
name: decide
description: "Create a new decision record. Use when user says 'I need to decide', 'decision', 'help me think through', or faces a significant choice."
user-invocable: true
allowed-tools: Read, Write, Glob, AskUserQuestion
argument-hint: "[decision title]"
---

# New Decision Record

Help the user think through a significant decision and capture it as a structured document.

## Step 0: Load Config

Read `~/.config/life-system/config.json` to get the user's base directory. If the config file doesn't exist, tell the user to run `/ls:setup` first and stop.

## Step 1: Get the Decision

If `$ARGUMENTS` contains a title, use it. Otherwise, use AskUserQuestion to ask: "What decision are you facing?"

## Step 2: Think It Through

Use AskUserQuestion to walk through the decision:

1. **Context:** "What's the situation? Why is this decision needed now?"
2. **Options:** "What are your realistic options?" — for each, probe upside, downside, and gut feel
3. **Criteria:** "What matters most here? Rank what you're optimizing for."
4. **Gut check:** "If you had to decide right now, what would you pick? Why?"

Push back on false dichotomies. Ask if there are options they haven't considered. Challenge assumptions.

## Step 3: Create the Document

Read the decision template from `<BASE_DIR>/templates/decision.md`.

Create a new file at `<BASE_DIR>/decisions/<slugified-title>.md` with the template filled in from the conversation. Use today's date for the "Opened" field.

Don't force a decision — if they're not ready, leave the Decision section empty and set a review date.

## Step 4: Link It

If today's journal exists, add the decision to the Active Decisions section:
```
- [ ] [[<slugified-title>]] — [brief description]
```

Confirm: "Created decision record at decisions/<slugified-title>.md"
