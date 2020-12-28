# -*- mode: ruby -*-
# vi: set ft=ruby :

hostname = "arch01-small"
box = "archlinux/archlinux"

# Add the efi disk on the first boot in bios mode
if ENV['VAGRANT_EXPERIMENTAL'] == "disks"
  firmware = "bios"
else
  firmware = "efi"
end

Vagrant.configure("2") do |config|
  config.vm.define hostname do |instance|
    instance.vm.box = box
    instance.vm.hostname = hostname
    instance.vm.box_check_update = true
    instance.vm.provider :virtualbox do |vm|
      vm.cpus = 2
      vm.memory = 1024
      vm.name = "vagrant_#{hostname}"
      vm.customize ["modifyvm", :id, "--firmware", "#{firmware}"]
    end
    instance.vm.disk :disk, size: "128MB", name: "efi"
    instance.vm.provision "file", source: "assets/user-vimrc", destination: "${HOME}/.vimrc"
    instance.vm.provision "file", source: "assets/user-zshrc", destination: "${HOME}/.zshrc"
    instance.vm.provision "shell", path: "bin/bootstrap.sh"
  end
end
