export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -y dselect
sudo dselect update
sudo apt-get -y update
[ -f /vagrant/scripts/installed-software ] && grep -iv mysql /vagrant/scripts/installed-software | sudo dpkg --set-selections
sudo apt-get -y upgrade
sudo apt-get -y dselect-upgrade
sudo apt-get -y install git git-review python-pip python-dev
sudo easy_install -U pip

curl -sSL https://get.docker.com/ubuntu/ | sudo sh
