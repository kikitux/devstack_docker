ENV['mem'] ||="5000"
Vagrant.configure("2") do |config|
  config.vm.box = "alvaro/devstack_docker"
  config.vm.hostname = "devstack"

  config.vm.network "forwarded_port", guest: 80, host: 8888
  config.vm.network "forwarded_port", guest: 5000, host: 5555
  config.vm.network "forwarded_port", guest: 8500, host: 8500
  config.vm.network "forwarded_port", guest: 8880, host: 8880
  config.vm.network "forwarded_port", guest: 8881, host: 8881
  config.vm.network "forwarded_port", guest: 8882, host: 8882
  config.vm.network "forwarded_port", guest: 8883, host: 8883
  config.vm.network "forwarded_port", guest: 8884, host: 8884
  config.vm.network "forwarded_port", guest: 8885, host: 8885

  config.vm.provision :shell, privileged: false, :inline => "bash /vagrant/scripts/provision.sh"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--memory", "#{ENV['mem']}"]
  end
end
