#!/bin/bash

if [ "$#" == 0 ] 
then
  echo "must provide the user's home"
  exit
fi

# we need the user's home directory in order to easily install and configure zsh
users_home=$1

# we need to add the user to `docker` group
user=${users_home##*/}

# note: the order matters

function format_output {
  echo -e "\e[1;42m $1 \e[m";
}

function set1x4workspace {
  gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 1
  gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 4
}

function installVim {
  format_output "installing vim"

  sudo apt install -y vim

  sudo chmod 666 /etc/vim/vimrc

  sudo echo "set tabstop=2" >> /etc/vim/vimrc

  echo
}

function installGit {
  format_output "installing git"

  sudo apt install -y git

  git config --global user.name "Bill Morrisson"
  git config --global user.email ""

  echo
}

function installZsh {
  format_output "installing zsh"

  sudo apt install -y zsh

  sudo apt-get install -y powerline fonts-powerline

  git clone https://github.com/robbyrussell/oh-my-zsh.git "$users_home"/.oh-my-zsh

  cp "$users_home"/.oh-my-zsh/templates/zshrc.zsh-template "$users_home"/.zshrc

  sudo chsh -s /bin/zsh

#  syntax highlighting

  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$users_home/.zsh-syntax-highlighting" --depth 1

  echo "source $users_home/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$users_home/.zshrc"

  echo  
}

function UpdateFirefox {
format_output "updating firefox"

sudo apt upgrade firefox

echo
}

function installChrome {
  format_output "installing chrome"

  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

  sudo apt install -y ./google-chrome-stable_current_amd64.deb

  rm -rf ./google-chrome-stable_current_amd64.deb

	sudo sed -i 's;/usr/bin/google-chrome-stable;/usr/bin/google-chrome-stable --enable-features=WebUIDarkMode --force-dark-mode;g' /usr/share/applications/google-chrome.desktop

	cp /usr/share/applications/google-chrome.desktop .local/share/applications/

  echo
}

# !
function installVsCode {
  format_output "installing VS Code"

  sudo snap install code --classic

  echo
}

function installGolang {
  format_output "installing golang"

  cd /tmp

  # ! might need to manually update this
  wget https://dl.google.com/go/go1.15.1.linux-amd64.tar.gz

  sudo tar -xvf go1.15.1.linux-amd64.tar.gz

  sudo mv go /usr/local

  cat >> "$users_home/.zshrc" <<EOL
export GOROOT=/usr/local/go
export GOPATH=$users_home/go
EOL

  echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> "$users_home/.zshrc"
  
  echo
}

function installCurl {
  format_output "installing curl"
  
  sudo apt install -y curl

  echo
}

function installPomodoro {
   format_output "installing gnome-pomodoro"

   sudo apt update

   sudo apt install -y gnome-shell-pomodoro

   echo
}

function installDocker {
  format_output "installing docker"

  sudo apt-get update

	sudo apt-get install -y\
	 	apt-transport-https \
		  ca-certificates \
		  curl \
		  gnupg-agent \
		  software-properties-common
		  
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
		
  sudo apt-key fingerprint 0EBFCD88
		
  sudo add-apt-repository -y\
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
    
    sudo apt-get update
    
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    usermod -aG docker $user

  echo
}

function installNode {
  format_output "installing nodejs"
  
  curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

  sudo apt-get install -y nodejs

  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update && sudo apt-get install -y yarn

  echo
}

function installSlack {
  format_output "installing slack"
  
  wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.0.2-amd64.deb

  sudo apt install -y ./slack-desktop-*.deb
  
  rm -rf ./slack-desktop-*.deb

  echo
}

function installPostman {
  format_output "installing postman"
  
  sudo snap install postman

  echo
}

function installBrave {
  format_output "installing brave browser"

  sudo snap install brave

  echo
}

function installGimp {
  format_output "installing gimp"
  
  sudo snap install gimp

  echo
}


function installDiscord {
  format_output "installing Discord"

  sudo snap install discord

  echo
}

function installSpotify {
  format_output "installing Spotify"

  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 5E3C45D7B312C643

  sudo apt update

  sudo apt install spotify-client

  echo
}


function installPostgres {
	format_output "installing postgres and pgadmin"

	sudo apt update

	sudo apt install -y postgresql

	curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
	sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'

	sudo apt -y upgrade

	sudo apt install -y pgadmin4
}

function installSolaar {
	format_output "installing solaar for unifying logitech devices"

	sudo apt update

	sudo apt install -y solaar
}

functions="$(cat $0 | egrep -o install[A-Z]+[A-Za-z]+)"
for f in $functions; do $f;done
