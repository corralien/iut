Les "Facts"
-----------

Les facts sont des informations collectées par Ansible et qui peuvent être utilisés en tant que variable.

Avant de détailler les facts, listez les tâches exécutées par le playbook :

.. code-block::
   
   (venv)$ ansible-playbook -b nginx.yml --list-tasks

   playbook: nginx.yml

     play #1 (vps01): vps01	TAGS: []
       tasks:
         install nginx	TAGS: []

Remplacez l'option :code:`--list-tasks` par :code:`--check` :

.. code-block::

   (venv)$ ansible-playbook -b nginx.yml --check

   PLAY [vps01] ********************************************************************************

   TASK [Gathering Facts] **********************************************************************
   ok: [vps01]

   TASK [install nginx] ************************************************************************
   ok: [vps01]

   PLAY RECAP **********************************************************************************
   vps01 : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


Remarquez que le nombre de tâches n'est pas le même. Dans la première commande, il y a bien notre unique tâche d'installation de nginx alors que dans la deuxième, une nouvelle tâche nommée "Gathering Facts" est apparue.

Cette tâche est chargée de faire l'inventaire des machines distantes avant l'exécution des playbooks. Ansible va créer des variables utilisables dans vos playbooks comme le nom de la machine, la distribution utilisée, la configuration réseau, etc. Cette tâche fait appel au module :code:`setup` (ou son wrapper `gather_facts`)

Visualisez l'ensemble des "facts" :

.. code-block:: shell

   (venv)$ ansible vps01 -b -m setup

.. admonition:: Question

   Relevez les variables qui permettent d'obtenir la configuration réseau IPv4 de la carte eth1 et les informations sur le système utilisé (distribution, release, version).
