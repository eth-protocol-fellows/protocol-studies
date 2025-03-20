#!/bin/bash

echo "Checking for typos..."
IFS=$'\n'
set -f
TYPOS=""

for file in $(find . -name "*.md"); do
  output="$(aspell --lang=en_US --mode=markdown --home-dir=. --personal=wordlist.txt --ignore-case=true --camel-case list <"$file")"
  echo "$output"

  # Exit if aspell has errors
  if [ $? -ne 0 ]; then
    exit 1
  fi

  if [[ -n "$output" ]]; then
    # Format output.
    output=$(echo "$output" | sed 's/^/    1. /')
    TYPOS+="- 📄 $file:"
    TYPOS+=$'\n'
    TYPOS+="$output"
    TYPOS+=$'\n'
  fi
done

echo "TYPOS:"
echo "$TYPOS"
chmod +x spellcheck.sh

