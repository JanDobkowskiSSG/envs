#!/bin/bash
# this should be availabe at https://raw.githubusercontent.com/JanDobkowskiSSG/envs/master/fmdi-dev-vm/setup.sh

set -x

# docker from docker repository
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

# git 
sudo apt-get install -y git 
git --version

# make git credentials storeable
sudo apt-get install -y libsecret-1-0 libsecret-1-dev gcc make
pushd /usr/share/doc/git/contrib/credential/libsecret
sudo make
popd
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret

#vscode
curl -L https://go.microsoft.com/fwlink/?LinkID=760868 > vscode.deb
sudo apt install ./vscode.deb
rm vscode.deb

code --install-extension golang.go

#go ext
code 

sudo apt-get install -y postgresql-client-13

#golang
sudo apt-get install -y golang

# Chromium
sudo apt-get install -y chromium-browser

echo "Finished. Remember to re-login to get docker execution privs."