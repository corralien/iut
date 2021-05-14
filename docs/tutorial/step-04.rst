Premières commandes
-------------------

Dans la précédente étape, vous avez testé le module ping (:code:`-m ping`) pour vérifier la bonne connexion au serveur.

Module :code:`command`
**********************

Le `module command <https://docs.ansible.com/ansible/latest/modules/command_module.html>`_ permet d'exécuter une commande arbitraire sur le serveur.

.. code-block:: shell

   (venv)$ ansible vps01 -m command -a "uptime"
   vps01 | CHANGED | rc=0 >>
   05:29:09 up 1 day, 12:08,  2 users,  load average: 0.00, 0.00, 0.00

Testez la commande suivante :

.. code-block:: shell

   (venv)$ ansible vps01 -a "uptime"

.. admonition:: Question

   Qu'en déduisez-vous ?

Exécutez les commandes suivantes :

.. code-block:: shell

   (venv)$ ansible vps01 -m command -a "cat /etc/sudoers"
   (venv)$ ansible vps01 -b -m command -a "cat /etc/sudoers"

.. admonition:: Question

   Expliquez les résultats obtenus.

Module :code:`apt`
******************

Le `module apt <https://docs.ansible.com/ansible/latest/modules/apt_module.html>`_ permet d'installer des packages pour les systèmes Debian et ses dérivés (Ubuntu).

Commencez par mettre à jour les dépôts comme le fait :code:`apt update`

.. code-block:: shell

   (venv)$ ansible vps01 -b -m apt -a "update_cache=yes"

Procédez à l'installation du serveur web :code:`nginx` :

.. code-block:: shell

   (venv)$ ansible vps01 -b -m apt -a "name=nginx-core state=present"

Vérifiez la bonne installation du service sur le serveur (:code:`dpkg -l`, :code:`systemctl status`) et que la page web par défaut est bien accessible http://10.1.102.11

.. admonition:: Question

   Relancez la dernière commande. Qu'observez vous ?

   En vous aidant de la documentation du module, désinstallez le service nginx. |br|
   Indiquez la ligne de commande utilisée

Module :code:`systemd`
**********************

Le `module systemd <https://docs.ansible.com/ansible/latest/modules/systemd_module.html>`_ permet de controler les services systèmes et réseaux distants.

Redémarrez le serveur web nginx sur le serveur distant :

.. code-block:: shell

   (venv)$ ansible vps01 -b -m systemd -a "name=nginx state=restarted"

.. admonition:: Question

   En vous aidant de la documentation du module, stoppez et désactivez le service :code:`ufw`. |br|
   Indiquez la ligne de commande utilisée. Quel est le rôle de ce service ?
