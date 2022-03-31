# Docker GPU

Cette partie vous permettra de lancer un conteneur docker avec l'utilisation par ce conteneur des ressources GPU de la machine hôte.

## Installation

### Nvidia container runtime

Pour pouvoir utiliser les ressources de la carte graphique NVIDIA présente sur la machine hôte dans un conteneur docker il faut que les drivers de la carte graphique soient correctement installés (la commande `nvidia-smi` doit s'exécuter correctement et afficher les informations de la carte graphique) et le module **nvidia-container-runtime** doit également être installé.

Les commandes suivantes permettent d'installer ce module.

*Ajout du repository NVIDIA*

```sh

curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | sudo apt-key add -

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
```

*Installation du paquet*

```sh
sudo apt update && apt install -y nvidia-container-runtime
```

*Redémarrage du service docker*

```sh
sudo systemctl restart docker
```

*Test de l'installation*

```sh
docker run --rm --gpus all nvidia/cuda:11.6-base nvidia-smi
```

**Note: On peut également installer [nvidia-docker-2](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) qui est équivalent à nvidia-container-runtime**

### Images docker cuda

Des [images docker cuda](https://hub.docker.com/r/nvidia/cuda) officielles sont disponibles sur le docker hub publique et permettent de créer une image docker qui nécessite une certaine version de CUDA.

## Utilisation

Lorsque l'on souhaite utiliser **nvidia-container-runtime**, il faut le préciser au lancement du conteneur avec l'option `--gpus all`. Ce paramètre prend en réalité le nombre de GPUs que l'on souhaite utiliser lorsque la machine hôte en possède plusieurs.

L'installation du paquet **nvidia-container-runtime** a automatiquement ajouté à docker la configuration runtime nvidia.

La commande `cat /etc/docker/daemon.json` doit afficher l'output suivant.

*/etc/docker/daemon.json*

```json
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
```

L'option `--gpus` invoque par défaut l'utilisation de ce runtime permettant d'utiliser les ressources GPUs de la machine hôte. On peut néanmoins le préciser en ajoutant l'option `--runtime nvidia` au lancement d'un conteneur ou même le définir par défaut en ajoutant dans le fichier */etc/docker/daemon.json* `"default-runtime": "nvidia"`.

## Exemple

L'exemple suivant affiche les informations GPU dans le conteneur par l'intermédiaire du framework [tensorflow](https://www.tensorflow.org/?hl=fr).

`docker run --rm --gpus all tensorflow/tensorflow:latest-gpu python -c "import tensorflow as tf;tf.test.gpu_device_name()"`

## Docker compose

Pour utliser **nvidia-container-runtime** dans un conteneur lancé par **docker-compose** on peut préciser dans la configuration yaml l'option `runtime: nvidia`.

*docker-compose.yaml*

```yaml
version: "3.9"

services:
  test:
    image: nvidia/cuda:11.6-base
    command: nvidia-smi
    runtime: nvidia

```

Si l'on souhaite définir plus précisément les ressources allouées, nombre de GPUs utilisés, etc, il faut alors utiliser l'option `deploy` qui permet un paramétrage fin des ressources GPUs.

*docker-compose.yaml*

```yaml
version: "3.9"

services:
  test:
    image: nvidia/cuda:11.6-base
    command: nvidia-smi
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

```

## References

- [Install nvidia container runtime - nvidia.github.io](https://nvidia.github.io/nvidia-container-runtime/)
- [Install nvidia docker - docs.nvidia.com](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)
- [Images docker cuda - hub.docker.com](https://hub.docker.com/r/nvidia/cuda)
- [Utilisation nvidia docker - docs.docker.com](https://docs.docker.com/config/containers/resource_constraints/#gpu)
- [Configuration GPU docker compose - docs.docker.com](https://docs.docker.com/compose/gpu-support/)
- [Tensorflow - tensorflow.org](https://www.tensorflow.org/?hl=fr)
