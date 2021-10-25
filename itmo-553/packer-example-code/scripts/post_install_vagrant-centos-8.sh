#!/bin/bash 
set -e
set -v
# http://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
# This line assumes the user you created in the preseed directory is vagrant
# http://chrisbalmer.io/vagrant/2015/07/02/build-rhel-centos-7-vagrant-box.html
# Read this bug track to see why this line below was the source of a lot of trouble.... 
# https://github.com/mitchellh/vagrant/issues/1482
#echo "Defaults requiretty" | sudo tee -a /etc/sudoers.d/init-users
# Need to add this first as wget not part of the base package...
sudo yum install -y wget
#################################################################################################################
# code needed to allow for vagrant to function seamlessly
#################################################################################################################
echo "%admin  ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/init-users
sudo groupadd admin
sudo usermod -a -G admin vagrant

# Installing Vagrant keys
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
sudo mkdir -p /home/vagrant/.ssh
sudo chown -R vagrant:vagrant /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys
sudo chmod 700 /home/vagrant/.ssh
sudo chmod 600 /home/vagrant/.ssh/authorized_keys
echo "All Done!"

#########################
# Add customization here
#########################
sudo yum install -y java-1.8.0-openjdk ruby ruby-devel
wget https://github.com/riemann/riemann/releases/download/0.3.6/riemann-0.3.6-1.noarch-EL8.rpm
sudo rpm -Uvh riemann-0.3.6-1.noarch-EL8.rpm
sudo gem install riemann-client riemann-tools riemann-dash
sudo systemctl enable riemann
sudo systemctl start riemann
sudo yum install -y kernel-devel-`uname -r` gcc binutils make perl bzip2 vim git rsync
sudo yum install -y git epel-release python3 python3-pip python3-setuptools python3-devel gcc libffi-devel cairo-devel libtool python3-six  python3-urllib3
sudo python3 -m pip install carbon
sudo yum install -y urw-fonts
wget https://dl.grafana.com/oss/release/grafana-7.3.6-1.x86_64.rpm
sudo rpm -iv ./grafana-7.3.6-1.x86_64.rpm
git clone git@github.com:illinoistech-itm/beyesus.git
sudo python3 -m pip install carbon --install-option="--prefix=/etc/carbon" --install-option="--install-lib=/var/lib/graphite" whisper
sudo cp beyesus/itmo-553/week-08/centos-service-files/carbon-cache@.service /lib/systemd/system
sudo cp beyesus/itmo-553/week-08/centos-service-files/carbon-relay@.service /lib/systemd/system
sudo cp -v beyesus/itmo-553/week-07/riemann/riemannb/riemann.config /etc/riemann/riemann.conf
sudo cp beyesus/itmo-553/week-08/carbon/carbon.conf /etc/carbon
sudo cp beyesus/itmo-553/week-08/carbon/storage-schemas.conf /etc/carbon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable grafana-server.service
echo "All Done!"
