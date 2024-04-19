#!/bin/bash

# UPDATING & UPGRADING THE SERVER

apt update && apt upgrade -y < /dev/null


# INSTALLATION OF LAMP STACK

apt-get install apache2 -y < /dev/null

apt install ansible -y < /dev/null

apt-get install mysql-server -y < /dev/null

add-apt-repository -y ppa:ondrej/php < /dev/null

apt-get update < /dev/null

apt-get install libapache2-mod-php php php-common php-xml php-mysql php-gd php-mbstring php-tokenizer php-json php-bcmath php-curl php-zip unzip -y < /dev/null

sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.2/apache2/php.ini

systemctl restart apache2 < /dev/null


# INSTALL COMPOSER


apt install curl -y 

curl -sS https://getcomposer.org/installer | php 

mv composer.phar /usr/local/bin/composer 

composer --version < /dev/null


# CONFIGURATION OF APACHE2

cat << EOF > /etc/apache2/sites-available/laravel.conf
<VirtualHost *:80>
    ServerAdmin admin@admin.com
    ServerName 192.168.50.9
    DocumentRoot /var/www/html/laravel/public

    <Directory /var/www/html/laravel>
    Options Indexes MultiViews FollowSymLinks
    AllowOverride All
    Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

a2enmod rewrite 

a2ensite laravel.conf

systemctl restart apache2


# CLONE LARAVEL APPLICATION AND DEPENDENCIES


mkdir /var/www/html/laravel && cd /var/www/html/laravel

cd /var/www/html && git clone https://github.com/laravel/laravel.git

cd /var/www/html/laravel && composer install --no-dev < /dev/null

chown -R www-data:www-data /var/www/html/laravel

chmod -R 775 /var/www/html/laravel

chmod -R 775 /var/www/html/laravel/storage

chmod -R 775 /var/www/html/laravel/bootstrap/cache

cd /var/www/html/laravel && cp .env.example .env

php artisan key:generate


# CONFIGURING MYSQL: CREATING USER AND PASSWORD


echo "Creating MySQL user and database"
PASS=$2
if [ -z "$2" ]; then
  PASS=`openssl rand -base64 8`
fi

mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE $1;
CREATE USER '$1'@'localhost' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON $1.* TO '$1'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL user and database created."
echo "Username:   $1"
echo "Database:   $1"
echo "Password:   $PASS"


# EXECUTE KEY GENERATE AND MIGRATE COMMAND FOR PHP

sed -i 's/DB_DATABASE=laravel/DB_DATABASE=lydia/' /var/www/html/laravel/.env

sed -i 's/DB_USERNAME=root/DB_USERNAME=lydia/' /var/www/html/laravel/.env

sed -i 's/DB_PASSWORD=/DB_PASSWORD=lydia1/' /var/www/html/laravel/.env

php artisan config:cache

cd /var/www/html/laravel && php artisan migrate
