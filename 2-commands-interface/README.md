## Commands-interface

Cette partie vous fera découvrir l'interface de commandes docker qui est assez riche au travers de différents exemples.

## Sémantique

Toutes les commandes docker commencent par le mot clé `docker` suivi de la commande à réaliser. Par exemple `docker version` qui affiche la version de docker installée sur votre système.

*Exemple:*

`docker version`

```
Client: Docker Engine - Community
 Version:           20.10.8
 API version:       1.41
 Go version:        go1.16.6
 Git commit:        3967b7d
 Built:             Fri Jul 30 19:54:27 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.8
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.16.6
  Git commit:       75249d8
  Built:            Fri Jul 30 19:52:33 2021
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.4.9
  GitCommit:        e25210fe30a0a703442421b0f60afac609f950a3
 nvidia:
  Version:          1.0.1
  GitCommit:        v1.0.1-0-g4144b63
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```

Comme dans tous les menus de commandes qui se respectent, à chaque niveau de la commande on peut terminer avec le mot clé `help` pour découvrir l'utilisation et les choix possibles de la commande.

*Exemple:*

`docker help`

```
Usage:  docker [OPTIONS] COMMAND

A self-sufficient runtime for containers

Options:
      --config string      Location of client config files (default "/home/rom1/.docker")
  -c, --context string     Name of the context to use to connect to the daemon (overrides DOCKER_HOST env var and default context set with "docker context use")
  -D, --debug              Enable debug mode
  -H, --host list          Daemon socket(s) to connect to
  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA (default "/home/rom1/.docker/ca.pem")
      --tlscert string     Path to TLS certificate file (default "/home/rom1/.docker/cert.pem")
      --tlskey string      Path to TLS key file (default "/home/rom1/.docker/key.pem")
      --tlsverify          Use TLS and verify the remote
  -v, --version            Print version information and quit

Management Commands:
  app*        Docker App (Docker Inc., v0.9.1-beta3)
  builder     Manage builds
  buildx*     Build with BuildKit (Docker Inc., v0.6.1-docker)
  config      Manage Docker configs
  container   Manage containers
  context     Manage contexts
  image       Manage images
  manifest    Manage Docker image manifests and manifest lists
  network     Manage networks
  node        Manage Swarm nodes
  plugin      Manage plugins
  scan*       Docker Scan (Docker Inc., v0.8.0)
  secret      Manage Docker secrets
  service     Manage services
  stack       Manage Docker stacks
  swarm       Manage Swarm
  system      Manage Docker
  trust       Manage trust on Docker images
  volume      Manage volumes

Commands:
  attach      Attach local standard input, output, and error streams to a running container
  build       Build an image from a Dockerfile
  commit      Create a new image from a container's changes
  cp          Copy files/folders between a container and the local filesystem
  create      Create a new container
  diff        Inspect changes to files or directories on a container's filesystem
  events      Get real time events from the server
  exec        Run a command in a running container
  export      Export a container's filesystem as a tar archive
  history     Show the history of an image
  images      List images
  import      Import the contents from a tarball to create a filesystem image
  info        Display system-wide information
  inspect     Return low-level information on Docker objects
  kill        Kill one or more running containers
  load        Load an image from a tar archive or STDIN
  login       Log in to a Docker registry
  logout      Log out from a Docker registry
  logs        Fetch the logs of a container
  pause       Pause all processes within one or more containers
  port        List port mappings or a specific mapping for the container
  ps          List containers
  pull        Pull an image or a repository from a registry
  push        Push an image or a repository to a registry
  rename      Rename a container
  restart     Restart one or more containers
  rm          Remove one or more containers
  rmi         Remove one or more images
  run         Run a command in a new container
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  search      Search the Docker Hub for images
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE
  top         Display the running processes of a container
  unpause     Unpause all processes within one or more containers
  update      Update configuration of one or more containers
  version     Show the Docker version information
  wait        Block until one or more containers stop, then print their exit codes

Run 'docker COMMAND --help' for more information on a command.

To get more help with docker, check out our guides at https://docs.docker.com/go/guides/
```

## Management Commands

Le système de "Management Commands" permet de mieux comprendre ce que va faire la commande qu'on choisi d'exéuter.

Il classe les commandes par catégories comme **image** ou **container** qui sont des mots clés à rajouter après le mot clé `docker` dans la commande.

Ainsi si on veut lister toutes les images docker du systèmes, on utilisera `docker image ls`. Si on veut lister tous les conteneurs actifs du système on utilisera `docker container ls`. Si on veut savoir les actions possibles dans une catégories, il suffira d'indiquer `docker [catégorie] help` qui listera les options possibles.

*Liste des catégories de commandes*

- app*        Docker App (Docker Inc., v0.9.1-beta3)
- builder     Manage builds
- buildx*     Build with BuildKit (Docker Inc., v0.6.1-docker)
- config      Manage Docker configs
- container   Manage containers
- context     Manage contexts
- image       Manage images
- manifest    Manage Docker image manifests and manifest lists
- network     Manage networks
- node        Manage Swarm nodes
- plugin      Manage plugins
- scan*       Docker Scan (Docker Inc., v0.8.0)
- secret      Manage Docker secrets
- service     Manage services
- stack       Manage Docker stacks
- swarm       Manage Swarm
- system      Manage Docker
- trust       Manage trust on Docker images
- volume      Manage volumes
