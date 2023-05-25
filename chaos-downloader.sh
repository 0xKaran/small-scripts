#!/bin/bash

echo "[+] Making chaos directory"
mkdir -p chaos
cd chaos

# Download index.json
echo "[+] Downloading all zip files"
wget "https://chaos-data.projectdiscovery.io/index.json" -O index.json

# Extract URLs from index.json and download targets
grep -oP '(?<="URL": ")[^"]*' index.json | xargs -I{} wget {}

# Extract files from ZIP archives
echo "[+] Unzipping"
for i in *.zip; do
  unzip -o "$i"
done

# Concatenate all text files into a single file
echo "[+] Saving all domains in one text file"
cat *.txt | anew ../allchaostargets.txt

# Clean up
echo "[+] Everything deleted"
cd ..
rm -r chaos

totalcount=$(allchaostargets.txt | wc -l);
echo "[+] $totalcount total domains found"

# Live domains
echo "[+] Use axiom to extract live domains"
