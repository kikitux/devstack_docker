#!/bin/bash -eux

if [ $PACKER_BUILDER_TYPE == 'vmware-iso' ]; then
    echo "Installing VMware Tools"

    mkdir -p /mnt/hgfs
    apt-get update -y
    apt-get install -y open-vm-tools module-assistant linux-headers-amd64 linux-image-amd64 open-vm-tools-dkms
    module-assistant prepare
    module-assistant --text-mode -f get open-vm-tools-dkms

    apt-get -y remove linux-headers-$(uname -r) build-essential perl
    apt-get -y autoremove
elif [ $PACKER_BUILDER_TYPE == 'virtualbox-iso' ]; then
    echo "Installing VirtualBox guest additions"

    apt-get install -y linux-headers-$(uname -r) build-essential perl
    apt-get install -y dkms

    mkdir /tmp/vbox

    VER=$(cat /home/vagrant/.vbox_version)
    mount -o loop /home/vagrant/VBoxGuestAdditions_$VER.iso /tmp/vbox
    sh /tmp/vbox/VBoxLinuxAdditions.run --nox11
    umount /tmp/vbox
    rmdir /tmp/vbox
    rm /home/vagrant/*.iso
    ln -s /opt/VBoxGuestAdditions-*/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions 

fi
