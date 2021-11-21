#!/bin/bash

# Create persistant volumes
docker volume create db_data
docker volume create wordpress_data

# Create containers's network
docker network create wordpress_network

# Retrieve MySQL image
docker pull mysql:latest

# Launch MySQL container
docker run -v db_data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress \
       -e MYSQL_PASSWORD=wordpress --network wordpress_network --rm --name mysql_wordpress mysql

# Retrieve Wordpress image
docker pull wordpress:latest

# Launch Wordpress container
docker run -v wordpress_data:/var/www/html -e WORDPRESS_DB_HOST=mysql_wordpress:3306 -e WORDPRESS_DB_USER=wordpress \
       -e WORDPRESS_DB_PASSWORD=wordpress -e WORDPRESS_DB_NAME=wordpress -p 8000:80 --network wordpress_network --rm --name wordpress wordpress
