# -*- mode: ruby -*-
# vi: set ft=ruby :

# Number of nodes
$NUM_VPS = 3  

Vagrant.configure("2") do |config|
  # Global configuration
  config.vm.box = "hashicorp/bionic64"
  config.ssh.insert_key = false

  # Virtualbox provider
  config.vm.provider :virtualbox do |vb|
    vb.check_guest_additions = false
    vb.memory = 512
    vb.cpus = 1
  end

  # Admin workstation
  config.vm.define "admin", primary: true do |admin|
    admin.vm.hostname = "admin"
    admin.vm.network "private_network", ip: "10.1.102.7"
    admin.vm.network "forwarded_port", guest: 22, host: 2200, id: "ssh"
  end

  # Virtual Private Server
  (1..$NUM_VPS).each do |i|
    config.vm.define vm_name = "vps%02d" % i, autostart: false do |vps|
      vps.vm.hostname = vm_name
      vps.vm.network "private_network", ip: "10.1.102.#{i+10}"
      vps.vm.network "forwarded_port", guest: 22, host: 2200+i, id: "ssh"
    end
  end

  # Thin provisioning
  config.vm.provision "shell", args: config.vm.hostname, inline: <<-SHELL
    sudo apt-get update -q 2
    sudo sed -i -e "2s/.*/127.0.1.1\t$(hostname).demain.xyz\t$(hostname)/" /etc/hosts
  SHELL
end
