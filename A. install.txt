#!/bin/bash

echo "[*] Installing required tools..."

tools=(subfinder assetfinder amass findomain chaos gau waybackurls httpx dnsx massdns masscan dalfox sqlmap nuclei)

for tool in "${tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "[+] Installing $tool..."
        go install github.com/projectdiscovery/$tool/v2/cmd/$tool@latest
    else
        echo "[✓] $tool is already installed."
    fi
done

echo "[*] Updating nuclei templates..."
nuclei -update-templates
