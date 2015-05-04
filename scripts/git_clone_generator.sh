#!/bin/bash

pushd /opt/stack &>/dev/null
echo mkdir -p /opt/stack
echo cd /opt/stack
for x in `grep url */.git/config | cut -d= -f2` ; do
  echo "git clone $x &"
done
echo "wait"
popd &>/dev/null
