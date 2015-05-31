## DevStack Docker Demo for Openstack HP Meetup

### General setup
1. Download and install [Virtualbox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://www.vagrantup.com/downloads.html)
2. Pull down the [Vagrantfile](Vagrantfile) in this repo
   ```ruby
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
     config.vm.provision :shell, privileged: false, :inline => "bash /vagrant/scripts/nginx.sh"

     config.vm.provider :virtualbox do |vb|
       vb.customize ["modifyvm", :id, "--cpus", "2"]
       vb.customize ["modifyvm", :id, "--memory", "5000"]
     end
   end
   ```
3. Run `vagrant up --provider virtualbox` in the directory the [Vagrantfile](Vagrantfile) is in to download the DevStack Vagrant box and spin up the VM
4. That's it! [Login to your OpenStack dashboard](#login-to-your-openstack-dashboard), then follow the below steps to spin up a web server which can be viewed in your dashboard

### Step 1: Neutron configuration
1. Run `vagrant ssh` in the directory the [Vagrantfile](Vagrantfile) is in
2. Go to the devstack directory `cd /opt/stack/devstack`
3. Source the demo environment `. openrc demo`
4. Setup security group icmp ingress rule

   ```
   neutron security-group-rule-create --protocol icmp \
   --direction ingress --remote-ip-prefix 0.0.0.0/0 default
   ```
5. Setup port 22

   ```
   neutron security-group-rule-create --protocol tcp \
   --port-range-min 22 --port-range-max 22 \
   --direction ingress --remote-ip-prefix 0.0.0.0/0 default
   ```
6. Setup port 80

   ```
   neutron security-group-rule-create --protocol tcp \
   --port-range-min 80 --port-range-max 80 \
   --direction ingress --remote-ip-prefix 0.0.0.0/0 default
   ```
7. Provide internet access to the containers `sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`

### Step 2: Start a Docker container
1. Source the admin environment `. openrc admin`
2. Pull down the [larsks/thttpd](https://registry.hub.docker.com/u/larsks/thttpd/) Docker image `docker pull larsks/thttpd`
3. Upload image into glance

   ```
   docker save larsks/thttpd |
   glance image-create --name larsks/thttpd \
     --is-public true --container-format docker \
     --disk-format raw
   ```
4. Source the demo environment `. openrc demo`
5. Boot glance image `nova boot --image larsks/thttpd --flavor m1.small test0`

### Step 3: Test that the webpage works
1. Grab the private ip by running the command `nova list`

   ```
   +----...+-------+--------+...+-------------+--------------------+
   | ID ...| Name  | Status |...| Power State | Networks           |
   +----...+-------+--------+...+-------------+--------------------+
   | 0c3...| test0 | ACTIVE |...| Running     | private=internal_ip|
   +----...+-------+--------+...+-------------+--------------------+
   ```
2. Run `curl http://internal_ip` to verify we have a working web server

   ```
   <!DOCTYPE html>
   <html>
           <head>
                   <title>Your web server is working</title>
   [...]
   ```
3. In the browser go to http://localhost:88nn where nn is the IP of the server

   ```
   10.0.0.1 -> localhost 8881
   10.0.0.2 -> localhost 8882
   10.0.0.3 -> localhost 8883
   10.0.0.4 -> localhost 8884
   10.0.0.5 -> localhost 8885
   ```

   ![screenshot/8885.png](screenshot/8885.png)

### Step 4: Create a floating ip address
1. Create floating ip `nova floating-ip-create`

   ```
   +------------+-----------+----------+--------+
   | Ip         | Server Id | Fixed Ip | Pool   |
   +------------+-----------+----------+--------+
   | 172.24.4.3 | -         | -        | public |
   +------------+-----------+----------+--------+
   ```
2. Assign it to our container `nova floating-ip-associate test0 172.24.4.3`
3. Now access our service `curl http://172.24.4.3`

   ```
   <!DOCTYPE html>
   <html>
           <head>
                   <title>Your web server is working</title>
   [...]
   ```

### Login to your OpenStack dashboard
1. Go to http://localhost:8888
2. Login to admin with username `admin` and password `password`
3. Login to demo with username `demo` and password `password`

   ![screenshot/login\_admin.png](screenshot/login_admin.png)

   ![screenshot/system\_hypervisors.png](screenshot/system_hypervisors.png)

   ![screenshot/system\_information.png](screenshot/system_information.png)

   ![screenshot/instance\_details\_test0.png](screenshot/instance_details_test0.png)
