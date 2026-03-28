#!/usr/bin/env bash
# stats.sh — Show decision stats broken down by category and status.
set -euo pipefail

CSV="$HOME/.local/share/decision-logger/decisions.csv"

if [ ! -f "$CSV" ]; then
    echo "No decisions.csv found. Run decide.sh first."
    exit 1
fi

python3 - "$CSV" <<'PY'
import csv, sys
from collections import Counter, defaultdict

BOLD  = '\033[1m'
CYAN  = '\033[36m'
GREEN = '\033[32m'
YELLOW= '\033[33m'
RED   = '\033[31m'
DIM   = '\033[2m'
RESET = '\033[0m'

STATUS_COLOUR = {
    'open':       GREEN,
    'REVIEW_DUE': YELLOW,
    'reviewed':   DIM,
}

csv_file = sys.argv[1]

with open(csv_file, 'r', newline='') as f:
    reader = csv.reader(f)
    next(reader)  # skip header
    rows = [r for r in reader if len(r) >= 7]

if not rows:
    print("No decisions logged yet.")
    sys.exit(0)

total      = len(rows)
by_cat     = Counter(r[1] for r in rows)
by_status  = Counter(r[6] for r in rows)
reviewed   = [r for r in rows if r[6] == 'reviewed']
due        = sum(1 for r in rows if r[6] == 'REVIEW_DUE')

# Category × status breakdown
cat_status = defaultdict(Counter)
for r in rows:
    cat_status[r[1]][r[6]] += 1

print(f"\n{BOLD}{CYAN}{'═'*48}{RESET}")
print(f"{BOLD}{CYAN}  Decision Stats  ·  {total} total{RESET}")
print(f"{BOLD}{CYAN}{'═'*48}{RESET}\n")

# ── By category ──────────────────────────────────
print(f"{BOLD}By category:{RESET}")
max_count = max(by_cat.values(), default=1)
for cat, count in by_cat.most_common():
    bar    = '█' * count
    pct    = int(count / total * 100)
    r_due  = cat_status[cat].get('REVIEW_DUE', 0)
    flag   = f" {YELLOW}⚑{RESET}" if r_due else ""
    print(f"  {cat:<12} {CYAN}{bar:<{max_count}}{RESET}  {count:>2}  ({pct}%){flag}")

# ── By status ────────────────────────────────────
print(f"\n{BOLD}By status:{RESET}")
for status, count in by_status.most_common():
    colour = STATUS_COLOUR.get(status, RESET)
    print(f"  {colour}{status:<15}{RESET}  {count}")

# ── Accuracy if reviews exist ─────────────────────
if reviewed:
    print(f"\n{BOLD}Reviewed decisions:{RESET}  {len(reviewed)}")
    print(f"{DIM}  (Check decisions.csv for actual_outcome and lesson columns){RESET}")

if due:
    print(f"\n{YELLOW}⚑  {due} decision(s) flagged REVIEW_DUE — run review.sh{RESET}")

print()
PY
