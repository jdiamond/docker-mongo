# -*- mode: ruby -*-
# vi: set ft=ruby :

ENABLE_SWAP = <<SCRIPT
  touch /var/swap.img
  chmod 600 /var/swap.img
  dd if=/dev/zero of=/var/swap.img bs=1024K count=2048
  mkswap /var/swap.img
  swapon /var/swap.img
SCRIPT

INSTALL_DOCKER = <<SCRIPT
  # Install Docker.
  curl -sSL https://get.docker.io/ubuntu/ | sudo sh

  # Add the vagrant user to the docker group to run docker commands without sudo.
  sudo gpasswd -a vagrant docker

  # Increase maximum container size from 10GB to 20GB.
  sudo sh -c "echo 'DOCKER_OPTS=\\"--storage-opt dm.basesize=20G\\"' > /etc/default/docker"

  # Docs say to stop daemon, remove docker folder, and restart docker daemon.
  # https://github.com/docker/docker/blob/master/daemon/graphdriver/devmapper/README.md
  sudo stop docker && sudo rm -rf /var/lib/docker && sudo start docker
SCRIPT

INSTALL_FIG = <<SCRIPT
  sudo apt-get install -y python-pip
  sudo pip install -U fig
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "trusty"

  config.vm.network "private_network", ip: "10.10.10.10"

  config.vm.provision "shell", inline: ENABLE_SWAP
  config.vm.provision "shell", inline: INSTALL_DOCKER
  config.vm.provision "shell", inline: INSTALL_FIG

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end
end
