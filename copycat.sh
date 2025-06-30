#!/bin/bash

# Developed by Air

# Function to detect external drives
detect_drives(){
    echo "Detecting external drives mounted under /media or /mnt..."
    mapfile -t drives < <(find /media /mnt 2>/dev/null -mindepth 2 -maxdepth 2 -type d)
    
    if [ "${#drives[@]}" -eq 0 ]; then
        echo "No external drives detected!"
        return 1
    fi

    echo "Found the following external drives:"
    for i in "${!drives[@]}"; do
        echo "[$i] ${drives[$i]}"
    done

    return 0
}

# Prompt for source directory
read -rp "Enter the path to the source directory (for example: ~/Documents): " SOURCE_DIR

# Expand ~ to home directory if present at the start
if [[ "$SOURCE_DIR" == ~* ]]; then
    SOURCE_DIR="${SOURCE_DIR/#\~/$HOME}"
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory does not exist."
    exit 1
fi


