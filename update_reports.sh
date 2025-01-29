#!/bin/bash

source ~/dev/lastfm_grabber/.env

echo "Starting Last.fm data fetch: $(date)" >> "$LOG_FILE"
python3 "$SCRIPT_PATH" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "Fetch successful, moving JSON files..." >> "$LOG_FILE"
    mv "$SOURCE_DIR"*.json "$PROJECT_DIR"_data/

    if [ $? -eq 0 ]; then
        echo "Files moved successfully. Rebuilding Jekyll site..." >> "$LOG_FILE"
        
        cd "$PROJECT_DIR"
        bundle exec jekyll build >> "$LOG_FILE" 2>&1

        if [ $? -eq 0 ]; then
            echo "Jekyll build completed successfully, moving static files to hosting dir" >> "$LOG_FILE"
            rsync -av --delete "$PROJECT_DIR"_site/ "$DEST_DIR"
        else
            echo "ERROR: Jekyll build failed!" >> "$LOG_FILE"
        fi
    else
        echo "ERROR: Failed to move JSON files!" >> "$LOG_FILE"
    fi
else
    echo "ERROR: Fetch script failed!" >> "$LOG_FILE"
fi

# Keep only the last 500 lines of log to prevent excessive growth
# ChatGPT recommended this one, maybe prevents a headache in a year's time ¯\_(ツ)_/¯

tail -n 500 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
echo "Finished Last.fm data update: $(date)" >> "$LOG_FILE"
