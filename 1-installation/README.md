## Installation

Cette partie explique comment installer docker sur un environnement Ubuntu.

## Ubuntu

[Suivez le guide](https://docs.docker.com/engine/install/ubuntu/)

Récapitulatif des commandes :

`sudo apt-get update`

```shell
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg`

```shell
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

`sudo apt-get update`

`sudo apt-get install docker-ce docker-ce-cli containerd.io`

`sudo docker run hello-world`

## Bonus

Pour éviter de devoir exécuter les commandes docker avec les droits sudo, exécuter la commande suivante: `sudo usermod -aG docker ${USER}`

Puis redémarrer l'ordinateur.

## Références

[Install Docker Engine on Ubuntu - docker.com](https://docs.docker.com/engine/install/ubuntu/)