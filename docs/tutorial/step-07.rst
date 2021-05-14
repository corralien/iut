Idempotence
-----------

En mathématiques et en informatique, `l'idempotence <https://fr.wikipedia.org/wiki/Idempotence>`_  signifie qu'une opération a le même effet qu'on l'applique une ou plusieurs fois (source Wikipédia).

Pour Ansible, cela signifie qu'après la première exécution réussi d'un playbook, le système est amené dans l'état désiré alors les exécutions suivantes doivent indiquer 0 changement puisque vous êtes *déjà* dans l'état désiré.

Or, si vous rejouez plusieurs fois le playbook :code:`nginx.yml`, vous vous apercevrez que le rapport indique systématiquement que des modifications ont été apportées sur le serveur distant. Le playbook n'est donc pas idempotent car il ne devrait pas indiquer en boucle qu'une tâche a modifié le système.

**Ce concept est la pierre angulaire d'Ansible** pour pouvoir écrire des playbooks sûrs. Vous devriez toujours rechercher l'idempotence lorsque vous construisez des playbooks.

Modifiez votre playbook :code:`nginx.yml` ainsi :

.. code-block:: diff

   @@ -3,11 +3,10 @@

    - hosts: vps01
      tasks:
   -  - name: update repositories
   -    apt: update_cache=yes
   -
      - name: install nginx
   -    apt: name=nginx-core state=present
   +    apt: name=nginx-core state=present update_cache=yes
   +    notify: restart nginx

   +  handlers:
      - name: restart nginx
        systemd: name=nginx state=restarted

Désinstallez le package :code:`nginx-core` du serveur avec la commande :code:`ansible` :

.. code-block:: shell

   (venv)$ ansible vps01 -b -m apt -a "name=nginx-core state=absent"

Rejouez le playbook une première fois, puis plusieurs fois.

.. admonition:: Question

   Montrez que le playbook est idempotent.
