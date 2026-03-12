#!/bin/bash

# Journal quick-open script
# Opens today's journal, creating from template if needed
# Backfills any missing days with calendar events and carried-over todos
#
# Setup:
#   1. Run /ls:setup in Claude Code to configure your directory
#   2. chmod +x this file
#   3. Add to your shell: alias jrn='~/.scripts/journal.sh'
#   4. (Optional) Install icalBuddy for calendar integration: brew install ical-buddy

# Read config from life-system plugin config
CONFIG_FILE="$HOME/.config/life-system/config.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Life system not configured. Run /ls:setup in Claude Code first."
    exit 1
fi

# Parse base_dir from config JSON (portable, no jq dependency)
BASE_DIR=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE'))['base_dir'])" 2>/dev/null)

if [ -z "$BASE_DIR" ]; then
    echo "Error: Could not read base_dir from $CONFIG_FILE"
    exit 1
fi

JOURNAL_DIR="$BASE_DIR/journal"
TEMPLATE="$BASE_DIR/templates/daily-journal.md"

# Editor command — override with LIFE_SYSTEM_EDITOR env var, falls back to EDITOR, then code
EDITOR_CMD="${LIFE_SYSTEM_EDITOR:-${EDITOR:-code}}"

# Calendar names to include (only used if icalBuddy is installed)
CALENDAR_NAMES="${LIFE_SYSTEM_CALENDARS:-Work,Personal,Family}"

# Get today's date
TODAY=$(date +%Y-%m-%d)

# Find most recent journal entry (looking back up to 60 days)
find_most_recent_journal_date() {
    for i in $(seq 1 60); do
        # Support both macOS (date -v) and Linux (date -d)
        if date -v-1d +%Y-%m-%d &>/dev/null; then
            PAST_DATE=$(date -v-${i}d +%Y-%m-%d)
            PAST_YEAR=$(date -v-${i}d +%Y)
            PAST_MONTH=$(date -v-${i}d +%m)
        else
            PAST_DATE=$(date -d "-${i} days" +%Y-%m-%d)
            PAST_YEAR=$(date -d "-${i} days" +%Y)
            PAST_MONTH=$(date -d "-${i} days" +%m)
        fi
        PAST_FILE="$JOURNAL_DIR/$PAST_YEAR/$PAST_MONTH/$PAST_DATE.md"
        if [ -f "$PAST_FILE" ]; then
            echo "$PAST_DATE"
            return
        fi
    done
}

# Get calendar events for a specific date (macOS only, requires icalBuddy)
get_calendar_events() {
    local TARGET_DATE="$1"
    if command -v icalBuddy &> /dev/null; then
        icalBuddy -nc -nrd -ic "$CALENDAR_NAMES" -eep "notes,location,url,attendees" -tf "%H:%M" -df "" eventsFrom:"$TARGET_DATE" to:"$TARGET_DATE" 2>/dev/null | python3 -c "
import sys
import re

lines = sys.stdin.read().strip().split('\n')
results = []
i = 0
while i < len(lines):
    line = lines[i].strip()
    if line.startswith('• '):
        title = line[2:]
        i += 1
        if i < len(lines):
            time_line = lines[i].strip()
            match = re.match(r'(\d{2}:\d{2}) - (\d{2}:\d{2})', time_line)
            if match:
                start, end = match.groups()
                sh, sm = map(int, start.split(':'))
                eh, em = map(int, end.split(':'))
                dur = (eh * 60 + em) - (sh * 60 + sm)
                if dur >= 60:
                    h, m = divmod(dur, 60)
                    dur_str = f'{h}h {m}m' if m else f'{h}h'
                else:
                    dur_str = f'{dur}m'
                results.append(f'- {start} - {title} ({dur_str})')
    i += 1
print('\n'.join(results))
" 2>/dev/null
    fi
}

# Get incomplete todos from a journal file
get_incomplete_todos() {
    local FILE="$1"
    if [ -f "$FILE" ]; then
        grep -E '^\s*- \[ \]' "$FILE" 2>/dev/null | head -n 20 || true
    fi
}

# Get active (unresolved) decisions from a journal file
get_active_decisions() {
    local FILE="$1"
    if [ -f "$FILE" ]; then
        sed -n '/^## Active Decisions/,/^## /p' "$FILE" 2>/dev/null | \
            grep -E '^\s*- \[ \]' 2>/dev/null || true
    fi
}

