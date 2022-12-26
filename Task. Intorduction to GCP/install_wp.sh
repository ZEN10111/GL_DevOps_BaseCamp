sudo apt-get update
sudo apt-get install -y apache2 \
                 ghostscript \
                 libapache2-mod-php \
                 mysql-server \
                 php \
                 php-bcmath \
                 php-curl \
                 php-imagick \
                 php-intl \
                 php-json \
                 php-mbstring \
                 php-mysql \
                 php-xml \
                 php-zip
sudo mkdir -p /srv/www 
sudo chown www-data: /srv/www 
curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www 
sudo touch /etc/apache2/sites-available/wordpress.conf 
sudo echo '<VirtualHost *:80>
    DocumentRoot /srv/www/wordpress
    <Directory /srv/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /srv/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost> ' > /etc/apache2/sites-available/wordpress.conf
sudo a2ensite wordpress
sudo a2enmod rewrite
sudo a2dissite 000-default
sudo service apache2 reload
sudo -u www-data cp /srv/www/wordpress/wp-config-sample.php /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/database_name_here/wordpress/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/username_here/wordpress/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i "s/password_here/${DB_PASSWORD}/" /srv/www/wordpress/wp-config.php
echo "CREATE DATABASE wordpress;" | sudo mysql -u root
echo "CREATE USER wordpress@localhost IDENTIFIED BY '${DB_PASSWORD}';" | sudo mysql -u root
echo "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost;" | sudo mysql -u root 
echo "FLUSH PRIVILEGES;" | sudo mysql -u root 
sudo service mysql start



