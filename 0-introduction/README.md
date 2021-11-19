# Introduction

Cette partie vous fera découvrir le fonctionement de docker au travers des concepts de **image**, **container** et **hub**.

## Qu'est-ce que docker ?

Docker est une plate-forme logicielle qui vous permet de concevoir, tester et déployer des applications rapidement. Docker intègre les logiciels dans des unités normalisées appelées conteneurs, qui rassemblent tous les éléments nécessaires à leur fonctionnement, dont les bibliothèques, les outils système, le code et l'environnement d'exécution. Avec Docker, vous pouvez facilement déployer et dimensionner des applications dans n'importe quel environnement, avec l'assurance que votre code s'exécutera correctement.

## Pourquoi utiliser Docker

Docker vous permet d'envoyer du code plus rapidement, de standardiser les opérations de vos applications, de migrer aisément du code et de faire des économies en améliorant l'utilisation des ressources. Avec Docker, vous obtenez un objet unique que vous pouvez exécuter n'importe où de manière fiable. Grâce à sa syntaxe simple, Docker vous confère le contrôle total. Comme Docker est adopté à grande échelle, il s'accompagne d'un solide écosystème d'outils et d'applications standard.

## Image docker

L'image docker est le réceptacle du programme que vous avez conçu. C'est cette image qui pourra ensuite être transférée et utilisée par quelqu'un.

L'image est définie par son nom qui contient le **nom de l'éditeur** suivi du **nom du projet** puis d'un **tag** de version permettant d'historiser les différentes versions d'un même programmes.

*Exemples d'image:*

- nvidia/cuda:10.2-devel-ubuntu18.04
- nvidia/cuda:11.5-devel-ubuntu20.04
- tensorflow/tensorflow:2.7.0-gpu
- tensorflow/tensorflow:2.7.0-gpu-jupyter

## Conteneur docker

Un conteneur docker est une fenêtre sur une image docker.

Le conteneur est indépendant et persistant (on peut retrouver l'état dans lequel on l'a laissé quand on se reconnecte à lui).

Il peut y avoir plusieurs conteneurs différents qui utilise une même image docker.

Chaque conteneur apporte des modifications à l'image qu'il utilise dans l'environnement qui lui est propre (exécution de commandes dans cet environnement) **mais sans modifier l'image docker qu'il utilise**.

Un conteneur est défini par son nom qui représente généralement sa fonction, s'il n'a pas de nom le système lui en génère un au hasard.

Les conteneurs peuvent intérargir entre eux au sein d'un même réseau.

Les conteneurs peuvent être démarrés, stoppés, supprimés, repris ...


## Hub

Le [docker hub](https://hub.docker.com/) est une bibliothèque en ligne où les éditeurs peuvent stocker leur images docker fabriquées pour qu'elles soient facilement récupérables et utilisables par tout le monde. On appelle cette bibliothèque un **registry**.

Ainsi les grandes entreprises comme Google, Nvidia ou Ubuntu mettent à disposition des images prettent à l'emploie qui facilitent grandement la création de nouvelles images à partir de ces dernières.

*Exemples de récupération d'image docker en ligne de commande:*

- `docker pull tensorflow/tensorflow:2.7.0-gpu-jupyter`

- `docker pull ubuntu:22.04`

*Note: La mise en place d'un "docker registry souverrain" (hébergé dans son entreprise) est possible et permet d'avoir une bibiliothèque d'images docker internes à l'entreprise.*

## Shéma récapitulatif

[schéma](https://docs.docker.com/engine/images/architecture.svg)

## Références

[Qu'est-ce que Docker ? - AWS](https://aws.amazon.com/fr/docker/)
[docker hub - hub.docker.com](https://hub.docker.com/)
[Docker architecture - docker.com](https://docs.docker.com/get-started/overview/#docker-architecture)
