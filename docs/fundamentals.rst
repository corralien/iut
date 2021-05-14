Fondamentaux
============

Qu'est ce que "Ansible" ?
-------------------------

*"Ansible Automation Platform"*

Ansible permet **simplement** d'automatiser :

- le provisionnement des machines,
- la gestion des configurations,
- le déploiement d'applications,
- l'orchestration des services.

Pourquoi Ansible ?
------------------

**Simple à comprendre**

- facile à lire et à écrire
- maintenance et évolution aisée

**Apprentissage rapide**

- dérivé du langage YAML
- comme Python, langage "naturel"

La preuve :

.. code-block:: yaml+jinja

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

**Mise en oeuvre élémentaire**

- une connexion SSH et Python
- déploiement au besoin

**Sécurisé de base**

- pas d'agent exposé
- basé sur une connexion SSH


Concepts
--------

Pour fonctionner, Ansible a besoin de 2 types de machines :

- Le noeud de contrôle : cette machine va permettre de lancer les commandes Ansible.
- Les noeuds managés : les machines gérées par Ansible sur lesquels sont appliquées les commandes Ansible.

.. note::

   Sur les hôtes gérés, Ansible n'est pas installé, seulement Python.

*Inventory*, *Host* et *Group*
******************************

`L'inventaire <https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html>`_ est la liste des noeuds managés par Ansible. Il contient des informations comme l'adresse IP ou le nom de machine de chaque noeud. Il est également possible d'organiser les hôtes sous forme de groupe et de groupe de groupes pour faciliter les déploiements.

L'inventaire est un simple fichier texte au format INI (ou YAML) :

.. code-block:: cfg

   [webservers]
   www1.example.com
   www2.example.com
   
   [dbservers]
   db0.example.com
   db1.example.com

   [production:children]
   webservers
   dbservers

*Module*
********

`Les modules <https://docs.ansible.com/ansible/latest/modules/modules_by_category.html>`_ sont les unités de code qu'Ansible exécute sur les noeuds managés. Il est possible d'exécuter un simple module en ligne de commande ou plusieurs modules à partir d'un fichier.

*Task*
******

Une tâche instancie un module pour l'exécuter sur un noeud managé. Il est possible d'exécuter une seule tâche à la fois avec la commande :code:`ansible`.

.. code-block:: shell

   $ ansible vps01 -m systemd -a "name=nginx state=restarted"

*Playbook*
**********

`Un playbook <https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html>`_ est une liste ordonnée de tâches à exécuter. Les playbooks peuvent inclure des variables pour rendre les tâches génériques. Ils sont écrits en YAML et sont très faciles à lire, à écrire, à comprendre et à partager :

.. code-block:: yaml

   ---
   # file: nginx.yml

   - hosts: vps01
     tasks:
     - name: install nginx
       apt: name=nginx state=present update_cache=yes

Un playbook est exécuté à l'aide de la commande :code:`ansible-playbook` :

.. code-block:: shell

   $ ansible-playbook nginx.yml

*Role*
******

`Les rôles <https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html>`_ sont un moyen d'organiser les variables, les tâches et les gestionnaires au sein d'une même arborescence. La conversion de playbooks en rôle permet de partager facilement son contenu avec d'autres utilisateurs.

Cette rapide présentation a permis de définir la terminologie utilisée par Ansible. Il est temps de construire un environnement de travail pour mettre en oeuvre ces concepts.
