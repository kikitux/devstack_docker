pushd /opt/stack/devstack/
. openrc demo

neutron security-group-rule-create --protocol icmp \
  --direction ingress --remote-ip-prefix 0.0.0.0/0 default

neutron security-group-rule-create --protocol tcp \
  --port-range-min 22 --port-range-max 22 \
  --direction ingress --remote-ip-prefix 0.0.0.0/0 default

neutron security-group-rule-create --protocol tcp \
  --port-range-min 80 --port-range-max 80 \
  --direction ingress --remote-ip-prefix 0.0.0.0/0 default
