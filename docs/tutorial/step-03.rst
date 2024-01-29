Configuration d'Ansible
-----------------------

Pour fonctionner Ansible a besoin de deux fichiers :

- un fichier de configuration :code:`ansible.cfg`
- un fichier d'inventaire :code:`hosts`

Ces deux fichiers seront à créer dans le répertoire de l'utilisateur :code:`vagrant`.

Configuration
*************

Le fichier de configuration est cherché à plusieurs emplacements dans l'ordre suivant :

1. :code:`ANSIBLE_CONFIG`, l'emplacement défini par la variable d'environnement
2. :code:`ansible.cfg` dans le répertoire courant au moment de l'exécution
3. :code:`~/.ansible.cfg` dans le répertoire personnel de l'utilisateur
4. :code:`/etc/ansible/ansible.cfg` dans le répertoire de configuration système

Dans le cadre du tutoriel, c'est l'option 2 qui est retenue pour centraliser l'ensemble de notre travail dans le répertoire courant.

.. code-block:: cfg
   :linenos:

   [defaults]
   inventory = ./hosts
   remote_user = vagrant
   private_key_file = ./id_rsa
   host_key_checking = False
   log_path = ./ansible.log
   interpreter_python = python3

La ligne 2 indique l'endroit où se trouve l'inventaire des serveurs (paramètres de connexion, groupes de machines, etc). Les lignes 3 et 4 déterminent respectivement avec quels utilisateur et clé privé Ansible va se connecter à la machine distante.

Pour connaître toutes les options possibles, consultez la `documentation en ligne <https://docs.ansible.com/ansible/latest/reference_appendices/config.html>`_

Inventaire
**********

Copiez le contenu ci-dessous et enregistrez le dans le fichier d'inventaire :code:`hosts`

.. code-block:: cfg
   :linenos:

   vps01 ansible_host=192.168.56.11
   vps02 ansible_host=192.168.56.12
   vps03 ansible_host=192.168.56.13

Test de connexion
*****************

Félicitations ! Tout est prêt désormais pour lancer nos premières commandes avec la commande :code:`ansible`.
Testez la connectivité avec le serveur :code:`vps01`

.. admonition:: Question

   Quelle commande ansible allez vous lancer pour vérifier la connexion avec le serveur ?
