% Ansible
% Damien Corral &lt;[damien.corral@mines-paristech.fr](mailto:damien.corral@mines-paristech.fr)&gt;
% Mai 2020 - IUT R&T Administration avancée

# Plan

- Objectifs
- Organisation
- Fondamentaux :
  - Qu'est ce qu'Ansible
  - Pourquoi Ansible ?
  - Concepts

# Objectifs

A la fin de ce module, vous devez être capable de :

- Construire un environnement de gestion
- Maîtriser Ansible et son écosystème
- Écrire des playbooks et des rôles complexes
- Déployer une infrastructure avec Ansible

# Organisation

## Peu de théorie, beaucoup de pratique !

## Séances 1 et 2

- Cours d'introduction à Ansible
- Création de l'environnement de travail
- Découverte pas à pas

## Séances 3 et 4

- Déploiement d'une architecture multi-tiers
- Travaux en autonomie et rendu des playbooks

# Fondamentaux

- Qu'est-ce que "Ansible" ?
- Pourquoi Ansible ?
- Concepts :
  - *Inventory*, *Host* et *Groups*
  - *Module*
  - *Task*
  - *Playbook*
  - *Role*

# Qu'est-ce qu'Ansible ?

## "Ansible Automation Platform" 
## 

Ansible permet *simplement* d'automatiser :

- le provisionnement de machines,
- la gestion des configurations,
- le déploiement d'applications,
- l'orchestration de services.

# Pourquoi Ansible ?

**Simple à comprendre**

- facile à lire et à écrire
- maintenance et évolution aisée

**Apprentissage rapide**

- dérivé du langage YAML
- comme Python, langage "naturel"

# Pourquoi Ansible ?

La preuve :

```yaml
   - name: Mon premier playbook
     hosts: srv1, srv2, srv3
     tasks:
     - name: crée l'utilisateur devops
       user:
         name: devops
         comment: Devops User
         uid: 1040
         group: admin
     - name: installe Apache
       apt:
         name: apache2
         state: present
```

# Pourquoi Ansible ?

**Mise en oeuvre élémentaire**

- une connexion SSH et Python
- déploiement au besoin

**Sécurisé de base**

- pas d'agent exposé
- basé sur une connexion SSH

# Concepts

Pour fonctionner, Ansible a besoin de 2 types de machines :

- Le noeud de contrôle : cette machine va permettre de lancer les commandes Ansible.
- Les noeuds managés : les machines gérées par Ansible sur lesquels sont appliquées les commandes Ansible.

**Pas d'installation d'Ansible sur les hôtes gérés [...]**

**[...] seulement Python et SSH.**

# Inventory, Host et Group

**Inventory**

L'inventaire est la liste des noeuds managés par Ansible.

**Host**

Il contient des informations comme l'adresse IP ou le nom de machine de chaque noeud.

**Group**

Il est également possible d'organiser les hôtes sous forme de groupe et de groupe de groupes pour faciliter les déploiements.

# Inventory, Host et Group

L'inventaire est un simple fichier texte au format INI (ou YAML) :

```ini
[webservers]
www1.example.com
www2.example.com
  
[dbservers]
db0.example.com
db1.example.com

[production:children]
webservers
dbservers
```

# Modules

Les modules sont les unités de code qu'Ansible exécute sur les noeuds managés.

Il est possible d'exécuter un simple module en ligne de commande ou plusieurs modules à partir d'un fichier.

# Task

Une tâche instancie un module pour l'exécuter sur un noeud.

Une tâche unique s'exécute avec la commande `ansible`.

```bash
$ ansible vps01 -m systemd -a \
          "name=nginx state=restarted"
```

# Playbook

Un playbook est une liste ordonnée de tâches à exécuter.

Les playbooks peuvent inclure des variables pour rendre les tâches génériques.

Ils sont écrits en YAML et sont très faciles à lire, à écrire, à comprendre et à partager.

Un playbook s'exécute avec la commande `ansible-playbook`

# Playbook

```yaml
---
# file: nginx.yml

- hosts: vps01
  tasks:
  - name: install nginx
    apt: name=nginx state=present update_cache=yes
```

```bash
$ ansible-playbook nginx.yml
```

# Role

Les rôles sont un moyen d'organiser les variables, les tâches et les gestionnaires au sein d'une même arborescence.

La conversion de playbooks en rôle permet de partager facilement son contenu avec d'autres utilisateurs.
