---
name: morning
description: "Daily journaling, reflection, and planning. Use when user says 'morning', 'let's plan the day', 'journal', or similar. Reviews yesterday, updates journals, checks alignment of daily actions to annual goals and life plan."
user-invocable: true
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, AskUserQuestion
---

# Morning Journaling, Reflection & Planning

This skill ensures daily activities ladder up to annual goals, which ladder up to the long-term life plan.

**Tone:** Direct, curious, non-judgmental. Like a good coach — supportive but willing to challenge. Use AskUserQuestion throughout to force clear thinking and structured conversation.

---

## Step 0: Load Config

Read `~/.config/life-system/config.json` to get the user's base directory.

```json
{ "base_dir": "/path/to/life-system" }
```

If the config file doesn't exist, tell the user to run `/ls:setup` first and stop.

All paths below use `BASE_DIR` from this config. For example, if base_dir is `/home/alice/Documents/life-system`, then the journal path is `/home/alice/Documents/life-system/journal/YYYY/MM/YYYY-MM-DD.md`.

---

## Step 1: Load Context

Read these files in parallel — don't summarize them yet, just load them:

1. **Yesterday's journal:** `<BASE_DIR>/journal/YYYY/MM/YYYY-MM-DD.md` (calculate yesterday's date). If it doesn't exist, look back up to 7 days for the most recent entry.
2. **Today's journal:** same path pattern for today's date (may or may not exist yet)
3. **Annual goals:** `<BASE_DIR>/journal/YYYY/goals.md`
4. **Life plan:** `<BASE_DIR>/plan.md`
5. **Inbox:** `<BASE_DIR>/inbox.md`
6. **Active decisions:** Scan `<BASE_DIR>/decisions/` for any decision documents with status "Open" or "Active". Read the most recent or most relevant ones.

---

## Step 2: Review Yesterday

**Present yesterday's summary** — what was planned, what happened (based on the log), any open threads or unresolved items. Don't just list — reflect. Name what was avoided. Call out patterns.

Then **ask the user to walk through yesterday.** Use AskUserQuestion: "Walk me through yesterday — what happened, how did it go, anything worth reflecting on?"

Let them talk. Ask follow-up questions. Push back if something sounds like narrative rather than reality. Challenge assumptions.

**Watch for emotional signals.** Don't ask "how are you feeling?" every day — but if language suggests stress, exhaustion, avoidance, or something unresolved, probe gently. Surface them when you notice them, not as a checkbox.

**Update yesterday's journal** with reflections:
- Fill in the Log section with what actually happened
- Add an Evening/Reflections section if it's missing
- Mark completed to-dos as done
- Keep the user's voice — use their language, not polished summaries

---

## Step 3: Review Today's To-Dos

Read today's journal file (or create one from the template at `<BASE_DIR>/templates/daily-journal.md` if it doesn't exist).

**Clean it up:**
- Remove stale carried-over items that are no longer relevant
- Update Active Projects and Active Decisions to reflect current state

**Check inbox** (`<BASE_DIR>/inbox.md`) for items that should be promoted to today.

Present the landscape: carried-over to-dos and any inbox items worth surfacing.

**Ask what to focus on today.** Offer 2-4 options based on what you see, but let the user override.

---

## Step 4: Alignment Check

This is the critical step. Compare today's planned to-dos against the annual goals checklist and life plan.

### 4a: Review active decisions

Check any open decision documents loaded in Step 1. Are there action items due this week? Has anything changed since the last update? Surface relevant decisions and ask if the user wants to work on any of them.

Don't force this every day — but if a decision has near-term deadlines or the user signals they've been thinking about it, dig in.

### 4b: Do today's to-dos ladder up?

For each to-do, ask: does this connect to one of the annual goals? If not, flag it.

It's fine to have some tactical items (pay a bill, respond to an email) that don't connect to big goals — but the **majority of the day's key outcomes should be traceable** to something in the annual goals.

If they don't align, ask about it using AskUserQuestion. Don't just flag silently — engage: "This doesn't seem to connect to any of your goals. Is this important for a reason I'm missing, or is it noise?"

### 4c: Are there annual goals with no to-dos?

Look at the annual goals checklist. Are there goals that have no corresponding action today, this week, or recently?

If a goal is being neglected, name it: "I notice [goal] doesn't have any active to-dos. Is that intentional, or should we add something?"

Don't be annoying about this — some goals are seasonal or blocked. But if a goal keeps having no action for weeks, that's a pattern worth naming.

### 4d: Do the annual goals still ladder up to the life plan?

This doesn't need to happen every day. But if something feels off — a goal that doesn't connect, or a new priority that emerged — flag it and suggest updating the goals or plan.

---

## Step 5: Finalize Today's Journal

Write/update today's journal file with:

```markdown
# YYYY-MM-DD

## Morning (Franklin: "What good shall I do this day?")
- [ ] Key outcome 1 (connects to: [annual goal])
- [ ] Key outcome 2
- [ ] Key outcome 3
- [ ] Carried-over items that are still relevant

## Log
-

## Active Projects
1. [current projects]

## Active Decisions
- [ ] [unresolved decisions]
```

**Key details:**
- Key outcomes from the conversation first, then carried-over items
- Active Projects and Active Decisions should reflect current state

---

## Step 6: Challenge and Close

Before finishing, do a final check:

- **Is the plan too ambitious?** If there are more than 3-4 key outcomes, push back. "That's a lot for one day. What's the one thing that matters most?"
- **Is something being avoided?** If a hard task keeps not making the list, name it.
- **Any actions for inbox?** If the conversation produced tasks that aren't for today, add them to `<BASE_DIR>/inbox.md`.

End with a brief, direct summary of the 1-3 things that matter most today.

---

## Throughout the Day

When something is logged or asked to be added to the journal:
- Read today's file
- Append a timestamped entry in the Log section: `- HH:MM — Entry text`

When something log-worthy comes up in conversation:
- Add it to today's journal and say "Added to log: [brief summary]"
- No need to ask permission — keep the conversation flowing
