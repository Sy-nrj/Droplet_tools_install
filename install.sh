#! /bin/bash

cd ~
mkdir -p recon/{tools,results,scripts}  && cd recon/tools
sudo apt install golang-go -y 
sudo apt install git curl make gcc jq python3 python3-pip snapd wget unzip pipx ruby ruby-dev build-essential libgems2.7 
go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
go install github.com/d3mondev/puredns/v2@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/defparam/paramspider@latest
go install github.com/ffuf/ffuf/v2@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/gwen001/github-subdomains@latest
go install github.com/g0ldencybersec/gungnir/cmd/gungnir@latest
go install github.com/lc/subjs@latest
go install github.com/tomnomnom/anew@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/rverton/webanalyze/cmd/webanalyze@latest
go install github.com/BishopFox/jsluice/cmd/jsluice@latest
go install github.com/Nemesis0U/JSRecon@latest


# Installing Cewl
sudo apt install ruby ruby-dev build-essential libcurl4-openssl-dev -y
git clone https://github.com/digininja/CeWL.git
cd CeWL
sudo gem install bundler
bundle install
sudo gem install nokogiri
chmod u+x ./cewl.rb
sudo apt install cewl


# Go_spider
sudo GO111MODULE=on go install github.com/jaeles-project/gospider@latest

sudo snap install seclists -y
sudo apt install sublist3r -y
sudo snap install amass -y


# Waymore
pipx install git+https://github.com/xnl-h4ck3r/waymore.git

# xnlinkFinder

pipx install git+https://github.com/xnl-h4ck3r/xnLinkFinder.git

# Paramspider
git clone https://github.com/devanshbatham/paramspider
cd paramspider
pip install . && cd ..


#  Masscan

sudo apt-get --assume-yes install git make gcc
git clone https://github.com/robertdavidgraham/masscan
cd masscan && make && cd ..

# Webanalyze

git clone https://github.com/rverton/webanalyze.git
cd webanalyze && go build && sudo cp webanalyze /usr/bin && cd ..


#  Masscan
git clone https://github.com/blechschmidt/massdns.git
cd massdns && make && sudo cp bin/massdns /usr/local/bin/  && cd ..

sudo mkdir -p /usr/bin/go

sudo cp -r ~/go/bin /usr/local/bin
