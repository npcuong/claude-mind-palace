#!/usr/bin/env bash
# review.sh — Surface REVIEW_DUE decisions, collect actual outcome + lesson.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CSV="$HOME/.local/share/decision-logger/decisions.csv"

if [ ! -f "$CSV" ]; then
    echo "No decisions.csv found. Run decide.sh first."
    exit 1
fi

# Always run check_reviews first so flags are up-to-date
"$DIR/check_reviews.sh"

python3 - "$CSV" <<'PY'
import csv, sys

BOLD  = '\033[1m'
CYAN  = '\033[36m'
YELLOW= '\033[33m'
GREEN = '\033[32m'
DIM   = '\033[2m'
RESET = '\033[0m'

csv_file = sys.argv[1]

with open(csv_file, 'r', newline='') as f:
    reader = csv.reader(f)
    header = next(reader)
    rows   = list(reader)

# Column indices
# 0:date 1:category 2:decision 3:reasoning 4:expected_outcome
# 5:review_date 6:status 7:actual_outcome 8:lesson

due = [(i, r) for i, r in enumerate(rows) if len(r) >= 7 and r[6] == 'REVIEW_DUE']

if not due:
    print(f"\n{GREEN}✓ Nothing due for review right now.{RESET}\n")
    sys.exit(0)

print(f"\n{BOLD}{CYAN}{'═'*54}{RESET}")
print(f"{BOLD}{CYAN}  {len(due)} Decision(s) Due for Review{RESET}")
print(f"{BOLD}{CYAN}{'═'*54}{RESET}")

for n, (row_idx, row) in enumerate(due):
    date_logged = row[0]
    category    = row[1].upper()
    decision    = row[2]
    reasoning   = row[3]
    expected    = row[4]

    print(f"\n{BOLD}[{n+1}/{len(due)}]  {date_logged}  ·  {CYAN}{category}{RESET}")
    print(f"  {BOLD}Decision :{RESET} {decision}")
    print(f"  {BOLD}Reasoning:{RESET} {reasoning}")
    print(f"  {BOLD}Expected :{RESET} {expected}")
    print(f"  {DIM}{'─'*50}{RESET}")

    actual = input(f"  {YELLOW}Actual outcome{RESET}: ").strip()
    lesson = input(f"  {YELLOW}Lesson learned{RESET}: ").strip()

    # Pad row if needed then update
    while len(rows[row_idx]) < 9:
        rows[row_idx].append('')
    rows[row_idx][6] = 'reviewed'
    rows[row_idx][7] = actual
    rows[row_idx][8] = lesson
    print()

with open(csv_file, 'w', newline='') as f:
    w = csv.writer(f)
    w.writerow(header)
    w.writerows(rows)

print(f"{GREEN}✓ {len(due)} review(s) saved.{RESET}\n")
PY
