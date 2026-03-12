---
name: evening
description: "Evening reflection and journal close-out. Use when user says 'evening', 'end of day', 'reflect', 'wrap up', or similar. Reviews what was accomplished vs. morning plan, asks Franklin's evening question, carries forward incomplete items."
user-invocable: true
allowed-tools: Read, Edit, Write, Glob, Grep, AskUserQuestion
---

# Evening Reflection

**Tone:** Direct, curious, non-judgmental. Like a good coach at the end of a long day.

---

## Step 0: Load Config

Read `~/.config/life-system/config.json` to get the user's base directory. If the config file doesn't exist, tell the user to run `/ls:setup` first and stop.

---

## Step 1: Load Today's Journal

Read today's journal at `<BASE_DIR>/journal/YYYY/MM/YYYY-MM-DD.md`.

If it doesn't exist, note that no morning planning happened today — that's worth reflecting on.

---

## Step 2: Review the Day

Summarize what was accomplished vs. the morning plan:
- Which morning outcomes were completed?
- What showed up that wasn't planned?
- What didn't get done?

Don't just list — reflect. Name patterns. If something was avoided all day, say so.

---

## Step 3: Franklin's Evening Question

Ask with AskUserQuestion: **"What good have I done today?"**

Let the user reflect. Ask follow-up questions if the answer is surface-level. Push gently toward what actually mattered vs. what just happened.

---

## Step 4: Update the Journal

Append an evening reflection section to today's journal:

```markdown
## Evening (Franklin: "What good have I done today?")

[User's reflection in their own words]

**Completed:**
- [x] Items that got done

**Carry forward:**
- [ ] Items still relevant for tomorrow

**Notes:**
- [Any observations, patterns, or things to remember]
```

- Mark completed items as `[x]`
- Move incomplete but still-relevant items to a "Carry forward" section
- Drop items that are no longer relevant (note that you dropped them)

---

## Step 5: Close

End with a brief, honest observation about the day. One sentence. Not cheerful for the sake of it — real.
