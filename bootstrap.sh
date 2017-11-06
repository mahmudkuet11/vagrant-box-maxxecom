#!/usr/bin/env bash

sudo apt-get update -y


# Nginx

sudo apt-get install nginx -y


# PHP

sudo add-apt-repository ppa:ondrej/php -y

sudo apt-get update -y

sudo apt-get install php7.1 php-fpm php-mysql php-xml php-curl php-mbstring zip php-zip mcrypt php-mcrypt -y

sudo sed -ie "s/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo = 0/g" /etc/php/7.1/fpm/php.ini

sudo service php7.1-fpm restart


#Debconf

sudo apt-get install debconf-utils -y


# MySql

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

sudo apt-get install mysql-server -y

mysql -uroot -proot -e "create database maxxecom;"

sudo sed -ie "s/.*bind-address.*/# bind-address = 127.0.0.1/g" /etc/mysql/mysql.conf.d/mysqld.cnf

mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'maxxecom'@'%' IDENTIFIED BY '1234' WITH GRANT OPTION; FLUSH PRIVILEGES;"

sudo service mysql restart

# Phpmyadmin

sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"

sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password root"

sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password root"

sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password root"

sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect"

sudo apt-get install phpmyadmin -y

sudo mv /usr/share/phpmyadmin /var/www/phpmyadmin

# Vhost

sudo cp /var/www/config/nginx_vhost /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/nginx_vhost /etc/nginx/sites-enabled/
sudo service nginx restart


# Node

sudo apt-get install nodejs -y

sudo ln -s /usr/bin/nodejs /usr/bin/node

sudo apt-get install npm -y


# Redis

sudo apt-get install redis-server -y


# Permissions

sudo chmod -R 777 /var/www/src/storage/
sudo chmod -R 777 /var/www/src/bootstrap/cache/


# Supervisor

sudo apt-get install supervisor -y
sudo mkdir /var/www/log
sudo cp /var/www/config/maxxecom_worker.conf /etc/supervisor/conf.d/
sudo cp /var/www/config/maxxecom_node_worker.conf /etc/supervisor/conf.d/
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start maxxecom-worker:*
sudo supervisorctl start maxxecom-node-worker:*
