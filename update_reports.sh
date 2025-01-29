source .env

cd "$(dirname "$SCRIPT_PATH")"

echo "Starting Last.fm data fetch: $(date)" >> "$LOG_FILE"
python3 "$SCRIPT_PATH" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "Fetch successful, moving JSON files..." >> "$LOG_FILE"
    mv "$SOURCE_DIR"*.json "$DEST_DIR"

    if [ $? -eq 0 ]; then
        echo "Files moved successfully to $DEST_DIR" >> "$LOG_FILE"
    else
        echo "ERROR: Failed to move files!" >> "$LOG_FILE"
    fi
else
    echo "ERROR: Fetch script failed!" >> "$LOG_FILE"
fi

echo "Finished Last.fm data update: $(date)" >> "$LOG_FILE"
