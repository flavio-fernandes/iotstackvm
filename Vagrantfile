# -*- mode: ruby -*-
# vi: set ft=ruby :

$bootstrap_basic = <<SCRIPT
set -o errexit

function get_ip() {
    DEV=${1:-'eth0'}
    ip -4 addr show $DEV 2>/dev/null | grep -oP "(?<=inet ).*(?=/)" | head -1
}

# resize disk
resize2fs /dev/vda1

apt-get update
apt-get -y upgrade

timedatectl set-timezone America/New_York
apt-get install -y git wget curl vim emacs-nox tmux

# ip route
apt-get install -y net-tools

# tmate -- https://github.com/GameServerManagers/LinuxGSM/issues/817
#apt-get install -y telnet tmate
apt-get install -y locales
localedef -f UTF-8 -i en_US en_US.UTF-8

apt-get install -y python3-dev python3-pip python3-venv
update-alternatives --install /usr/bin/python python /usr/bin/python3 1
update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

passwd -l root

SSHD_CNF='/etc/ssh/sshd_config'
cp -v ${SSHD_CNF}{,.orig}
sed -i "s/^PermitRootLogin .*$/PermitRootLogin prohibit-password/" ${SSHD_CNF}
sed -i "s/#StrictModes .*$/StrictModes yes/" ${SSHD_CNF}
sed -i "s/#PasswordAuthentication .*$/PasswordAuthentication no/" ${SSHD_CNF}
sed -i "s/#PermitEmptyPasswords .*$/PermitEmptyPasswords no/" ${SSHD_CNF}
systemctl restart sshd

apt-get install -y ufw fail2ban
ufw allow OpenSSH
ufw allow from 192.168.2.30
yes | ufw enable
SCRIPT

$bootstrap_basic_always = <<SCRIPT
# TODO(flaviof): this needs to be more generic
# default routes
route add default gw 192.168.30.254
route add -net 192.168.2.0/24 gw 192.168.30.254
route add -net 192.168.10.0/24 gw 192.168.30.254
SCRIPT

Vagrant.configure(2) do |config|

    vm_memory = ENV['VM_MEMORY'] || '4096'
    vm_cpus = ENV['VM_CPUS'] || '4'

    config.ssh.forward_agent = true
    config.vm.hostname = "iotstackvm"

    # TODO(flaviof): this needs to be more generic
    config.vm.network "public_network", ip: "192.168.30.252",
                     :dev => "bridge0",
                     :mode => "bridge",
                     :type => "bridge"

    config.vm.box = "debian/bullseye64"
    config.vm.synced_folder "#{ENV['PWD']}", "/vagrant", disabled: false, type: "sshfs"
    #config.vm.synced_folder "#{ENV['PWD']}", "/vagrant", disabled: false, type: "rsync"

    # https://github.com/vagrant-libvirt/vagrant-libvirt#domain-specific-options
    # https://vagrant-libvirt.github.io/vagrant-libvirt/configuration.html
    config.vm.provider 'libvirt' do |lb|
        lb.autostart = true
        lb.random_hostname = true
        lb.nested = true
        lb.memory = vm_memory
        lb.cpus = vm_cpus
        lb.suspend_mode = 'managedsave'
        lb.machine_virtual_size = 44
    end
    config.vm.provider "virtualbox" do |vb|
       vb.memory = vm_memory
       vb.cpus = vm_cpus
       vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
       vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
       vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
       vb.customize ['modifyvm', :id, "--nicpromisc2", "allow-all"]
       vb.customize [
           "guestproperty", "set", :id,
           "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000
          ]
    end

    config.vm.provision :shell do |shell|
        shell.privileged = true
        shell.path = 'provision/baseProvision.sh'
    end

    config.vm.provision "bootstrap_basic", type: "shell",
        inline: $bootstrap_basic

    config.vm.provision :shell do |shell|
        shell.privileged = true
        shell.path = 'provision/createPiUser.sh'
    end

    config.vm.provision "bootstrap_basic_always", type: "shell",
        run: "always",
        inline: $bootstrap_basic_always

    # config.vm.provision :shell do |shell|
    #     shell.privileged = false
    #     shell.path = 'provision/iotStack.sh'
    # end

end
