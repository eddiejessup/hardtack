#! /bin/bash

case "$OSTYPE" in
# Mac
darwin*)
    HISTORY_LOC=~/"Library/Application Support/Google/Chrome/Default/History"
    ;;
linux-gnu)
    HISTORY_LOC=~/".config/google-chrome/History"
    ;;
esac
HISTORY_TEMP_LOC="$HISTORY_LOC.temp"

# Make a copy of the History database to work with
cp "$HISTORY_LOC" "$HISTORY_TEMP_LOC"

# Get the page titles and redirect them into history.log
sqlite3 "$HISTORY_TEMP_LOC" 'select title from urls;' > history.log

# We're done with the database now, remove the temporary copy
rm "$HISTORY_TEMP_LOC"

# Parse the page titles to find what we want and format nicely
cat history.log | grep 'Wikipedia, the free encyclopedia' \
| grep -v -e "(disambiguation)" -e "File:" -e "Talk:" -e "Search results" \
| sed 's_ - Wikipedia, the free encyclopedia__' | uniq | perl -e 'print reverse <>' > wikis.txt

# Done with the page title list now, remove it
rm history.log
