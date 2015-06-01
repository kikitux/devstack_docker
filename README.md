## DevStack Docker Demo for Openstack HP Meetup

### General setup
1. Download and install [Virtualbox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://www.vagrantup.com/downloads.html)
   If you already have Vagrant installed, we suggest update to the current version available.
2. Download a copy of this repo in [zip format](https://github.com/kikitux/devstack_docker/archive/master.zip) or just clone it `git clone https://github.com/kikitux/devstack_docker.git`
3. Run `vagrant up --provider virtualbox` in the local directory where the [Vagrantfile](Vagrantfile) is in to download the DevStack Vagrant box and spin up the VM

Note: On first run, Vagrant will download the base box required.

### Login to your OpenStack dashboard
1. Go to http://localhost:8888
2. Login to admin with username `admin` and password `password` or login to demo with username `demo` and password `password`

   ![screenshot/login\_admin.png](screenshot/login_admin.png)

That's it, you have a fully functioning DevStack environment!

---
Now that you have your DevStack running, it's time to use it. Below are steps to setup a sample web server on your DevStack.

### Step 1: Neutron configuration
1. Run `vagrant ssh` in the directory the [Vagrantfile](Vagrantfile) is in
2. Go to the devstack directory

`cd /opt/stack/devstack`

3. Source the demo environment

`. openrc demo`

4. Setup security groups

   ```
   neutron security-group-rule-create --protocol icmp \
   --direction ingress --remote-ip-prefix 0.0.0.0/0 default
   ```

   ```
   neutron security-group-rule-create --protocol tcp \
   --port-range-min 22 --port-range-max 22 \
   --direction ingress --remote-ip-prefix 0.0.0.0/0 default
   ```

   ```
   neutron security-group-rule-create --protocol tcp \
   --port-range-min 80 --port-range-max 80 \
   --direction ingress --remote-ip-prefix 0.0.0.0/0 default
   ```

5. Provide internet access to the containers 

`sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`

### Step 2: Start a Docker container
1. Source the admin environment 

`. openrc admin`

2. Pull down the [larsks/thttpd](https://registry.hub.docker.com/u/larsks/thttpd/) Docker image 

`docker pull larsks/thttpd`

3. Create a glance image

   ```
   docker save larsks/thttpd |
   glance image-create --name larsks/thttpd \
     --is-public true --container-format docker \
     --disk-format raw
   ```

4. Source the demo environment 

`. openrc demo`

5. Boot the glance image 

`nova boot --image larsks/thttpd --flavor m1.small test0`

### Step 3: Test that the webpage works
1. Grab the private ip by running the command `nova list`


   ```
  nova list

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

3. In the browser go to http://localhost:888n where n is the IP of the server

   ```
   10.0.0.1 -> localhost 8881
   10.0.0.2 -> localhost 8882
   10.0.0.3 -> localhost 8883
   10.0.0.4 -> localhost 8884
   10.0.0.5 -> localhost 8885
   ```

   ![screenshot/8885.png](screenshot/8885.png)

4. [Login to your OpenStack dashboard](#login-to-your-openstack-dashboard) and view your newly created instance

   ![screenshot/system\_hypervisors.png](screenshot/system_hypervisors.png)

   ![screenshot/system\_information.png](screenshot/system_information.png)

   ![screenshot/instance\_details\_test0.png](screenshot/instance_details_test0.png)
