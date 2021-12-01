# Docker compose

Cette partie vous fera découvrir l'outil **docker compose** qui facilite grandement l'utilisation de docker en paramétrant les étapes de build et d'exécution de conteneurs au sein d'un même fichier de configuration au format yaml: **docker-compose.yaml**.

## Installation

Pour installer docker compose la procédure est disponible sur [github](https://github.com/docker/compose#where-to-get-docker-compose).

Il s'agit de copier un exécutable dans un répertoire de votre système accessible depuis la variable d'environnement `$PATH`.

Pour celà on peut utiliser le script suivant:


```sh
cd ~
wget https://github.com/docker/compose/releases/download/v2.1.1/docker-compose-linux-x86_64
mkdir -p ~/.docker/cli-plugins
mv docker-compose-linux-x86_64 ~/.docker/cli-plugins/docker-compose
sudo chmod +x ~/.docker/cli-plugins/docker-compose

# Ajouter ~/.docker/cli-plugins dans votre variable d'environnement #PATH
echo -e '\nPATH="$PATH:~/.docker/cli-plugins"\nexport PATH\n' >> ~/.bashrc
source ~/.bashrc
```

## Principe d'utilisation

Docker compose va simplifier la construction d'images et la gestion de conteneurs au sein d'un même fichier de configuration **docker-compose.yaml**.

Dans ce fichier on pourra définir les options de build d'images ainsi que la façon dont lancer des conteneurs.

Il sera ensuite possible d'exécuter ces tâches avec une simple commande `docker-compose build` pour construire les images ou `docker-compose up` pour lancer les conteneurs.

### Commandes de docker compose

Les différentes commandes de docker compose sont accesssibles avec la commande `docker-compose --help`.

*Commandes de docker compose*

```
Define and run multi-container applications with Docker.

Usage:
  docker-compose [-f <arg>...] [--profile <name>...] [options] [--] [COMMAND] [ARGS...]
  docker-compose -h|--help

Options:
  -f, --file FILE             Specify an alternate compose file
                              (default: docker-compose.yml)
  -p, --project-name NAME     Specify an alternate project name
                              (default: directory name)
  --profile NAME              Specify a profile to enable
  -c, --context NAME          Specify a context name
  --verbose                   Show more output
  --log-level LEVEL           Set log level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
  --ansi (never|always|auto)  Control when to print ANSI control characters
  --no-ansi                   Do not print ANSI control characters (DEPRECATED)
  -v, --version               Print version and exit
  -H, --host HOST             Daemon socket to connect to

  --tls                       Use TLS; implied by --tlsverify
  --tlscacert CA_PATH         Trust certs signed only by this CA
  --tlscert CLIENT_CERT_PATH  Path to TLS certificate file
  --tlskey TLS_KEY_PATH       Path to TLS key file
  --tlsverify                 Use TLS and verify the remote
  --skip-hostname-check       Don't check the daemon's hostname against the
                              name specified in the client certificate
  --project-directory PATH    Specify an alternate working directory
                              (default: the path of the Compose file)
  --compatibility             If set, Compose will attempt to convert keys
                              in v3 files to their non-Swarm equivalent (DEPRECATED)
  --env-file PATH             Specify an alternate environment file

Commands:
  build              Build or rebuild services
  config             Validate and view the Compose file
  create             Create services
  down               Stop and remove resources
  events             Receive real time events from containers
  exec               Execute a command in a running container
  help               Get help on a command
  images             List images
  kill               Kill containers
  logs               View output from containers
  pause              Pause services
  port               Print the public port for a port binding
  ps                 List containers
  pull               Pull service images
  push               Push service images
  restart            Restart services
  rm                 Remove stopped containers
  run                Run a one-off command
  scale              Set number of containers for a service
  start              Start services
  stop               Stop services
  top                Display the running processes
  unpause            Unpause services
  up                 Create and start containers
  version            Show version information and quit
```

### Fichier de configuration

Le fichier de configuration **docker-compose.yaml** est écrit au format YAML à la racine de votre projet.

Il commence par la version de docker compose pour lequel le fichier est écrit, par exemple `version: "3.9"`.

Ensuite on définit les services de votre projet dans la partie `services`.

On nomera les services et on définira ensuite pour chaque service l'image docker associée avec le mot clé `image`.

Par exemple si je veux que mon service utlise la dernière version de MySQL on écrira:

```yaml
version: "3.9"
    
services:
  mysql:
    image: mysql:latest

```

#### Network

On peut définir un network dans le fichier de configuration mais tous les services d'un même fichier sont automatiquement ajoutés à un même réseau qui sera créé au lancement des conteneurs.

#### Volumes

On peut créer des volumes persistants avec le mot clé `volumes` suivi des noms des volumes choisis.

*exemple*

```yaml
volumes:
  db_data: {}
  wordpress_data: {}

```

#### Options

Il y a ensuite une foultitude d'options que l'on peut ajouter selon la configuration souhaitée.

Une liste exhaustive de ces options est disponible dans la [documentation officielle](https://docs.docker.com/compose/compose-file/compose-file-v3/) de docker compose.

Parmi ces options on retrouvera la possibilité de définir un port d'écoute vers le système hôte ou de définir des variables d'environnements.

## Exemple Wordpress

Si vous avez suivi le module 4, toutes les commandes effectuées pour lancer l'application Wordpress avec la base de données MySQL peuvent être résumées dans le fichier de configuration suivant :

*docker-compose.yaml*

```yaml
version: "3.9"
    
services:
  mysql_wordpress:
    image: mysql:latest
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: somewordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
    
  wordpress:
    depends_on:
      - mysql_wordpress
    image: wordpress:latest
    volumes:
      - wordpress_data:/var/www/html
    ports:
      - "8000:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: mysql_wordpress:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress

volumes:
  db_data: {}
  wordpress_data: {}

```

Il suffit ensuite d'exécuter la commande `docker-compose up`.

**Et voilà !**

Rendez-vous sur votre navigateur web à l'adresse `localhost:8000` pour utiliser votre application Wordpress.

## References

- [Install docker compose - github.com](https://github.com/docker/compose#where-to-get-docker-compose)
- [Fichier docker-compose.yaml pour wordpress - docs.docker.com](https://docs.docker.com/samples/wordpress/)
- [Docker compose V2 - docs.docker.com](https://docs.docker.com/compose/cli-command/)
