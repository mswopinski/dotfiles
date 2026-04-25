#!/bin/bash
input=$(cat)

# Colors (Catppuccin Macchiato)
PEACH='\033[38;2;245;169;127m'
LAVENDER='\033[38;2;183;189;248m'
GREEN='\033[38;2;166;218;149m'
YELLOW='\033[38;2;238;212;159m'
MAUVE='\033[38;2;198;160;246m'
RED='\033[38;2;237;135;150m'
OVERLAY='\033[38;2;110;115;141m'
RESET='\033[0m'

# Parse values
MODEL=$(echo "$input" | jq -r '.model.display_name // "unknown"')
CTX_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
RATE_5H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0' | cut -d. -f1)
RATE_7D=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0' | cut -d. -f1)
STYLE=$(echo "$input" | jq -r '.output_style.name // ""')

# Color based on usage percentage
usage_color() {
  local pct=$1
  if [ "$pct" -ge 80 ]; then echo "$RED"
  elif [ "$pct" -ge 50 ]; then echo "$YELLOW"
  else echo "$GREEN"
  fi
}

CTX_COLOR=$(usage_color "$CTX_PCT")
RATE_5H_COLOR=$(usage_color "$RATE_5H")
RATE_7D_COLOR=$(usage_color "$RATE_7D")

# Build output
OUT="${MAUVE}${MODEL}${RESET}"
OUT+=" ${OVERLAY}│${RESET} "
OUT+="${OVERLAY}ctx ${RESET}${CTX_COLOR}${CTX_PCT}%${RESET}"
OUT+=" ${OVERLAY}│${RESET} "
OUT+="${OVERLAY}5hr ${RESET}${RATE_5H_COLOR}${RATE_5H}%${RESET}"
OUT+=" ${OVERLAY}7d ${RESET}${RATE_7D_COLOR}${RATE_7D}%${RESET}"

if [ -n "$STYLE" ]; then
  OUT+=" ${OVERLAY}│${RESET} ${LAVENDER}${STYLE}${RESET}"
fi

echo -e "$OUT"
