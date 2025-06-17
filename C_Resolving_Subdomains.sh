#!/bin/bash

INPUT="output/subdomains/all_subdomains.txt"

# Creating a list of resolvers
curl -s https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt -o resolvers.txt

RESOLVERS="resolvers.txt"  # Make sure this exists
OUTPUT_DIR="output/resolved"
mkdir -p "$OUTPUT_DIR"

if [ ! -f "$INPUT" ]; then
    echo "[-] Input subdomains file not found!"
    exit 1
fi

if [ ! -f "$RESOLVERS" ]; then
    echo "[-] Resolvers list missing!"
    exit 1
fi

dnsx -l "$INPUT" -silent -resolvers "$RESOLVERS" -o "$OUTPUT_DIR/resolved.txt"
massdns -r "$RESOLVERS" -t A -o S -w "$OUTPUT_DIR/massdns.txt" "$INPUT"

cat '$OUTPUT_DIR/resolved.txt' $OUTPUT_DIR/massdns.txt | sort -u $OUTPUT_DIR/resolved.txt

cut -d ' ' -f3 "$OUTPUT_DIR/massdns.txt" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort -u > "$OUTPUT_DIR/ips.txt"

echo "[✓] DNS resolution complete. Results in $OUTPUT_DIR"

# Scanning for open ports
masscan -p1-65535 -iL "$OUTPUT_DIR/ips.txt" --rate=1000 -oG .$OUTPUT_DIR/masscan_resolved.txt
