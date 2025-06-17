#!/bin/bash

INPUT="output/resolved/resolved.txt"
OUTPUT_DIR="output/assets"
mkdir -p "$OUTPUT_DIR"

if [ ! -f "$INPUT" ]; then
    echo "[-] Input resolved subdomains not found!"
    exit 1
fi

# Collect endpoints from historical data
cat "$INPUT" | gau > "$OUTPUT_DIR/gau_urls.txt"
cat "$INPUT" | waybackurls > "$OUTPUT_DIR/waymore_urls.txt"
cat "$INPUT" | katana -d 5 -jc -kf all -em js,url -silent > "OUTPUT_DIR/katana.txt"


# Extract JS files
grep "\.js" "$OUTPUT_DIR/gau_urls.txt" "$OUTPUT_DIR/waymore_urls.txt" "OUTPUT_DIR/katana.txt" | sort -u > "$OUTPUT_DIR/js_files.txt"

# Extract potential parameters
cat "$OUTPUT_DIR/gau_urls.txt" "$OUTPUT_DIR/wbm_urls.txt" | grep "?" | cut -d '?' -f2 | tr '&' '\n' | cut -d '=' -f1 | sort -u > "$OUTPUT_DIR/params.txt"

echo "[✓] Asset discovery complete."
echo "    JS Files: $OUTPUT_DIR/js_files.txt"
echo "    Params: $OUTPUT_DIR/params.txt"
