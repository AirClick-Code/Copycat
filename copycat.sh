#!/bin/bash

# Developed by Air

# Function to detect external drives
detect_drives(){
    echo "Detecting external drives mounted under /media or /mnt..."
    mapfile -t drives < <(find /media /mnt 2>/dev/null -mindepth 1 -maxdepth 2 -type d)
    
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

detect_drives
