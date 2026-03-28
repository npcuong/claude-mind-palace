#!/usr/bin/env bash
# check_reviews.sh — Run daily via cron. Flags decisions whose review date has arrived.
set -euo pipefail

CSV="$HOME/.local/share/decision-logger/decisions.csv"

[ ! -f "$CSV" ] && exit 0

python3 - "$CSV" <<'PY'
import csv, sys
from datetime import date

csv_file = sys.argv[1]
today    = date.today().isoformat()

with open(csv_file, 'r', newline='') as f:
    reader = csv.reader(f)
    header = next(reader)
    rows   = list(reader)

# Column indices
# 0:date 1:category 2:decision 3:reasoning 4:expected_outcome
# 5:review_date 6:status 7:actual_outcome 8:lesson

flagged = 0
for row in rows:
    if len(row) >= 7:
        review_date = row[5]
        status      = row[6]
        if status == 'open' and review_date <= today:
            row[6] = 'REVIEW_DUE'
            flagged += 1

with open(csv_file, 'w', newline='') as f:
    w = csv.writer(f)
    w.writerow(header)
    w.writerows(rows)

if flagged:
    print(f"[{today}] ⚑  Flagged {flagged} decision(s) as REVIEW_DUE")
else:
    print(f"[{today}] ✓  No new reviews due today")
PY
