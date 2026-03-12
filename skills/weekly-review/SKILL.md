---
name: weekly-review
description: "Weekly review — patterns, goal progress, and next week priorities. Use when user says 'weekly review', 'week in review', or similar."
user-invocable: true
allowed-tools: Read, Edit, Write, Glob, Grep, AskUserQuestion
---

# Weekly Review

**Tone:** Direct, curious, non-judgmental. Zoom out from daily noise to weekly patterns.

---

## Step 0: Load Config

Read `~/.config/life-system/config.json` to get the user's base directory. If the config file doesn't exist, tell the user to run `/ls:setup` first and stop.

---

## Step 1: Load the Week's Journals

Read all journal entries from the current week (Monday through today) at `<BASE_DIR>/journal/YYYY/MM/YYYY-MM-DD.md`.

Also read:
- **Annual goals:** `<BASE_DIR>/journal/YYYY/goals.md`
- **Life plan:** `<BASE_DIR>/plan.md`
- **Inbox:** `<BASE_DIR>/inbox.md`
- **Active decisions:** Scan `<BASE_DIR>/decisions/` for open decisions.

---

## Step 2: Summarize the Week

Present a clear summary:
- **What got done** — actual accomplishments, not just activity
- **What didn't get done** — things that were planned but didn't happen
- **Patterns** — recurring themes, avoidance patterns, energy patterns
- **Surprises** — things that showed up unplanned

Don't sugarcoat. Name what was avoided.

---

## Step 3: Goal Progress Check

For each annual goal:
- Did it get any action this week?
- Is it on track overall?
- Are there goals with no activity for 2+ weeks?

Use AskUserQuestion to probe: "Which goal feels most stuck right now? What's blocking it?"

---

## Step 4: Process Inbox

Review `<BASE_DIR>/inbox.md`:
- Promote actionable items to next week's priorities
- Archive or delete stale items
- Ask about items that have been sitting for too long

---

## Step 5: Next Week Priorities

Ask the user: "What are the 1-3 things that matter most next week?"

Challenge if the list is too long or doesn't connect to annual goals.

---

## Step 6: Write Weekly Review

Create or update `<BASE_DIR>/journal/YYYY/MM/week-WW.md` with:

```markdown
# Week WW — YYYY

## Summary
[Brief narrative of the week]

## Accomplished
- [Key accomplishments]

## Missed
- [Things that didn't happen]

## Patterns
- [What you noticed]

## Goal Progress
| Goal | Status | Notes |
|------|--------|-------|
| | | |

## Next Week
- [ ] Priority 1
- [ ] Priority 2
- [ ] Priority 3
```
