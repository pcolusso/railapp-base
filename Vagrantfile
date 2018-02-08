setup_user = <<-SHELL
  #!/usr/bin/env bash

  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  curl -sSL https://get.rvm.io | bash -s stable


  source $HOME/.rvm/scripts/rvm || source /etc/profile.d/rvm.sh
  rvm use --default --install 2.5.0
  rvm cleanup all

  gem install bundler nokogiri pg 

  git clone -q --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it && ~/.bash_it/install.sh --silent
  git clone https://github.com/gpakosz/.tmux.git && ln -s -f .tmux/.tmux.conf && cp .tmux/.tmux.conf.local .

  git clone -q --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
  sh ~/.vim_runtime/install_awesome_vimrc.sh

  #some tweaks...

  sed -i -e 's/bobby/powerline/g' .bashrc

  bundle install --jobs 4
SHELL

# Couldnt get this to work, run this to add auto tmux...
=begin
  cat <<EOT >> .bashrc
  if [[ -z "$TMUX" ]]; then
    tmux has-session &> /dev/null
    if [ $? -eq 1 ]; then
      exec tmux new
      exit
    else
      exec tmux attach
      exit
    fi
  fi
EOT
=end

setup_root = <<-SHELL
  apt-get update
  apt-get install -y git vim tmux curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs docker.io postgresql postgresql-contrib postgresql-client libpq-dev
  postgres createuser -s vagrant
SHELL

Vagrant.configure('2') do |config|
  # 'hashicorp/precise64' may be required for hyper-v. breaks a whole lotta stuff.
  config.vm.box = "ubuntu/xenial64" 
  config.ssh.forward_agent = true
  config.vm.network :forwarded_port, guest: 3000, host: 3000, auto_correct: true
  config.vm.synced_folder "./", "/var/www/", create: true, group: "vagrant", owner: "vagrant"

  config.vm.provider "virtualbox" do |v|
    v.name = "App_DevEnv"
    v.customize ["modifyvm", :id, "--memory", "2048"]
    v.customize ["modifyvm", :id, "--cpus", "4"]
  end

  config.vm.provision "shell", inline: setup_root
  config.vm.provision "shell", privileged: false, inline: setup_user
end
