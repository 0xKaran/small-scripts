#!/bin/bash

# Color
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\033[0;33m"
ENDCOLOR="\e[0m"

# Define constants
CHAOS_DIR="chaos"
INDEX_URL="https://chaos-data.projectdiscovery.io/index.json"
ALL_TARGETS_FILE="../allchaostargets.txt"

# Function to download and process data
download_and_process() {
  # Create chaos directory if it doesn't exist
  mkdir -p "$CHAOS_DIR"
  cd "$CHAOS_DIR" || exit 1

  # Download index.json
  echo -e "${GREEN}[+] Making chaos directory${ENDCOLOR}"
  echo -e "${GREEN}[+] Downloading index.json${ENDCOLOR}"
  wget "$INDEX_URL" -O index.json

  # Extract URLs from index.json and download targets
  echo -e "${GREEN}[+] Downloading all zip files${ENDCOLOR}"
  grep -oP '(?<="URL": ")[^"]*' index.json | xargs -I{} wget {}

  # Extract files from ZIP archives
  echo -e "${GREEN}[+] Unzipping${ENDCOLOR}"
  for zip_file in *.zip; do
    unzip -o "$zip_file"
  done

  # Concatenate all text files into a single file
  echo -e "${GREEN}[+] Saving all domains in one text file${ENDCOLOR}"
  cat *.txt | anew "$ALL_TARGETS_FILE"

  # Clean up
  echo -e "${GREEN}[+] Cleaning up${ENDCOLOR}"
  cd ..
  rm -r "$CHAOS_DIR"
}

# Execute the download and processing function
download_and_process

# Count and display the total number of domains found
totalcount=$(wc -l < "$ALL_TARGETS_FILE")
echo -e "${GREEN}[+] $totalcount total domains found${ENDCOLOR}"

# Additional instructions
echo -e "${GREEN}[+] Use axiom to extract live domains${ENDCOLOR}"
