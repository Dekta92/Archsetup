mkdir -p "$HOME/.config/log"
LOG_FILE="$HOME/.config/log/updateFail.log"
CURRENT_WEEK=$(date +%U)
LAST_WEEK_FILE="$HOME/.config/log/last_week_update"

if [ ! -f "$LAST_WEEK_FILE" ] || [ "$(cat "$LAST_WEEK_FILE")" != "$CURRENT_WEEK" ]; then
    sudo pacman -Syu --noconfirm 2>&1 | tee "$LOG_FILE"
    if [ $? -eq 0 ]; then
        notify-send "System Update" "System update completed successfully!"
        echo "$CURRENT_WEEK" > "$LAST_WEEK_FILE"
        : > "$LOG_FILE"
    else
        notify-send "System Update" "System update failed! Check the log at $LOG_FILE"
    fi
fi