# Create a journal entry for a specific date
create_journal_entry() {
    local TARGET_DATE="$1"
    local PREV_FILE="$2"

    local TARGET_YEAR=$(echo "$TARGET_DATE" | cut -d'-' -f1)
    local TARGET_MONTH=$(echo "$TARGET_DATE" | cut -d'-' -f2)
    local TARGET_FILE="$JOURNAL_DIR/$TARGET_YEAR/$TARGET_MONTH/$TARGET_DATE.md"

    # Skip if already exists
    if [ -f "$TARGET_FILE" ]; then
        echo "$TARGET_FILE"
        return
    fi

    # Ensure directory exists
    mkdir -p "$(dirname "$TARGET_FILE")"

    # Get todos from previous file
    local PAST_TODOS=""
    if [ -n "$PREV_FILE" ]; then
        PAST_TODOS=$(get_incomplete_todos "$PREV_FILE")
    fi

    # Get active decisions from previous file
    local PAST_DECISIONS=""
    if [ -n "$PREV_FILE" ]; then
        PAST_DECISIONS=$(get_active_decisions "$PREV_FILE")
    fi

    # Get calendar events for this date
    local CALENDAR_EVENTS=$(get_calendar_events "$TARGET_DATE")

    # Read template and replace placeholders
    if [ -f "$TEMPLATE" ]; then
        local CONTENT=$(cat "$TEMPLATE")
        CONTENT="${CONTENT//\{\{DATE\}\}/$TARGET_DATE}"

        if [ -n "$PAST_TODOS" ]; then
            CONTENT="${CONTENT//\{\{PAST_TODOS\}\}/$PAST_TODOS}"
        else
            CONTENT="${CONTENT//\{\{PAST_TODOS\}\}/}"
        fi

        if [ -n "$CALENDAR_EVENTS" ]; then
            CONTENT="${CONTENT//\{\{CALENDAR\}\}/$CALENDAR_EVENTS}"
        else
            CONTENT="${CONTENT//\{\{CALENDAR\}\}/}"
        fi

        if [ -n "$PAST_DECISIONS" ]; then
            CONTENT="${CONTENT//\{\{PAST_DECISIONS\}\}/$PAST_DECISIONS}"
        else
            CONTENT="${CONTENT//\{\{PAST_DECISIONS\}\}/}"
        fi

        echo "$CONTENT" > "$TARGET_FILE"
    fi

    echo "$TARGET_FILE"
}

# Calculate days between two dates
days_between() {
    local START_DATE="$1"
    local END_DATE="$2"
    # Support both macOS and Linux
    if date -j -f "%Y-%m-%d" "$START_DATE" "+%s" &>/dev/null; then
        local START_SEC=$(date -j -f "%Y-%m-%d" "$START_DATE" "+%s")
        local END_SEC=$(date -j -f "%Y-%m-%d" "$END_DATE" "+%s")
    else
        local START_SEC=$(date -d "$START_DATE" "+%s")
        local END_SEC=$(date -d "$END_DATE" "+%s")
    fi
    echo $(( (END_SEC - START_SEC) / 86400 ))
}

# Main logic
MOST_RECENT_DATE=$(find_most_recent_journal_date)

if [ -n "$MOST_RECENT_DATE" ]; then
    DAYS_MISSING=$(days_between "$MOST_RECENT_DATE" "$TODAY")

    if [ "$DAYS_MISSING" -gt 0 ]; then
        PREV_YEAR=$(echo "$MOST_RECENT_DATE" | cut -d'-' -f1)
        PREV_MONTH=$(echo "$MOST_RECENT_DATE" | cut -d'-' -f2)
        PREV_FILE="$JOURNAL_DIR/$PREV_YEAR/$PREV_MONTH/$MOST_RECENT_DATE.md"

        # Create entries for each missing day (starting from day after most recent)
        for i in $(seq $((DAYS_MISSING - 1)) -1 0); do
            # Support both macOS and Linux
            if date -v-1d +%Y-%m-%d &>/dev/null; then
                TARGET_DATE=$(date -v-${i}d +%Y-%m-%d)
            else
                TARGET_DATE=$(date -d "-${i} days" +%Y-%m-%d)
            fi
            PREV_FILE=$(create_journal_entry "$TARGET_DATE" "$PREV_FILE")
        done
    fi
else
    # No previous journal found, just create today
    create_journal_entry "$TODAY" ""
fi

# Build today's file path and open
TODAY_YEAR=$(date +%Y)
TODAY_MONTH=$(date +%m)
TODAY_FILE="$JOURNAL_DIR/$TODAY_YEAR/$TODAY_MONTH/$TODAY.md"

$EDITOR_CMD "$TODAY_FILE"
