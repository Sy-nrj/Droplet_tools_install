#!/bin/bash

# Usage:
# bash C_Subdomain_enumeration.sh example.com
# bash C_Subdomain_enumeration.sh input/targets.txt

set -e

OUTPUT_DIR="output/subdomains"
TMP_DIR="output/tmp"

mkdir -p "$OUTPUT_DIR" "$TMP_DIR"

# Check if a domain or a file was provided
INPUT=$1
if [ -z "$INPUT" ]; then
    echo "[-] Usage: $0 <domain|file_with_domains>"
    exit 1
fi

# Determine if input is a file or a single domain
if [ -f "$INPUT" ]; then
    TARGETS=$(cat "$INPUT")
elif [[ "$INPUT" =~ ^[a-zA-Z0-9.-]+$ ]]; then
    TARGETS="$INPUT"
else
    echo "[-] Invalid input. Provide a domain (e.g., example.com) or a file path."
    exit 1
fi

ENUM_SUBDOMAINS() {
    local domain=$1
    echo "[*] Enumerating subdomains for: $domain"
    
    {
        subfinder -d "$domain" -silent 2>/dev/null
        assetfinder --subs-only "$domain" 2>/dev/null
        amass enum -passive -d "$domain" 2>/dev/null
        sublist3r -d "$domain" 2>/dev/null
        gospider -s "http://$domain" -o "$TMP_DIR" 2>/dev/null
        gau --subs "$domain" 2>/dev/null
        curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' 2>/dev/null
    } | sed 's/^www\.//' | sort -u
}

ALL_RESULTS="$OUTPUT_DIR/all_subdomains.txt"
> "$ALL_RESULTS"

for target in $TARGETS; do
    ENUM_SUBDOMAINS "$target"
done | sort -u >> "$ALL_RESULTS"

echo "[✓] Subdomain enumeration complete. Results saved to: $ALL_RESULTS"
