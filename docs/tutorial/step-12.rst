Les rôles
---------

Alors qu'il est possible d'écrire un playbook dans un fichier très large, il est préférable d'organiser vos tâches en rôle. Imaginez votre serveur web avec le très classique LAMP (Linux, Apache, MySQL et PHP). Chacun des composants représente un rôle. L'avantage de cette décomposition est qu'il peut vous permettre d'installer Apache et PHP sur un serveur et MySQL sur un autre tout en configurant Linux sur tous les serveurs.

Tout comme l'idempotence, les rôles sont primordiaux dans la gestion des configurations. Outre leur simplicité d'écriture, le succès d'Ansible tient dans la richesse des rôles mis à disposition de tous sur la plateforme `Ansible Galaxy <https://galaxy.ansible.com/>`_.

Nginx
*****

L'étape suivante consiste donc à transformer le playbook :code:`nginx.yml` en un rôle réutilisable.

Commencez par créer les répertoires et fichiers suivants :

.. code-block:: shell

   roles
   └── nginx
       ├── handlers
       │   └── main.yml
       └── tasks
           └── main.yml

Puis copiez le fichier de configuration et la page web dans le répertoire du rôle :

.. code-block:: shell

   (venv)$ cp -R data/{files,templates} roles/nginx/

Copiez le contenu des sections :code:`tasks` et :code:`handlers` du playbook :code:`web.yml` dans leur fichier :code:`main.yml` respectif en faisant bien **attention à l'indentation**. Editez le fichier :code:`main.yml` du répertoire :code:`tasks` et appliquez les changements suivants :

.. code-block:: diff

   @@ -6,7 +6,7 @@
   
      - name: configure default vhost
        copy:
   -      src: data/files/default
   +      src: files/default
          dest: /etc/nginx/sites-available/default
        notify: restart nginx
   
   @@ -19,5 +19,5 @@
   
      - name: copy index.html
        template:
   -      src: data/templates/index.html.j2
   +      src: templates/index.html.j2
          dest: /var/www/html/index.html


Maintenant que notre rôle est créé, il faut un playbook pour pouvoir l'utiliser :

.. code-block:: yaml+jinja
   :linenos:

   ---
   # file: lamp.yml
   
   - hosts: web
     roles:
     - nginx

Désinstallez le package :code:`nginx-full` avec la commande :code:`ansible` sur un ou plusieurs de vos serveurs afin de tester les modifications et lancez le playbook :code:`lamp.yml`.

.. admonition:: Question

   Qu'observez vous dans la sortie de la commande (indice : regardez le nom des tâches) ?

MariaDB
*******

Plutôt que d'écrire des rôles, il est possible également d'utiliser des rôles développés par d'autres utilisateurs. C'est ce que vous allez faire dans cette section avec la commande :code:`ansible-galaxy`.

Vous allez utiliser un rôle développé par `Jeff Geerling <https://www.jeffgeerling.com>`_, un acteur incontournable d'Ansible, pour installer MySQL/MariaDB sur vos serveurs. Retrouvez le rôle sur `GitHub <https://github.com/geerlingguy/ansible-role-mysql>`_ et sur `Galaxy <https://galaxy.ansible.com/geerlingguy/mysql>`_.

Installez le rôle sur votre manager :

.. code-block:: shell

   (venv)$ ansible-galaxy install geerlingguy.mysql

Le rôle se trouve dans le répertoire :code:`.ansible/roles/geerlingguy.mysql`


.. code-block:: yaml+jinja
   :linenos:

   ---
   # file: lamp.yml
   
   - hosts: web
     vars:
       mysql_python_package_debian: 'python3-mysqldb'
       mysql_packages: ['mariadb-client', 'mariadb-server']
   
     roles:
     - role: nginx
       tags: nginx
     - role: geerlingguy.mysql
       tags: mysql

**De MySQL à MariaDB**

Par défaut, la tâche d'installation du rôle va choisir MySQL (5.7) plutôt que MariaDB (10.1). Pour changer ce comportement, la documentation indique qu'il faut surcharger la variable :code:`mysql_packages` (ligne 7)

Lorsqu'un playbook devient conséquent, il va être normalement composé de beaucoup de rôles. Rappelez vous qu'Ansible exécute séquentiellement les tâches. Il va donc falloir attendre que toutes les tâches qui précèdent le rôle :code:`geerlingguy.mysql` soient jouées, ce qui peut-être très long...

Pour améliorer la situation, les rôles seront taggués (lignes 11 et 13). Ces tags seront utilisés au moment de l'exécution de la commande :code:`ansible-playbook` avec l'option :code:`-t / --tags`. Combinés avec l'option :code:`-l / --limit` pour cibler un host particulier, il est possible d'appliquer des rôles / tâches précis à un ou plusieurs noeud :

.. code-block:: shell

   (venv)$ ansible-playbook -b lamp.yml -l vps02 -t mysql

**De MariaDB à MariaDB**

La version installée de MariaDB (10.1) est un peu ancienne et dépend du système. Il serait préférable d'installer la dernière version stable (10.4) à partir des dépôts officiels de MariaDB. Pour cela, modifiez le playbook :code:`lamp.yml` :

.. code-block:: yaml+jinja
   :linenos:

   ---
   # file: lamp.yml
   
   - hosts: web
     vars:
       mysql_python_package_debian: 'python3-mysqldb'
       mysql_packages: ['mariadb-client-10.4', 'mariadb-server-10.4']
       mysql_root_password_update: false
   
     pre_tasks:
     - name: Add MariaDB apt key
       apt_key:
         keyserver: keyserver.ubuntu.com
         id: "0xF1656F24C74CD1D8"
       when: ansible_os_family == "Debian"
       tags: mysql
   
     - name: Add MariaDB repository
       apt_repository:
         repo: deb http://mariadb.mirrors.ovh.net/MariaDB/repo/10.4/{{ ansible_distribution|lower }} {{ ansible_distribution_release }} main
         update_cache: yes
       when: ansible_os_family == "Debian"
       tags: mysql
   
     roles:
     - role: nginx
       tags: nginx
     - role: geerlingguy.mysql
       tags: mysql

Avant d'exécuter les tâches contenues dans les rôles, Ansible laisse la possibilité d'écrire des :code:`pre_tasks`. Cela permet dans le cas présent de surcharger le comportement du rôle :code:`geerlingguy.mysql` en ajoutant le dépôt officiel de MariaDB aux sources APT.

.. warning::

   Utiliser des playbooks d'autres utilisateurs est une bonne pratique. Néanmoins, attention, chaque développeur a sa propre vision des choses et il est possible que le travail nécessaire pour adapter un rôle à votre besoin soit finalement plus long que d'écrire son propre rôle. Un bon compromis est de vous inspirer librement des rôles disponibles, d'en copier certaines parties et de les spécialier pour votre usage.
