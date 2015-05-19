Vagrant.configure("2") do |config|
  config.vm.box = "alvaro/devstack_docker"
  config.vm.hostname = "devstack"
  config.vm.network "forwarded_port", guest: 80, host: 8888
  config.vm.network "forwarded_port", guest: 5000, host: 5555
  config.vm.network "forwarded_port", host: 8881, guest: 8881
  config.vm.network "forwarded_port", host: 8882, guest: 8882
  config.vm.network "forwarded_port", host: 8883, guest: 8883
  config.vm.network "forwarded_port", host: 8884, guest: 8884
  config.vm.network "forwarded_port", host: 8885, guest: 8885
  config.vm.provision :shell, privileged: false, :inline => "bash /vagrant/scripts/provision.sh"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--memory", "5000"]
  end
end
