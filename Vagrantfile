Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network :private_network, ip: "172.16.10.2"
  config.vm.network "forwarded_port", guest: 80, host: 8887
  config.vm.network "forwarded_port", guest: 5000, host: 5554
  config.vm.provision :shell, privileged: false, :inline => "bash /vagrant/scripts/os_packages.sh"
  config.vm.provision :shell, privileged: false, :inline => "bash /vagrant/scripts/git_clone.sh"
  config.vm.provision :shell, privileged: false, :inline => "bash /vagrant/scripts/provision.sh"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--memory", "5000"]
  end
end
