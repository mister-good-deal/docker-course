# Handle-containers

Cette partie vous permettras de lancer des programmes dans des conteneurs et de les gérer (suppression, persistence, connexion en ligne de commande, ...).

## Wordpress

Ici nous allons lancer un conteneur qui permettra d'utiliser Wordpress sur la machine hôte.

Dans la partie précédente nous avons vu comment créer un conteneur MySQL avec une base de donnée persitante.

Nous utiliserons ici cette base de données et le conteneur Wordpress utilisera le conteneur MySQL pour stocker les informations persisatntes néscessaires.

### Volumes

Nous allons créer des volumes persistants sur le système hôte qui seront accessibles à tous les conteneurs Docker.

*Création d'un volume pour les données de la BDD*

`docker volume create db_data`

*Création d'un volume pour les données internes à Wordpress*

`docker volume create wordpress_data`

### Network

Pour que les conteneurs MySQL et Wordpress puissent communiquer entre eux, il faut qu'ils soient attachés au même réseau.

Pour créer un réseau on utilise la commande `docker network create network_name`, ici on aura `docker network create wordpress_network`.

On peut voir la liste des réseaux disponibles avec la commande `docker network ls`.

### Conteneur MySQL

Nous pouvons maintenant lancer le conteneur MySQL avec les volumes persistants qu'on a précédemment créés, on peut les voir avec la commande `docker volume ls`.

Tout d'abord récupérons la dernière image Wordpress officielle publiée avec la commmande `docker pull mysql:latest`.

Pour lier les volumes on utilise l'option `-v host-volume:container-volume` de la commande `docker run`.

Il faut ensuite définir les informations de connexions à la base de données ainsi que son nom pour que le futur conteneur Wordpress puissent s'y connecter. On réalise cette opération en définissant des variables d'environnements avec l'option `-e var=value`. On obtient ainsi:

`-e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=wordpress`

N'oublions pas d'attacher ce conteneur au réseau `wordpress_network` avec l'option `--network wordpress_network`.

L'option `--rm` permet de supprimer le conteneur automatiquement à la fin de son exécution.

L'option `--name` permet de nommer le conteneur.

On obtient donc la commande suivante: `docker run -v db_data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=wordpress --network wordpress_network --rm --name mysql_wordpress mysql`.

### Conteneur Wordpress

Nous allons maintenant pouvoir lancer le conteneur Wordpress.

Tout d'abord récupérons la dernière image Wordpress officielle publiée avec la commmande `docker pull wordpress:latest`.

Il faudra lier le volume persistant `wordpress_data` au volume du conteneur `/var/www/html` avec l'option `-v wordpress_data:/var/www/html`.

Ensuite il faut expliquer à Wordpress comment se connecter à la base de données PostreSQL avec les informations de connexions, celà se fait en donnant ces informations par des variables d'environnement avec l'option `-e var=value`. On obtient alors les options suivantes:

`-e WORDPRESS_DB_HOST=mysql_wordpress:3306 -e WORDPRESS_DB_USER=wordpress -e WORDPRESS_DB_PASSWORD=wordpress -e WORDPRESS_DB_NAME=wordpress`

Finalement pour rendre l'application accessible sur le port HTTP 8000 du système hôte, on bind le port HTTP 80 du conteneur à ce port avec la commande `-p 8000:80`. L'application sera ensuite accessible à l'addresse `localhost:8000` sur le navigateur web.

N'oublions pas d'attacher ce conteneur au réseau `wordpress_network` avec l'option `--network wordpress_network`.

On obtient donc la commande suivante: `docker run -v wordpress_data:/var/www/html -e WORDPRESS_DB_HOST=mysql_wordpress:3306 -e WORDPRESS_DB_USER=wordpress -e WORDPRESS_DB_PASSWORD=wordpress -e WORDPRESS_DB_NAME=wordpress -p 8000:80 --network wordpress_network --rm --name wordpress wordpress`.

**Et voilà !**

Rendez-vous sur votre navigateur web à l'adresse `localhost:8000` pour utiliser votre application Wordpress.
