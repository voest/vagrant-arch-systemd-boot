# -*- mode: ruby -*-
# vi: set ft=ruby :

box = "archlinux/archlinux"
hosts = [
  # { hostname: "arch-bios", firmware: "bios", primary: false },
  { hostname: "arch-efi",  firmware: "efi",  primary: true  }
]

# Add the efi disk on the first boot in bios mode
if ENV['VAGRANT_EXPERIMENTAL'] == "disks"
  firmware = "bios"
else
  firmware = "efi"
end

Vagrant.configure("2") do |config|
  hosts.map { |host|
    config.vm.define host[:hostname], primary: host[:primary] do |instance|
      instance.vm.box = box
      instance.vm.hostname = host[:hostname]
      instance.vm.box_check_update = true
      instance.vm.provider :virtualbox do |vm|
        vm.cpus = 2
        vm.memory = 512
        vm.name = "vagrant_#{host[:hostname]}"
        vm.customize ["modifyvm", :id, "--firmware", "#{firmware}"] unless host[:firmware] == "bios"
      end
      instance.vm.disk :disk, size: "128MB", name: "efi" unless host[:firmware] == "bios"
      instance.vm.provision "file", source: "assets/user-vimrc", destination: "${HOME}/.vimrc"
      instance.vm.provision "file", source: "assets/user-zshrc", destination: "${HOME}/.zshrc"
      instance.vm.provision "shell",  path: "bin/bootstrap.sh",  args: host[:firmware]
    end
  }
end
