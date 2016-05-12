#!/bin/bash 

printf "\33[32m[✔] Install GIT Client \n \33[0m"
sudo apt-get update &&  sudo apt-get install git-core lynx -y 

printf "\33[32m[✔] Install Chef Solo \n \33[0m"
sudo curl -L https://www.opscode.com/chef/install.sh | sudo bash

printf "\33[32m[✔] Download and configure CHEF-REPO structure \n \33[0m"

wget http://github.com/opscode/chef-repo/tarball/master
tar -zxvf master
sudo mkdir -p /opt/chef-repo
sudo mv chef-chef-repo-*/ /opt/chef-repo
sudo mkdir /opt/chef-repo/.chef

printf "\33[32m[✔] Configure cookbook path \n \33[0m"
sudo touch /opt/chef-repo/.chef/knife.rb
sudo chown `whoami`: /opt/chef-repo/.chef/knife.rb
sudo cat << EOF > /opt/chef-repo/.chef/knife.rb
cookbook_path [ '/opt/chef-repo/cookbooks' ]
EOF
sudo chown root: /opt/chef-repo/.chef/knife.rb

printf "\33[32m[✔] Configure solo.rb \n \33[0m"
sudo touch /opt/chef-repo/solo.rb
sudo chown `whoami`: /opt/chef-repo/solo.rb
sudo cat << EOF > /opt/chef-repo/solo.rb
file_cache_path "/opt/chef-solo"
cookbook_path "/opt/chef-repo/cookbooks"
EOF
sudo chown root: /opt/chef-repo/solo.rb

printf "\33[32m[✔] Downloading cookbook \n \33[0m"
sudo git clone https://github.com/richardsonlima/hashId-Chef_Zabbix.git -l /opt/chef-repo/cookbooks/zabbix

printf "\33[32m[✔] Creating your json \n \33[0m"
sudo touch /opt/chef-repo/zabbix.json
sudo chown `whoami`: /opt/chef-repo/zabbix.json
sudo cat << EOF > /opt/chef-repo/zabbix.json
  { "run_list": [ "recipe[zabbix]" ] }
EOF
sudo chown root:  /opt/chef-repo/zabbix.json

printf "\33[32m[✔] Execute CHEF-SOLO \n \33[0m"
sudo chef-solo -c /opt/chef-repo/solo.rb -j /opt/chef-repo/zabbix.json

printf "\33[32m[✔] See service status \n \33[0m"
ps -ef | grep zabbix

printf "\33[32m[✔] Accessing Zabbix Web Interface \n \33[0m"
lynx http://[IP]/zabbix
