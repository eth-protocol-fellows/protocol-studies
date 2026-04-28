#!/bin/bash

# Ensure TYPOS variable is empty to start
TYPOS=""

echo "🔍 Checking for typos..."

# Use -v to ensure aspell is installed before running
if ! command -v aspell &>/dev/null; then
  echo "❌ Error: 'aspell' is not installed. (Hint: brew install aspell / apt install aspell)"
  exit 1
fi

# Set Internal Field Separator to handle filenames with spaces
IFS=$'\n'
set -f

for file in $(find . -name "*.md"); do
  if [ ! -s "$file" ]; then
    continue
  fi

  echo "Reading: $file"

  # Get typos list from aspell
  output="$(aspell list --lang=en_US --mode=markdown --home-dir=. --personal=./wordlist.txt --ignore-case=true --camel-case --add-sgml-skip name list <"$file")"

  if [ $? -eq 0 ]; then
    if [[ -n "$output" ]]; then
      # Use sort -u to avoid repeating the same word multiple times
      unique_typos=$(echo "$output" | sort -u)

      while read -r word; do
        # Find line numbers
        line_nums=$(grep -nwi "$word" "$file" | cut -d: -f1 | tr '\n' ',' | sed 's/,$//')

        TYPOS+="- 📄 $file (line(s) $line_nums):"$'\n'
        TYPOS+="    ❌ $word"$'\n'
      done <<<"$unique_typos"
    fi
  else
    echo "::error::aspell failed on $file"
    exit 1
  fi
done

# Output the results to the terminal
if [[ -z "$TYPOS" ]]; then
  echo "✅ No typos found!"
else
  echo -e "\n--- Spelling Report ---\n"
  echo "$TYPOS"
fi
