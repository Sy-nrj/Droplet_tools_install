#!/bin/bash

INPUT="input/targets.txt"
OUTPUT_DIR="output/subdomains"
TMP="output/tmp"
mkdir -p "$OUTPUT_DIR" "$TMP" 

check_input() {
    if [ ! -f "$INPUT" ]; then
        echo "[-] $INPUT not found. Create it with your target(s)."
        exit 1
    fi
}

run_sub_enum() {
    while read -r target; do
        echo "[*] Enumerating subdomains for $target"
        subfinder -d "$target" -silent
        assetfinder --subs-only "$target"
        amass enum -passive -d "$target"
        sublist3r -d "$target" 
        gospider -s $target
        gau --subs $target 
	curl -s "https://crt.sh/?q=%25.$target&output=json" | jq -r '.[].name_value' 

    done < "$INPUT"
}

check_input

run_sub_enum | sort -u > "$OUTPUT_DIR/all_subdomains.txt"
echo "[✓] Subdomain enumeration complete. Saved to $OUTPUT_DIR/all_subdomains.txt"
