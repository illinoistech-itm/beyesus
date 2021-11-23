#!/bin/bash 
set -e
set -v

# http://superuser.com/questions/196848/how-do-i-create-an-administrator-user-on-ubuntu
# http://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
# This line assumes the user you created in the preseed directory is ubuntu
echo "%admin  ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/init-users
sudo groupadd admin
sudo usermod -a -G admin vagrant

# Installing Vagrant keys
wget --no-check-certificate 'https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub'
sudo mkdir -p /home/vagrant/.ssh
sudo chown -R vagrant:vagrant /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys
echo "All Done!"

##################################################
# Add User customizations below here
##################################################

cat << EOT >> /etc/hosts
# Nodes
192.168.33.100  riemanna riemanna.example.com
192.168.33.101  riemannb riemannb.example.com
192.168.33.102  riemannmc riemannmc.example.com
192.168.33.200  graphitea graphitea.example.com
192.168.33.201  graphiteb graphiteb.example.com
192.168.33.202  graphitemc graphitemc.example.com
EOT
## Command to change hostname
sudo hostnamectl set-hostname riemanna
# Install software
# 1 we will need openjdk-8-jre (java runtime) and ruby runtimes
# Examples:
sudo apt-get update -y
sudo apt-get install -y openjdk-8-jre ruby ruby-dev

# 2 we will need the rpm deb packages from riemann.io
# Examples
wget https://github.com/riemann/riemann/releases/download/0.3.6/riemann_0.3.6_all.deb
sudo dpkg -i riemann_0.3.6_all.deb
# 3 we will need some ruby gems 
sudo gem install riemann-client riemann-tools
sudo systemctl enable riemann
sudo systemctl start riemann
# firewalld install
sudo apt-get install  -y firewalld
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo systemctl status firewalld
sudo firewall-cmd --list-all 
sudo firewall-cmd --zone=public --add-port=5555/tcp --permanent
sudo firewall-cmd --zone=public --add-port=5556/udp --permanent
sudo firewall-cmd --zone=public --add-port=5557/tcp --permanent
sudo firewall-cmd --reload
sudo firewall-cmd --list-all 
#clone in to beyesus
# 4 We need to ensure the services are enabled and start succesfully
git clone git@github.com:illinoistech-itm/beyesus.git
cp -v beyesus/itmo-553/week-07/riemann/riemanna/riemann.config /etc/riemann/riemann.config

#####################################################
# Use sed to replace the default graphitea values in /etc/riemann/examplecom/etc/graphite.clj
#####################################################
# No need as this is the graphitea system

#####################################################
# Restart the Riemann service after the changes
#####################################################

sudo systemctl stop riemann
sudo systemctl start riemann

##################################################
# Installation and cofiguration of collectd
##################################################
sudo apt-get update -y
sudo apt-get install -y collectd 

#####################################################
# Copy the collectd configuration files from week-12
#####################################################
cp -v /beyesus/itmo-553/week-12/collectd/riemann/collectd.conf.d/* /etc/collectd.conf.d/

cp -v beyesus/itmo-553/week-12/collectd/collectd.conf /etc/collectd/



