#!/bin/bash

#install webserver using this command, needed for apache, we will use package manager called yum
echo "#############################################"
echo "#                                           #"
echo "#  Finalboss.sh script has been INITIATED!  #"
echo "#                                           #"
echo "#############################################"
yum install -y httpd

#to start apache in your VM
echo "Now starting HTTPD"
systemctl start httpd.service

#needed for firewalld to allow traffic to the webserver, normal traffic uses port 80 while encrypted web traffic uses port 443
echo "These are our firewall rules"
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
#need to reload the firewall to apply the changes.
firewall-cmd --reload

#this is to enable apache to start on boot.
echo "httpd is now enabled"
systemctl enable httpd

#needed packages to install
echo "Now installing FedoraProject, Remirepo, and Utils"
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install -y yum-utils
yum-config-manager --enable remi-php56

#these are needed to update and install PHP modules to enhance the functionality of PHP
echo "Installing PHP and all the needed packages to function"
yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo

#restart the webserver to apply the changes above.
echo "Now restarting HTTPD"
systemctl restart httpd

cd /var/www/html/
echo '<?php phpinfo(); ?>' > index.php

#to install the software helper known as MariaDB package so that our components can communicate with eachother.
echo "Now installing MariaDB"
yum install -y mariadb-server mariadb

#after installing, you need to start mariadb with this command.
echo "Now starting MariaDB"
systemctl start mariadb

#after it is running, you need a simple security script that removes dangerous defaults and lock down access to your database system.
echo "Now running a securiy script to remove dangerous defaults and locking down your database"
mysql_secure_installation <<EOF

y
rcanlas1
rcanlas1
y
y
y
y
EOF

#this is to enable mariadb on boot.
echo "Now enabling MariaDB"
systemctl enable mariadb

#these are the password and database name.
echo "Enabling MariaDB"
passw=rcanlas1
dbname=wordpress

#this is to verify that the installion was completed"
echo "Verifying Installation"
mysqladmin -u root -p$passw version


echo "CREATE DATABASE wordpress; CREATE USER aufralph@localhost IDENTIFIED BY 'rcanlas1'; GRANT ALL PRIVILEGES ON wordpress.* TO aufralph@localhost IDENTIFIED BY 'rcanlas1'; FLUSH PRIVILEGES; show databases;" | mysql -u root -p$passw

echo "now restarting Apache"
service httpd restart

#this is needed to install wget
echo "Now installing wget"
yum install -y wget

#you need this to install tar"
echo "Now installing tar"
yum install -y tar

cd /opt/
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz

#We need to install rsync to move some things around and use sed to edit wp-config.php for our account details.
echo "now installing rsync"
yum install -y rsync
rsync -avP wordpress/ /var/www/html/
cd /var/www/html/
mkdir /var/www/html/wp-content/uploads
chown -R apache:apache /var/www/html/*
cp wp-config-sample.php wp-config.php
sed -i 's/database_name_here/wordpress/g' wp-config.php
sed -i 's/username_here/aufralph/g' wp-config.php
sed -i 's/password_here/rcanlas1/g' wp-config.php

echo "Restarting HTTPD"
systemctl restart httpd.service
echo "#############################################"
echo "#                                           #"
echo "#  	SALAMAT PO SA LAHAT SIR JAI!!         #"
echo "#                                           #"
echo "#############################################"



