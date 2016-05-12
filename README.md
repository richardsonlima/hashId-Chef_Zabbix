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
``` bash 
sudo apt-get update &&  sudo apt-get install git-core
``` 

* Install Chef Solo
``` bash 
curl -L https://www.opscode.com/chef/install.sh | sudo bash
``` 

* Download and configure CHEF-REPO structure
``` bash 
wget http://github.com/opscode/chef-repo/tarball/master
tar -zxvf master
sudo mkdir -p /opt/chef-repo
sudo mv chef-chef-repo-*/* /opt/chef-repo/
sudo mkdir /opt/chef-repo/.chef
```

* Configure cookbook path (/opt/chef-repo/.chef/knife.rb) - Add line
``` bash 
sudo touch /opt/chef-repo/.chef/knife.rb
sudo chown `whoami`: /opt/chef-repo/.chef/knife.rb
sudo cat << EOF > /opt/chef-repo/.chef/knife.rb
cookbook_path [ '/opt/chef-repo/cookbooks' ]
EOF
sudo chown root: /opt/chef-repo/.chef/knife.rb
```

* Configure solo.rb (/opt/chef-repo/solo.rb) - Add lines
``` bash 
sudo touch /opt/chef-repo/solo.rb
sudo chown `whoami`: /opt/chef-repo/solo.rb
sudo cat << EOF > /opt/chef-repo/solo.rb
file_cache_path "/opt/chef-solo"
cookbook_path "/opt/chef-repo/cookbooks"
EOF
sudo chown root: /opt/chef-repo/solo.rb
``` 

* Download cookbook
``` bash 
sudo git clone https://github.com/richardsonlima/hashId-Chef_Zabbix.git -l /opt/chef-repo/cookbooks/zabbix
```

* Create your json (/opt/chef-repo/zabbix.json) - Add line
``` bash 
sudo touch /opt/chef-repo/zabbix.json
sudo chown `whoami`: /opt/chef-repo/zabbix.json
sudo cat << EOF > /opt/chef-repo/zabbix.json
  { "run_list": [ "recipe[zabbix]" ] }
EOF
sudo chown root:  /opt/chef-repo/zabbix.json
``` 

* Execute CHEF-SOLO
``` bash 
sudo chef-solo -c /opt/chef-repo/solo.rb -j /opt/chef-repo/zabbix.json
``` 

* Status service
``` bash 
ps -ef | grep zabbix
```   

* Zabbix Interface

  http://[IP]/zabbix
