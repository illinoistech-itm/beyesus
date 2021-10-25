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

sudo apt-get update
sudo apt-get install -y python3-dev python3-pip python3-setuptools
sudo DEBIAN_FRONTEND=noninteractive apt-get -y \
--allow-change-held-packages install graphite-carbon python3-whisper
sudo apt-get install -y apt-transport-https 
sudo apt-get install -y graphite-carbon python3-whisper
sudo apt-get install graphite-api gunicorn
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_7.3.6_amd64.deb
sudo git clone https://github.com/illinoistech-itm/beyesus
cd beyesus/itmo-553/week-08/centos-service-files
sudo cp carbon-cache@.service /lib/systemd/system
sudo cp carbon-relay@.service /lib/systemd/system
sudo dpkg -i ./grafana_7.3.6_amd64.deb  
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable grafana-server
sudo /bin/systemctl start grafana-server
