# Build-image

Cette partie vous permettra de construire une image docker en ligne de commande avec un fichier **Dockerfile**.

## Dockerfile

Le **Dockerfile** est une recette de cuisine qui contient toutes les instructions pour construire une image docker.

Il permet d'historiser les commandes qui vous ont permis de construire l'environnement que vous souhaitez, un petit peu à l'instar de git qui historise le code que vous écrivez.

Les instructions de ce fichier reflètent en réalité les commandes que vous auriez écrit dans un véritable environnement linux, par exemple `apt install python`.

Chaque exécution d'une ligne de commande dans le Dockerfile rajoute un "layer" à l'image qui sera construite. L'image sera donc une succession de couches (layers) et aura comme point de départ une autre image déjà construite (comme une image ubuntu, centos ou tensorflow).

## Commandes Dockerfile

Les différents mots clés suivants constituent les différentes commandes qu'on peut exécuter dans un Dockerfile

|Ordre|Instruction|Description|
|-----|-----------|-----------|
|1|FROM|Image parente|
|2|MAINTAINER|Auteur|
|3|ARG|Variables passées comme paramètres à la construction de l'image|
|4|ENV|Variable d'environnement|
|4|LABEL|Ajout de métadonnées|
|5|VOLUME|Crée un point de montage|
|6|RUN|Commande(s) utilisée(s) pour construire l'image|
|(6)|(ADD)|(Ajoute un fichier dans l'image \*[ADD vs COPY](https://nickjanetakis.com/blog/docker-tip-2-the-difference-between-copy-and-add-in-a-dockerile))|
|6|COPY|Ajoute un fichier dans l'image|
|6|WORKDIR|Permet de changer le chemin courant|
|7|EXPOSE|Port(s) écouté(s) par le conteneur|
|8|USER|Nom d'utilisateur ou UID à utiliser|
|9|ONBUILD|Instructions exécutées lors de la construction d'images enfants|
|10|CMD|Exécuter une commande au démarrage du conteneur|
|10|ENTRYPOINT|Exécuter une commande au démarrage du conteneur|

## Structure

Un Dockerfile commence généralement par l'instruction `FROM` qui récupère une image de base de l'image à construire.

Ensuite les instructions `ARG` et `ENV` définissent des variables qui seront utilisées dans le reste du Dockerfile.

Généralement on assiste ensuite à une succession d'instructions `RUN` qui exécutent des commandes pour installer des librairies ou autres au sein de l'image.

Après cela il y a souvent une ou plusieurs instructions `ADD` qui copie des fichiers ou dossiers du système hôte vers l'image docker.

Enfin il peut y avoir des instructions type `EXPOSE` pour exposer un port au lancement d'un conteneur sur cette image ou `CMD` pour exécuter une commande au lancement de l'image dans un conteneur.

*Exemple de Dockerfile*

```Dockerfile
# syntax=docker/dockerfile:1
FROM ubuntu:16.04

# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

# Add PostgreSQL's repository. It contains the most recent stable release
#  of PostgreSQL.
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install ``python-software-properties``, ``software-properties-common`` and PostgreSQL 9.3
#  There are some warnings (in red) that show up during the build. You can hide
#  them by prefixing each apt-get statement with DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y python-software-properties software-properties-common postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3

# Note: The official Debian and Ubuntu images automatically ``apt-get clean``
# after each ``apt-get``

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]

```

## Build l'image

Une fois que le Dockerfile est prêt, il faut construire l'image en ligne de commande: c'est l'étape du build.

Pour consstruire une image il faut indiquer son emplacement et son tag de version à la commande `docker build`.

N'hésitez pas à exécuter `docker build help` pour bien comprendre les choix possibles.

La commande pour build le Dockerfile précédent serait par exemple: `docker build -t eg_postgresql .`. Le `.` va automatiquement chercher le fichier `Dockerfile` dans le système de fichier courant à l'endroit où on exécute la commande. Si le Dockerfile porte un autre nom comme par exemple `PostreSQL.Dockerfile` on aurait pu écrire `docker build -t eg_postgresql PostreSQL.Dockerfile`.

Et voilà, l'image est construite ! Pour la retrouver on peut maintenant exécuter `docker image ls` et vous la verrez dans la liste des images disponibles sur votre système.

## Exécuter l'image dans un conteneur

Une fois l'image construite est disponible sur le système, on peut l'utliser dans un conteneur pour travailler dessus en l'appelant par son tag (ici `eg_postgresql`).

*Exemple:* `docker run --rm -P --name pg_test eg_postgresql`

## Références

[Docker cheat sheet - gist.github.com](https://gist.github.com/jpchateau/4efb6ed0587c1c0e37c3#instructions-dockerfile)
[Dockerfile reference - docker.com](https://docs.docker.com/engine/reference/builder/#/dockerfile-reference)
[Dockerize PostgreSQL - docker.com](https://docs.docker.com/samples/postgresql_service/)
