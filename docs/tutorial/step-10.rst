Premier playbook 2
------------------

Notre premier playbook ne fait pas grand chose mis à part installer le serveur web Nginx.
Voici un scénario un peu plus réaliste :

- Installer le serveur web Nginx. (module :code:`apt`)
- Modifier la configuration de l'hôte virtuel. (module :code:`copy`)
- Activer la configuration en créant un lien symbolique (module :code:`file`)
- Redémarrer le serveur si la configuration a été modifiée. (module :code:`systemd`)
- Déposer une page d'accueil html avec des informations sur le serveur. (module :code:`template`)

Créez l'arborescence de répertoires suivante :

.. code-block:: shell

   data
   ├── files
   └── templates

Copiez le contenu ci-dessous dans le fichier :code:`data/files/default` :

.. code-block:: nginx

   server {
     listen 80 default_server;
     listen [::]:80 default_server;

     root /var/www/html;
     index index.html;
     server_name _;

     location / {
       try_files $uri $uri/ =404;
     }
   }

Et le contenu suivant dans le fichier :code:`data/templates/index.html.j2`

.. code-block:: html+jinja

   <!doctype html>
   <html lang="fr">
     <head>
       <meta charset="utf-8">
       <title>Mon premier playbook</title>
     </head>
     <body>
       Nom de machine : {{ ansible_hostname }}<br>
       Système : {{ ansible_lsb.are_you_really_sure }}<br>
     </body>
   </html>

Créez le playbook :code:`web.yml` :

.. code-block:: yaml+jinja
   :linenos:
   :emphasize-lines: 7,10-12

   ---
   # file: web.yml

   - hosts: vps01
     tasks:
     - name: install nginx
       apt: name=nginx-core state=present

     - name: configure default vhost
       copy:
         src: data/files/default
         dest: /etc/nginx/sites-available/default

     - name: enable default vhost
       file:
         src: /etc/nginx/sites-available/default
         dest: /etc/nginx/sites-enabled/default
         state: link

     - name: restart nginx
       systemd: name=nginx state=restarted

     - name: copy index.html
       template:
         src: data/templates/index.html.j2
         dest: /var/www/html/index.html

.. note::

   Observez la différence d'écriture entre les lignes 7 et 10-12. Ansible recommande la seconde forme surtout quand les modules doivent spécifier plusieurs arguments.


Tout est prêt pour lancer le playbook.

.. admonition:: Question

   Indiquez la ligne de commande pour lancer le playbook. Assurez vous d'avoir vérifier le playbook avec l'option :code:`--check`.

   Ce playbook n'est pas idempotent, pourquoi ? Corrigez le.
