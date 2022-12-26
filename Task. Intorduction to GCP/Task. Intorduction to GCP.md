hometask4.tf - main terraform file
install_wp.sh -script  that  install wordpres
db_pass.txt - file that stored user database password

hometask4.tf 
1)  Init autorization/ project data

provider "google" {
  credentials = file("put_file.json")
  project     = "put_project_name"
  region      = "us-central1"
  zone        = "europe-west3-c"
}

2) create network/subnetwork

resource "google_compute_network" "private" {
  name = "my-network"
}

resource "google_compute_subnetwork" "private" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.private.id
}

3) create  instance

resource "google_compute_instance" "webserver" {
  name         = "webserver"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["http-server", "ssh", "icmp"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      labels = {
        my_label = "web_server"
      }
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private.id
    access_config {
    }
  }

 metadata_startup_script =  templatefile("D:\\GCP\\install_wp.sh", {
    DB_PASSWORD = file("db_pass.txt")
})
 
}

4)  create  firewall rules open  http and  ssh port

resource "google_compute_firewall" "rules" {
  project     = "pro-zone-372114"
  name        = "my-firewall-rule"
  network     =  google_compute_network.private.id
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
  
}

resource "google_compute_firewall" "ssh" {
  name    = "ssh"
  network = google_compute_network.private.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh"]
}

install_wp.sh 

1) install packages

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

2) process of  install and  configure  wordpres/apache2

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

3) setup database  data

echo "CREATE DATABASE wordpress;" | sudo mysql -u root
echo "CREATE USER wordpress@localhost IDENTIFIED BY '${DB_PASSWORD}';" | sudo mysql -u root
echo "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost;" | sudo mysql -u root 
echo "FLUSH PRIVILEGES;" | sudo mysql -u root 
sudo service mysql start

db_pass.txt 

put_pass_here

![изображение](https://user-images.githubusercontent.com/97990456/209515254-d3d3d8bb-75eb-4848-9ad8-0ff1889e55cb.png)

![изображение](https://user-images.githubusercontent.com/97990456/209515357-b36c0f30-de2b-4ff4-afc0-7c5da532b38d.png)
![изображение](https://user-images.githubusercontent.com/97990456/209515422-94928cb7-0896-41aa-85bc-1f9495444377.png)


