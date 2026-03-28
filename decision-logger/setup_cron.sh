#!/usr/bin/env bash
# setup_cron.sh — One-time setup: registers check_reviews.sh as a daily cron job at 08:00.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$DIR/check_reviews.sh"
LOG="$DIR/cron.log"

if [ ! -x "$SCRIPT" ]; then
    echo "Making scripts executable..."
    chmod +x "$DIR"/*.sh
fi

CRON_JOB="0 8 * * * $SCRIPT >> $LOG 2>&1"

if crontab -l 2>/dev/null | grep -qF "$SCRIPT"; then
    echo "✓ Cron job already registered."
    echo ""
    crontab -l | grep "$SCRIPT"
else
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "✓ Cron job added — runs daily at 08:00."
    echo "  Script : $SCRIPT"
    echo "  Log    : $LOG"
fi

echo ""
echo "Current crontab:"
crontab -l
