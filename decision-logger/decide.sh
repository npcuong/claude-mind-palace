#!/usr/bin/env bash
# decide.sh — Log a new decision interactively
set -euo pipefail

CSV="$HOME/.local/share/decision-logger/decisions.csv"
mkdir -p "$HOME/.local/share/decision-logger"

# ── Colours ────────────────────────────────────────────────────────────────
BOLD='\033[1m'; CYAN='\033[36m'; GREEN='\033[32m'; RESET='\033[0m'

# ── Init CSV with header if missing ────────────────────────────────────────
if [ ! -f "$CSV" ]; then
    python3 - "$CSV" <<'PY'
import csv, sys
with open(sys.argv[1], 'w', newline='') as f:
    csv.writer(f).writerow([
        'date','category','decision','reasoning',
        'expected_outcome','review_date','status','actual_outcome','lesson'
    ])
PY
    echo -e "${GREEN}Created decisions.csv${RESET}"
fi

# ── Dates ───────────────────────────────────────────────────────────────────
TODAY=$(date +%Y-%m-%d)
REVIEW_DATE=$(date -v +30d +%Y-%m-%d 2>/dev/null || date -d "+30 days" +%Y-%m-%d)

# ── UI ──────────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}${CYAN}=== Decision Logger ===${RESET}\n"

echo -e "${BOLD}Category:${RESET}"
CATEGORIES=("career" "finance" "tech" "personal" "health" "other")
for i in "${!CATEGORIES[@]}"; do
    echo "  $((i+1))) ${CATEGORIES[$i]}"
done
read -rp "Choose (1-6): " cat_num

# Validate input, default to "other"
if [[ "$cat_num" =~ ^[1-6]$ ]]; then
    CATEGORY="${CATEGORIES[$((cat_num-1))]}"
else
    CATEGORY="other"
fi

echo ""
read -rp "Decision — what are you deciding: " DECISION
echo ""
read -rp "Reasoning — why: " REASONING
echo ""
read -rp "Expected outcome — what you hope happens: " EXPECTED
echo ""

# ── Write row via Python (safe CSV quoting) ────────────────────────────────
DECISION="$DECISION" REASONING="$REASONING" EXPECTED="$EXPECTED" \
python3 - "$CSV" "$TODAY" "$CATEGORY" "$REVIEW_DATE" <<'PY'
import csv, os, sys

csv_file, today, category, review_date = sys.argv[1:]

row = [
    today,
    category,
    os.environ['DECISION'],
    os.environ['REASONING'],
    os.environ['EXPECTED'],
    review_date,
    'open',
    '',
    ''
]

with open(csv_file, 'a', newline='') as f:
    csv.writer(f).writerow(row)

print(f"\n\033[32m✓ Decision logged.\033[0m")
print(f"  Category    : {category}")
print(f"  Date        : {today}")
print(f"  Review due  : {review_date}\n")
PY
