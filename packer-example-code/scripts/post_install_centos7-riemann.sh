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

sudo yum install -y kernel-devel-`uname -r` gcc binutils make perl bzip2 vim


sudo yum update 
sudo yum install -y java-1.8.0-openjdk
wget https://github.com/riemann/riemann/releases/download/0.3.6/riemann-0.3.6-1.noarch-EL8.rpm
sudo rpm -Uvh riemann-0.3.6-1.noarch-EL8.rpm
sudo yum install -y ruby ruby-devel gcc libxml2-devel firewalld
sudo gem install --no-ri --no-rdoc riemann-tools riemann-dash

sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --zone=public --add port=5555/tcp --permanent
sudo firewall-cmd --zone=public --add port=5556/udp --permanent
sudo firewall-cmd --zone=public --add port=5557/tcp --permanent
sudo firewall-cmd --reload
sudo systemctl enable riemann
sudo systemctl start riemann
sudo systemctl status riemann
# tail /var/log/riemann/riemann.log
echo "All Done!"
