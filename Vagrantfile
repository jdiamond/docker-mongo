# -*- mode: ruby -*-
# vi: set ft=ruby :

ENABLE_SWAP = <<SCRIPT
  fallocate -l 4G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
SCRIPT

INSTALL_AUFS = <<SCRIPT
  sudo apt-get update
  sudo apt-get install -y linux-image-extra-`uname -r`
  # This requires a reboot before Docker can use the AUFS driver.
SCRIPT

INSTALL_DOCKER = <<SCRIPT
  curl -sSL https://get.docker.io/ubuntu/ | sudo sh

  # Add the vagrant user to the docker group to run docker commands without sudo.
  sudo gpasswd -a vagrant docker
SCRIPT

INSTALL_FIG = <<SCRIPT
  curl -sSL https://github.com/docker/fig/releases/download/1.0.1/fig-`uname -s`-`uname -m` > /usr/local/bin/fig
  chmod +x /usr/local/bin/fig
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "trusty"

  config.vm.network "private_network", ip: "10.10.10.10"

  config.vm.provision "shell", inline: ENABLE_SWAP
  config.vm.provision "shell", inline: INSTALL_AUFS
  config.vm.provision "shell", inline: INSTALL_DOCKER
  config.vm.provision "shell", inline: INSTALL_FIG

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end
end
