#!/bin/bash
# this should be availabe at https://raw.githubusercontent.com/JanDobkowskiSSG/envs/master/fmdi-dev-vm/setup.sh

set -x

# stop unattended upgrades not to interfere
sudo systemctl stop unattended-upgrades

# remove unattended upgrades - we're big boys aren't we we handle it ourselves
sudo apt-get -y purge unattended-upgrades

# docker from docker's own repository
sudo apt-get remove docker docker.io containerd runc 
sudo apt-get update
sudo apt-get install -y curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --batch --yes -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -a -G docker dev

# docker-compose
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose


# kubernetes
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# git 
sudo apt-get install -y git 
git --version

# make git credentials storeable
sudo apt-get install -y libsecret-1-0 libsecret-1-dev gcc make
pushd /usr/share/doc/git/contrib/credential/libsecret
sudo make
popd
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret

#golang
sudo apt-get install -y golang

# vscode go ext wants these
go install -v github.com/rogpeppe/godef@latest
go install -v github.com/ramya-rao-a/go-outline@latest
go install -v golang.org/x/tools/gopls@latest
go install -v github.com/go-delve/delve/cmd/dlv@latest

#vscode
curl -L https://go.microsoft.com/fwlink/?LinkID=760868 > vscode.deb
sudo apt install ./vscode.deb
rm vscode.deb

#go ext
code --install-extension golang.go

#psql
sudo apt-get install -y postgresql-client-13

# Postman
sudo snap install postman

# GoLand
sudo apt-get install default-jre

wget https://download.jetbrains.com/go/goland-2021.3.3.tar.gz
tar xfz goland-2021.3.3.tar.gz 
rm goland-2021.3.3.tar.gz
pushd GoLand-2021.3.3
popd

# Beekeeper
wget --quiet -O - https://deb.beekeeperstudio.io/beekeeper.key | sudo apt-key add -
echo "deb https://deb.beekeeperstudio.io stable main" | sudo tee /etc/apt/sources.list.d/beekeeper-studio-app.list
sudo apt update
sudo apt install beekeeper-studio

#set
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/Way_by_Kacper_%C5%9Alusarczyk.jpg'

# node, yarn
curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo corepack enable

# Chromium
sudo apt-get install -y chromium-browser


# Setup launcher icons
gsettings set org.gnome.shell favorite-apps "['chromium_chromium.desktop', 'postman_postman.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']"

#disable lock
gsettings set org.gnome.desktop.lockdown disable-lock-screen true
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false

#hide dock 
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false

#and home icon
gsettings set org.gnome.shell.extensions.ding show-home  false

# more nerdish
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'

mkdir ~/repos
cd ~/repos
echo "Finished. Remember to re-login to get docker execution privs."


