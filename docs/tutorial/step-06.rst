Premier playbook 1
------------------

Un playbook est un script Ansible qui permet d'enchaîner l'exécution des modules comme vous l'auriez fait avec la commande :code:`ansible`. Ainsi, il est possible de configurer totalement une machine avec la seule commande :code:`ansible-playbook`.

Copiez le contenu ci-dessous dans un fichier :code:`nginx.yml` :

.. code-block:: yaml+jinja
   :linenos:

   ---
   # file: nginx.yml

   - hosts: vps01
     tasks:
     - name: update repositories
       apt: update_cache=yes

     - name: install nginx
       apt: name=nginx-full state=present

     - name: restart nginx
       systemd: name=nginx state=restarted

.. note::

   Les playbooks sont écrits en `YAML <https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html>`_. A l'instar du langage Python, l'indentation est *extrèmement importante*. Il faut être attentif à l'alignement de chaque ligne par rapport à la précédente sous peine d'avoir de nombreuses erreurs de syntaxe.

Exécutez maintenant le playbook :

.. code-block:: shell

   (venv)$ ansible-playbook -b nginx.yml

.. admonition:: Question

   Observez le résultat, commentez. Ne négligez pas les couleurs.

Rappelez vous les commandes exécutées précédemment avec la commande :code:`ansible` :

.. code-block:: shell

   (venv)$ ansible vps01 -b -m apt -a "update_cache=yes"
   (venv)$ ansible vps01 -b -m apt -a "name=nginx-full state=present"
   (venv)$ ansible vps01 -b -m systemd -a "name=nginx state=restarted"

.. admonition:: Question

   Comparez les commandes au playbooks. Que pouvez vous en conclure ?
