#!/bin/bash

BASE="/opt/consul"
CONSUL_URL="https://dl.bintray.com/mitchellh/consul"
CONSUL_ZIP="0.5.2_linux_amd64.zip"
CONSUL_UI="0.5.2_web_ui.zip"

mkdir -p $BASE

if [ ! -f $BASE/$CONSUL_ZIP ]; then
  curl -L -o $BASE/$CONSUL_ZIP $CONSUL_URL/$CONSUL_ZIP
fi

if [ -f $BASE/$CONSUL_ZIP ]; then
  sudo unzip -o $BASE/$CONSUL_ZIP -d $BASE
  sudo chmod ugo+x $BASE/consul
fi

if [ ! -f $BASE/$CONSUL_UI ]; then
  curl -L -o $BASE/$CONSUL_UI $CONSUL_URL/$CONSUL_UI
fi

if [ -f $BASE/$CONSUL_UI ]; then
  sudo unzip -o $BASE/$CONSUL_UI -d $BASE
fi

sudo chown -R vagrant: /opt/consul

/opt/consul/consul agent --data-dir=/opt/consul/data-dir -ui-dir=/opt/consul/dist -server -bootstrap-expect=1 -client=0.0.0.0

