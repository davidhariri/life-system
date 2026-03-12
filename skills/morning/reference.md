# Morning Skill Reference

## File Locations

All paths are relative to the user's configured `base_dir` (read from `~/.config/life-system/config.json`):

```
<base_dir>/plan.md                        # 10-year life vision
<base_dir>/journal/YYYY/goals.md          # Annual goals
<base_dir>/journal/YYYY/MM/YYYY-MM-DD.md  # Daily entries
<base_dir>/journal/YYYY/MM/week-WW.md     # Weekly reviews (optional)
<base_dir>/reference/values.md            # Core principles
<base_dir>/inbox.md                       # Quick capture
<base_dir>/decisions/                     # Decision records
<base_dir>/templates/                     # Templates
```

## Task Management (Plain Text)

All tasks are managed in plain text:

- **Personal backlog / quick capture:** `<base_dir>/inbox.md`
- **Project tasks:** `plan.md` in each project's repo root
- **Daily to-dos:** In the morning section of the daily journal

## Optional: Calendar Integration (macOS)

If you use Apple Calendar, install `icalBuddy` to pull today's events into the morning routine:

```bash
brew install ical-buddy
```

Then add this to Step 3 of the morning skill to auto-populate the log with today's events:
```bash
icalBuddy -nc -nrd -eep "notes,location,url,attendees" -tf "%H:%M" -df "" eventsToday
```

You can filter to specific calendars with `-ic "Work,Personal"`.
