#!/usr/bin/env bash
# Claude Code statusline: token usage and quota display

input=$(cat)

# --- Context window usage ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

# --- Rate limits (claude.ai subscription) ---
five_hr=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# --- Model ---
model=$(echo "$input" | jq -r '.model.display_name // empty')

parts=()

# Model name
[ -n "$model" ] && parts+=("$model")

# Context window usage
if [ -n "$used_pct" ] && [ -n "$ctx_size" ]; then
  ctx_k=$(echo "$ctx_size" | awk '{printf "%dk", $1/1000}')
  parts+=("ctx: $(printf '%.0f' "$used_pct")% of $ctx_k")
elif [ -n "$used_pct" ]; then
  parts+=("ctx: $(printf '%.0f' "$used_pct")%")
fi

# Rate limits (only shown when present, i.e. claude.ai subscribers)
rate_parts=()
[ -n "$five_hr" ] && rate_parts+=("5h: $(printf '%.0f' "$five_hr")%")
[ -n "$seven_day" ] && rate_parts+=("7d: $(printf '%.0f' "$seven_day")%")
[ ${#rate_parts[@]} -gt 0 ] && parts+=("$(IFS=' '; echo "${rate_parts[*]}")")

# Join with separator
result=""
for part in "${parts[@]}"; do
  [ -n "$result" ] && result="$result | "
  result="$result$part"
done
printf '%s' "$result"
