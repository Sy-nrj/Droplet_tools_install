#! /bin/bash

cd 
mkdir -p recon/{tools,results,scripts}  && cd recon/tools

sudo apt update && sudo apt upgrade -y
sudo apt install -y golang-go git curl ruby-rubygems make gcc jq python3 python3-pip snpad    pipx
go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/waymore/waymore/cmd/waymore@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/jaeles-project/gospider/cmd/gospider@latest
go install github.com/defparam/paramspider@latest
go install github.com/ffuf/ffuf/v2@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/gwen001/github-subdomains@latest
go install github.com/g0ldencybersec/gungnir/cmd/gungnir@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/lc/subjs@latest
go install github.com/tomnomnom/anew@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/d3mondev/puredns/v2@latest


gem install xxx
gem install cewl


sudo snap install seclists

sudo snap install amass

# Waymore
pipx install git+https://github.com/xnl-h4ck3r/waymore.git

#  Masscan
sudo apt-get --assume-yes install git make gcc
git clone https://github.com/robertdavidgraham/masscan
cd masscan && make && cd ..

#  Mass
git clone https://github.com/blechschmidt/massdns.git
cd massdns && make && sudo cp bin/massdns /usr/local/bin/  && cd ..


sudo cp ~/go/bin /usr/bin/go