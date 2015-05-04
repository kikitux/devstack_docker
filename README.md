# devstack_docker
For demo in Openstack HP Meetup

# Vagrantfile

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "alvaro/devstack_docker"
  config.vm.network :private_network, ip: "172.16.10.2"
  config.vm.network "forwarded_port", guest: 80, host: 8888
  config.vm.network "forwarded_port", guest: 5000, host: 5555
  config.vm.provision :shell, privileged: false, :inline => "bash /vagrant/scripts/provision.sh"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--memory", "5000"]
  end
end

```

# Then

vagrant ssh

cd /opt/stack/devstack

```
Starting a Docker container
Now that our environment is up and running, we should be able to start a container. We'll start by grabbing some admin credentials for our OpenStack environment:

$ . openrc admin
Next, we need an appropriate image; my larsks/thttpd image is small (so it's quick to download) and does not require any interactive terminal (so it's appropriate for nova-docker), so let's start with that:

$ docker pull larsks/thttpd
$ docker save larsks/thttpd |
  glance image-create --name larsks/thttpd \
    --is-public true --container-format docker \
    --disk-format raw
And now we'll boot it up. I like to do this as a non-admin user:

$ . openrc demo
$ nova boot --image larsks/thttpd --flavor m1.small test0
After a bit, we should see:

$ nova list
+----...+-------+--------+...+-------------+--------------------+
| ID ...| Name  | Status |...| Power State | Networks           |
+----...+-------+--------+...+-------------+--------------------+
| 0c3...| test0 | ACTIVE |...| Running     | private=10.254.1.4 |
+----...+-------+--------+...+-------------+--------------------+
Let's create a floating ip address:

$ nova floating-ip-create
+------------+-----------+----------+--------+
| Ip         | Server Id | Fixed Ip | Pool   |
+------------+-----------+----------+--------+
| 172.24.4.3 | -         | -        | public |
+------------+-----------+----------+--------+
And assign it to our container:

$ nova floating-ip-associate test0 172.24.4.3
And now access our service:

$ curl http://172.24.4.3
<!DOCTYPE html>
<html>
        <head>            
                <title>Your web server is working</title>
[...]
```

# Networking

```
$ neutron security-group-rule-create --protocol icmp \
  --direction ingress --remote-ip-prefix 0.0.0.0/0 default

$ neutron security-group-rule-create --protocol tcp \
  --port-range-min 22 --port-range-max 22 \
  --direction ingress --remote-ip-prefix 0.0.0.0/0 default

$ neutron security-group-rule-create --protocol tcp \
  --port-range-min 80 --port-range-max 80 \
  --direction ingress --remote-ip-prefix 0.0.0.0/0 default

Uploading docker image to glance
$ . openrc admin
$  docker pull rastasheep/ubuntu-sshd:14.04
$  docker save rastasheep/ubuntu-sshd:14.04 | glance image-create --is-public=True   --container-format=docker --disk-format=raw --name rastasheep/ubuntu-sshd:14.04

Launch new instance via uploaded image :- 
$ . openrc demo
$  nova boot --image "rastasheep/ubuntu-sshd:14.04" --flavor m1.tiny
    --nic net-id=private-net-id UbuntuDocker

To provide internet access for launched nova-docker instance run :-


# iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

```

# network v2

```
. /home/vagrant/devstack/openrc

nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
nova secgroup-add-rule default tcp 80 80 0.0.0.0/0
nova secgroup-list-rules default

sudo iptables -F
sudo service iptables save
sudo ufw disable

sudo ovs-vsctl add-br br-ex
sudo ovs-vsctl add-port br-ex eth1
sudo ovs-vsctl show
```
