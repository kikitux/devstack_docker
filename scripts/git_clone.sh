sudo mkdir -p /opt/stack
sudo chown -R vagrant: /opt/stack
cd /opt/stack
git clone git://git.openstack.org/openstack/cinder.git &
git clone https://git.openstack.org/openstack-dev/devstack & 
git clone git://git.openstack.org/openstack/glance.git &
git clone git://git.openstack.org/openstack/horizon.git &
git clone git://git.openstack.org/openstack/keystone.git &
git clone git://git.openstack.org/openstack/neutron.git &
git clone https://git.openstack.org/stackforge/nova-docker.git & 
git clone git://git.openstack.org/openstack/nova.git &
git clone https://github.com/kanaka/noVNC.git &
git clone git://git.openstack.org/openstack/requirements.git &
git clone git://git.openstack.org/openstack/tempest.git &
wait
sudo chown -R vagrant: /opt/stack
