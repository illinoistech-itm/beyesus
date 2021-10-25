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

sudo yum install -y kernel-devel-`uname -r` gcc binutils make perl bzip2 vim git rsync
sudo yum install -y epel-release
sudo yum install -y python3-pip python3-setuptools python3-devel gcc libffi-devel cairo-devel libtool
sudo yum install -y python3-six  python3-urllib3
#sudo yum install -y graphite-carbon python3-whisper
#sudo yum install graphite-api gunicorn
#sudo yum install -y adduser libfontconfig1
sudo python3 -m pip install carbon
sudo yum install -y urw-fonts
wget https://dl.grafana.com/oss/release/grafana-7.3.6-1.x86_64.rpm
sudo rpm -iv ./grafana-7.3.6-1.x86_64.rpm
sudo git clone https://github.com/illinoistech-itm/beyesus
sudo cp beyesus/itmo-553/week-08/centos-service-files/carbon-cache@.service /lib/systemd/system
sudo cp beyesus/itmo-553/week-08/centos-service-files/carbon-relay@.service /lib/systemd/system
sudo cp -v beyesus/itmo-553/week-07/riemann/riemannb/riemann.config /etc/riemann/riemann.conf
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable grafana-server.service
echo "All Done!"