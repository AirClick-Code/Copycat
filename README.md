# Copycat

This is a simple Bash script to automate backing up to an external drive.

## Features

- Detects mounted external drives under `/media` or `/mnt`
- Supports selecting or entering a custom destination
- Creates a compressed `.tar.gz` archive with a timestamp
- Handles paths with spaces and `~` expansion
- Support Tab completion for file and directory paths

## Note
Make sure your external drive is mounted and accessible under /media or /mnt.
