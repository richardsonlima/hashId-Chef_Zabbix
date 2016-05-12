#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "build-essential" do
  action :install
end

package "apache2" do
  action :install
end

package "php5" do
  action :install
end

package "php5-curl" do
  action :install
end

package "php5-dev" do
  action :install
end

package "php5-mysql" do
  action :install
end

package "php5-gd" do
  action :install
end

package "php5-xmlrpc" do
  action :install
end

package "openipmi" do
  action :install
end

package "libssh2-1" do
  action :install
end

package "libssh2-1-dev" do
  action :install
end

package "libssh2-php" do
  action :install
end

package "fping" do
  action :install
end

package "libcurl3" do
  action :install
end

package "libcurl4-openssl-dev" do
  action :install
end

package "libiksemel3" do
  action :install
end

package "libiksemel-dev" do
  action :install
end

package "libssh2-php" do
  action :install
end

package "snmp" do
  action :install
end

package "libmysqld-dev" do
  action :install
end

package "libmysqld-pic" do
  action :install
end

package "libmysqlclient-dev" do
  action :install
end

######

group "zabbix" do
  action :create
end

user "zabbix" do
  action :create
  gid "zabbix"
  system true
end

######

#mysql server usuario: root / senha: zabbix
bash "install_mysql_server" do
  user "root"
  ignore_failure true
  code <<-EOH
   (echo "mysql-server-5.5 mysql-server/root_password password zabbix" | debconf-set-selections && echo "mysql-server-5.5 mysql-server/root_password_again password zabbix" | debconf-set-selections && apt-get -y --force-yes install mysql-server-5.5)
  EOH
end

bash "download_zabbix" do
  user "root"
  code <<-EOH
    wget http://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.4.4/zabbix-2.4.4.tar.gz -O /tmp/zabbix-2.4.4.tar.gz
    tar -zxf /tmp/zabbix-2.4.4.tar.gz -C /srv/
  EOH
end

bash "create_database" do
  user "root"
  ignore_failure true
  code <<-EOH
    mysql -uroot -pzabbix -e "create database zabbixdb;"
    mysql -uroot -pzabbix -e "grant all privileges on zabbixdb.* to zabbix@localhost identified by 'zabbix';"
    mysql -u zabbix -pzabbix zabbixdb < /srv/zabbix-2.4.4/database/mysql/schema.sql
    mysql -u zabbix -pzabbix zabbixdb < /srv/zabbix-2.4.4/database/mysql/images.sql
    mysql -u zabbix -pzabbix zabbixdb < /srv/zabbix-2.4.4/database/mysql/data.sql
  EOH
end

bash "install_zabbix" do
  user "root"
  code <<-EOH
   (cd /srv/zabbix-2.4.4/ && ./configure --enable-server --enable-agent --with-mysql --enable-ipv6 --with-snmp --with-libcurl --with-ssh2 && make install)
  EOH
end

cookbook_file "/etc/services" do
  source "services"
  mode 0644
  owner "root"
  group "root"
end

cookbook_file "/usr/local/etc/zabbix_agentd.conf" do
  source "zabbix_agentd.conf"
  mode 0644
  owner "root"
  group "root"
end

cookbook_file "/usr/local/etc/zabbix_server.conf" do
  source "zabbix_server.conf"
  mode 0644
  owner "root"
  group "root"
end

cookbook_file "/etc/php5/apache2/php.ini" do
  source "php.ini"
  mode 0644
  owner "root"
  group "root"
end

service "apache2" do
 action :restart
end

cookbook_file "/etc/init.d/zabbix-agent" do
  source "zabbix-agent"
  mode 0755
  owner "root"
  group "root"
end

cookbook_file "/etc/init.d/zabbix-server" do
  source "zabbix-server"
  mode 0755
  owner "root"
  group "root"
end

service "zabbix-server" do
 action :start
end

service "zabbix-agent" do
 action :start
end

bash "updaterc" do
  user "root"
  ignore_failure true
  code <<-EOH
   update-rc.d -f zabbix-server defaults
   update-rc.d -f zabbix-agent defaults
  EOH
end

bash "create_dir_apache" do
  user "root"
  ignore_failure true
  code <<-EOH
   mkdir -p /var/www/html/zabbix
   cp -a /srv/zabbix-2.4.4/frontends/php/* /var/www/html/zabbix/
   chown -R www-data:www-data /var/www/html/zabbix/
  EOH
end
