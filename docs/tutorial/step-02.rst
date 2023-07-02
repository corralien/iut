Ajout des clés SSH
------------------

Comme il a déjà été mentionné, Ansible ne requiert pas l'installation d'un agent sur les serveurs distants mais simplement une connexion SSH.

Dans le but d'établir la communication depuis la machine d'administration (admin) vers les serveurs (vpsXX), créez une paire de clé (privée / publique) sur l'admin.

.. code-block:: shell

   (venv)$ ssh-keygen -t rsa -N "" -C "ansible@admin" -f id_rsa

.. admonition:: Question

   Expliquez la ligne de commande ci-dessus.

Avant de copier la clé SSH, ouvrez un autre terminal et démarrez un nouveau serveur.

.. code-block:: shell

   $ vagrant up vps01

Depuis l'admin, copiez la clé publique dans le compte utilisateur :code:`vagrant` du serveur :

.. code-block:: shell

   (venv)$ ssh-copy-id -i id_rsa.pub vagrant@192.168.56.11

.. admonition:: Question

   Sur le serveur, observez le répertoire :code:`.ssh`. Déduisez ce que fait la commande :code:`ssh-copy-id`. Aidez vous également du manuel (:code:`man ssh-copy-id`).

