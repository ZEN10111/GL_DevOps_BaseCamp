![изображение](https://user-images.githubusercontent.com/97990456/206883113-d08c8fdb-1077-4a07-9f60-0f6c7298534a.png)
![изображение](https://user-images.githubusercontent.com/97990456/206883117-fec2b1dd-9ff8-4884-bc79-b5bf113f21d0.png)


#cloud-config
package_upgrade: true
packages:
  - nginx
  - git
write_files:
  - owner: www-data:www-data
    path: /etc/nginx/sites-available/default
    content: |
      server {
        listen 80;
		root /var/www/html/site;
        location / {
      }
        }		
runcmd:
  - cd "/var/www/html/"
  - git clone https://github.com/ZEN10111/site.git
  - cd "/var/www/html/site"
  - sed -i "s/%%hostname%%/$(hostname)/" index.html
  - service nginx restart

