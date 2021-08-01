#!/bin/bash

echo "------------"
echo "PROVISIONING"
echo "------------"

# Setup mode
[[ "$1" == "bios" ]] && setup=noefi || setup=efi

# Setup pacman
cp /vagrant/assets/pacman.conf /etc/pacman.conf
[[ "${setup}" == "noefi" ]] && sed -i "s/IgnorePkg/#&/" /etc/pacman.conf
pacman --noconfirm -Sy
pacman --noconfirm -S dosfstools git grml-zsh-config jq man-db ncdu parted vim zsh

# Upgrade all packages
pacman --noconfirm -Su

# Use zsh
chsh -s /usr/bin/zsh vagrant

# Setup systemd-networkd
cp /vagrant/assets/eth0.network /etc/systemd/network/eth0.network
systemctl restart systemd-networkd.service

# Setup ESP
if [[ "${setup}" == "efi" ]]; then
  if ! parted /dev/sdb mktable gpt --script; then
    echo "-----------------------------------------------------------------------" >&2
    echo "ERROR: Failed to setup ESP" >&2
    echo "Run 'vagrant destroy' followed by" >&2
    echo "    'VAGRANT_EXPERIMENTAL=\"disks\" vagrant up' to continue" >&2
    echo "-----------------------------------------------------------------------" >&2
    exit 1
  fi
  parted /dev/sdb mkpart fat32 1MiB 100% --script
  parted /dev/sdb set 1 esp on --script
  # Ugly sleep since the partition is not immediately ready
  sleep 2
  mkfs.fat -F32 /dev/sdb1
  # systemd-gpt-auto-generator does not work here because the rootfs is on another disk
  cp /vagrant/assets/efi.mount /etc/systemd/system/efi.mount
  systemctl daemon-reload
  systemctl enable --now efi.mount

  # Setup systemd-boot
  bootctl install
  kernel-install add "$(uname -r)" /boot/vmlinuz-linux
  echo "-----------------------------------------------------------------------"
  echo "systemd-boot setup completed"
  echo "Run 'vagrant reload' to continue"
  echo "-----------------------------------------------------------------------"
fi
