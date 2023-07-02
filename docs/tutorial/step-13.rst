Retour vers les playbooks
-------------------------

Dans la section précédente, vous avez utilisé le rôle :code:`geerlingguy.mysql`. Si vous prenez le temps de regarder ce dernier, vous verrez qu'il est complexe car il a de nombreuses fonctionnalités et options de configuration. De plus, il essaie d'être compatible avec toutes les distributions majeures de Linux.

Pour arriver à un tel niveau, le développeur du rôle a :

- défini et utilisé des variables,
- conditionné l'exécution de tâches à ces variables,
- itéré sur des variables pour répéter certaines tâches.
  
En effet, le langage YAML ne dispose pas de telles fonctionnalités de base. Les développeurs d'Ansible ont enrichi le langage YAML pour en faire un "langage de programmation".

Les variables
*************

`Les variables <https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html>`_ comme les tâches se déclarent dans une section de votre playbook en l'occurence :code:`vars`. Vous verrez qu'il existe bien d'autres endroits où les déclarer : inventaire, fichiers de variables des playbooks, fichiers de variables des rôles. Tout dépend de la portée qu'il faut donner aux variables.

.. code-block:: yaml+jinja
   :linenos:

   ---
   # file: test_vars.yml

   - hosts: vps01
     vars:
       welcome_message: "Bienvenue sur votre {{ ansible_hostname }}" 

     tasks:
     - name: display welcome message
       debug:
         msg: "{{ welcome_message }} {{ ansible_lsb.id }}"

.. admonition:: Question

   Quelle est la différence entre la variable :code:`welcome_message` et les variables :code:`ansible_hostname` et :code:`ansible_lsb` ?

Les conditions
**************

`Les conditions <https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html>`_ permettent de passer certaines tâches si ces dernières ne sont pas satisfaites. Par exemple, ne pas installer un paquet avec le module :code:`apt` si le système distant utilise une *RedHat*. Ansible permet d'évaluer des expressions avec la directive :code:`when`.

.. code-block:: yaml+jinja
   :linenos:

   ---
   # file: test_when.yml
   
   - hosts: vps01
   
     tasks:
     - name: install nginx (Debian family only)
       apt:
         name: nginx
         state: present
       when: ansible_os_family == "Debian"
   
     - name: install nginx (RedHat family only)
       yum:
         name: nginx
         state: present
       when: ansible_os_family == "Redhat"

.. admonition:: Question

   Que fait ce playbook ? Expliquez son déroulement.

Les boucles
***********

`Les boucles <https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html>`_ autorise la répétition de certaines tâches avec une liste d'arguments. C'est la directive :code:`loop`

.. code-block:: yaml+jinja

   ---
   # file: test_loop.yml
   
   - hosts: vps01
   
     tasks:
     - name: install nginx
       apt:
         name: "{{ item }}"
         state: present
       loop:
       - nginx-full
       - nginx-doc
       - php-fpm

.. admonition:: Question

   Créez une tâche qui ajoute 3 utilisateurs `webuser1`, `webuser2` et `webuser3` avec le module :code:`user`.

En savoir plus
**************

Cette section avancée sur l'utilisation des variables, des conditions et des boucles dans les playbooks pourraient donner lieu à un cours dédié. Il est préférable de se reporter à la documentation au besoin quand cela s'avère nécessaire.
