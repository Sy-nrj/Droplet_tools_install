#!/bin/bash

set -euo pipefail

# Constants
RESOLVERS="resolvers.txt"
BASE_PATH="output"
OUTPUT_DIR="resolved"
RESOLVED_FILE="resolved.txt"

# Functions
resolve_domain() {
    local base_path="$1"
    local domain="$2"
    local subs_file="$base_path/$domain/subdomains/all_subs.txt"
    local resolved_dir="$base_path/$domain/$OUTPUT_DIR"

    if [ ! -f "$subs_file" ]; then
        echo "[!] Skipping $domain: Missing $subs_file"
        return
    fi

    echo "[*] Resolving subdomains for $domain"
    mkdir -p "$resolved_dir"

    # DNSX
    dnsx -l "$subs_file" -silent -r "$RESOLVERS" -o "$resolved_dir/dnsx_resolved.txt"

    # PureDNS
    puredns resolve "$subs_file" -r "$RESOLVERS" --write "$resolved_dir/puredns_resolved.txt" --quiet

    # MassDNS
    massdns -r "$RESOLVERS" -t A -o S -w "$resolved_dir/massdns.txt" "$subs_file"

    # Aggregate all results
    {
        cat "$resolved_dir/dnsx_resolved.txt" 2>/dev/null
        cat "$resolved_dir/puredns_resolved.txt" 2>/dev/null
        cut -d ' ' -f1 "$resolved_dir/massdns.txt" 2>/dev/null
    } | sort -u > "$resolved_dir/$RESOLVED_FILE"

    echo "[✓] Resolution complete for $domain"
}

scan_open_ports() {
    local base_path="$1"
    local domain="$2"
    local resolved_dir="$base_path/$domain/$OUTPUT_DIR"
    local open_ports_dir="$base_path/$domain/open_ports"
    local massdns_output="$resolved_dir/massdns.txt"

    echo "[*] Extracting IPs for port scanning for $domain..."
    mkdir -p "$open_ports_dir"

    if [ ! -f "$massdns_output" ]; then
        echo "[!] Skipping port scan for $domain: Missing $massdns_output"
        return
    fi

    cut -d ' ' -f3 "$massdns_output" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort -u > "$open_ports_dir/ips.txt"

    if [ -s "$open_ports_dir/ips.txt" ]; then
        echo "[*] Scanning all ports for IPs in $domain..."
        masscan -p1-65535 -iL "$open_ports_dir/ips.txt" --rate=1000 -oG "$open_ports_dir/masscan.grep"

        awk '/^Host: / { ip=$2; split($4, portinfo, "/"); print ip ":" portinfo[1] }' "$open_ports_dir/masscan.grep" | sort -u > "$open_ports_dir/open_ports.txt"

        echo "[✓] Ports scanned for $domain — results in $open_ports_dir/open_ports.txt"
    else
        echo "[!] No valid IPs found to scan for $domain"
    fi
}

# Main Execution
if [ $# -eq 0 ]; then
    echo "[*] No input provided — scanning all folders under $BASE_PATH"
    for d in "$BASE_PATH"/*; do
        [ -d "$d" ] || continue
        folder=$(basename "$d")
        resolve_domain "$BASE_PATH" "$folder"
        scan_open_ports "$BASE_PATH" "$folder"
    done
else
    for domain in "$@"; do
        resolve_domain "$BASE_PATH" "$domain"
        scan_open_ports "$BASE_PATH" "$domain"
    done
fi

echo "[✓] All domains processed successfully."
