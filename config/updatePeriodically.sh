#!/bin/bash

notify-send "Updating mirror list..."
# Temporary file for reflector output
TEMP_FILE="/etc/pacman.d/mirrorlist-replace"

sudo reflector --latest 20 --sort rate --save "$TEMP_FILE"
if [ $? -ne 0 ]; then
    # If reflector fails, send a failure notification
    notify-send "Mirrorlist Update" "Failed to update the mirrorlist!"
    exit
fi

# If reflector succeeds, replace the main mirrorlist
sudo mv "$TEMP_FILE" /etc/pacman.d/mirrorlist
notify-send "Mirrorlist Update" "Mirrorlist successfully updated!"
