#!/bin/bash

# Developed by Air

# Detect mounted external drives under /media or /mnt
detect_external_drives() {
    echo "Detecting external drives mounted under /media or /mnt..."
    mapfile -t drives < <(find /media /mnt -mindepth 1 -maxdepth 2 -type d 2>/dev/null)

    if [ ${#drives[@]} -eq 0 ]; then
        echo "No external drives detected."
        return 1
    fi

    echo "Found the following external drives:"
    for i in "${!drives[@]}"; do
        echo "[$i] ${drives[$i]}"
    done

    return 0
}

# Prompt for source directory
read -rp "Enter the path to the source directory (e.g., ~/Documents): " SOURCE_DIR

# Expand ~ if used
if [[ "$SOURCE_DIR" == ~* ]]; then
    SOURCE_DIR="${SOURCE_DIR/#\~/$HOME}"
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory does not exist."
    exit 1
fi

# Detect drives and choose destination
if detect_external_drives; then
    echo "Enter the number of the external drive to store the archive,"
    echo "or press Enter to manually specify a different directory."
    read -rp "Choice: " choice

    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 0 ] && [ "$choice" -lt "${#drives[@]}" ]; then
        BASE_DEST_DIR="${drives[$choice]}"
        read -rp "Enter a subdirectory name or press Enter to use root of $BASE_DEST_DIR: " SUBDIR
        if [ -n "$SUBDIR" ]; then
            DEST_DIR="$BASE_DEST_DIR/$SUBDIR"
        else
            DEST_DIR="$BASE_DEST_DIR"
        fi
    else
        read -rp "Enter full path to the destination directory: " DEST_DIR
    fi
else
    read -rp "Enter full path to the destination directory: " DEST_DIR
fi

# Expand ~ in DEST_DIR if present
if [[ "$DEST_DIR" == ~* ]]; then
    DEST_DIR="${DEST_DIR/#\~/$HOME}"
fi

if [ ! -d "$DEST_DIR" ]; then
    echo "Destination directory does not exist. Create it? [y/N]"
    read -r create
    if [[ "$create" =~ ^[Yy]$ ]]; then
        mkdir -p "$DEST_DIR" || { echo "Failed to create destination."; exit 1; }
    else
        echo "Aborting."
        exit 1
    fi
fi

# Generate archive name
ARCHIVE_NAME="$(basename "$SOURCE_DIR")_$(date +%Y%m%d).tar.gz"
ARCHIVE_PATH="$DEST_DIR/$ARCHIVE_NAME"

# Create archive directly on external drive
echo "Creating archive at: $ARCHIVE_PATH"
tar -czf "$ARCHIVE_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

if [ $? -eq 0 ]; then
    echo "Archive successfully created: $ARCHIVE_PATH"
else
    echo "Error: Failed to create archive."
    exit 1
fi
