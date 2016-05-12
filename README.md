# hashId-Chef_Zabbix

Cookbook - Zabbix Server 2.4.4 + MySQL
===============

Author: Richardson Lima (contatorichardsonlima@gmail.com)

Cookbook install and configure: Zabbix Server 2.4.4 + MySQL

Test: Ubuntu Server 16.04.4 LTS

Database Name: zabbixdb (user: zabbix / pass: zabbix)

Root MySQL password: zabbix

Zabbix Interface: admin / zabbix

HowTo
------------
* Cookbook install and configure: Zabbix Server 2.2.2 + MySQL
* Test: Ubuntu Server 16.04.4 LTS
* Database Name: zabbixdb (user: zabbix / pass: zabbix)
* Root MySQL password: zabbix
* Zabbix Interface: admin / zabbix

chef-solo is an open source version of the chef-client that allows using cookbooks with nodes 
without requiring access to a Chef server. 
chef-solo runs locally and requires that a cookbook 

* Install GIT Client
\# sudo apt-get update &&  sudo apt-get install git-core

* Install Chef Solo
\# curl -L https://www.opscode.com/chef/install.sh | sudo bash

* Download and configure CHEF-REPO structure
\# wget http://github.com/opscode/chef-repo/tarball/master
\# tar -zxvf master
\# sudo mv chef-chef-repo-*/ /opt/chef-repo
\# sudo mkdir /opt/chef-repo/.chef

# Configure Cookbook Path
#Adicione a seguinte linha no arquivo “/opt/chef-repo/.chef/knife.rb”:
\# sudo touch /opt/chef-repo/.chef/knife.rb
\# sudo chown `whoami`: /opt/chef-repo/.chef/knife.rb
\# sudo cat << EOF > /opt/chef-repo/.chef/knife.rb
cookbook_path [ '/opt/chef-repo/cookbooks' ]
EOF
\# sudo chown root: /opt/chef-repo/.chef/knife.rb

* Configure solo.rb (/opt/chef-repo/solo.rb) - Add lines
\# gsudo touch /opt/chef-repo/solo.rb
\# gsudo chown `whoami`: /opt/chef-repo/solo.rb
\# gsudo cat << EOF > /opt/chef-repo/solo.rb
file_cache_path "/opt/chef-solo"
cookbook_path "/opt/chef-repo/cookbooks"
EOF
\# sudo chown root: /opt/chef-repo/solo.rb

* Download cookbook
\# sudo git clone https://github.com/richardsonlima/hashId-Chef_Zabbix.git -l /opt/chef-repo/cookbooks/zabbix

* Create your json (/opt/chef-repo/zabbix.json) - Add line
\# sudo touch /opt/chef-repo/zabbix.json
\# sudo chown `whoami`: /opt/chef-repo/zabbix.json
\# sudo cat << EOF > /opt/chef-repo/zabbix.json
  { "run_list": [ "recipe[zabbix]" ] }
EOF
\# sudo chown root:  /opt/chef-repo/zabbix.json
