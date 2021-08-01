# vagrant-arch-systemd-boot

A simple [Vagrant](https://www.vagrantup.com/) configuration for creating a [Arch Linux](https://archlinux.org/) virtual machine with UEFI and [systemd-boot](https://www.freedesktop.org/wiki/Software/systemd/systemd-boot/) as boot loader. For better autocompletion [Zsh](https://wiki.archlinux.org/index.php/Zsh) is used.

## Initialization

1. Install [VirtualBox](https://www.virtualbox.org/)
1. Install Vagrant. You can use [asdf](https://asdf-vm.com/) for multiple version support.
1. Create your virtual machine and prepare it for EFI support
   ```
   VAGRANT_EXPERIMENTAL="disks" vagrant up 
   ```
1. Reboot to finish the setup
   ```
   vagrant reload
   ```

## Running

1. Use `vagrant ssh` to connect
1. Stop the virtual machine with `vagrant halt`
1. Boot it up again with `vagrant up`
1. Destroy it with `vagrant destroy`

## Additional BIOS virtual machine

There is an optional `arch-bios` virtual machine. Just enable it in the [Vagrantfile](Vagrantfile).
