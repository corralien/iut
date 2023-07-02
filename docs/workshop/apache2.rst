Apache 2
--------

`Apache HTTPD <https://httpd.apache.org/>`_ est le serveur le plus répandu sur internet. Il s'agit d'une application fonctionnant à la base sur les systèmes d'exploitation de type Unix, mais il a désormais été porté sur de nombreux systèmes, dont Windows.

Objectifs
*********

Créez un rôle *apache2* qui :

- installe le paquet et met à jour les dépôts,
- active les modules *rewrite*, *expires*, *headers*, *proxy_fcgi*, *ssl* puis **redémarre** le service,
- configure les modules *expires* et *headers* puis **recharge** le service,
- active la configuration des modules *expires* et *headers* puis **recharge** le service,
- dépose une page de test pour vérifier la répartition de charge.

**Modules mis en oeuvre** : :code:`apt`, :code:`stat`, :code:`apache2_module`, :code:`copy`, :code:`command`, :code:`template`, :code:`systemd`.

Réalisation
***********

.. code-block:: shell

   (venv)$ mkdir -p roles/apache2/{files,handlers,tasks,templates}
   (venv)$ touch roles/apache2/{handlers,tasks}/main.yml
   (venv)$ touch roles/apache2/files/{expires,headers}.conf
   (venv)$ touch roles/apache2/templates/testlb.html

Installation du paquet
++++++++++++++++++++++

Même procédure que pour les composants précédents. Le paquet s'appelle :code:`apache2`

Activation des modules
++++++++++++++++++++++

Utilisez le module :code:`apache2_module` dans une boucle pour activer les modules d'Apache.

.. warning::

	 Le binaire :code:`/usr/sbin/apache2ctl` n'existe pas avant l'installation du service. Utilisez le module :code:`stat` comme décrit dans :ref:`l'exemple du tutoriel <stat_pattern>`.

Paramètrage des modules
+++++++++++++++++++++++

La procédure de configuration du module *expires* et son activation est la suivante :

#. Copiez le fichier de configuration :code:`expires.conf` dans :code:`/etc/apache2/conf-available`.

#. Activez la configuration avec la commande :code:`a2enconf expires`.

Utilisez le paramètre :code:`creates` du module :code:`command` pour atteindre l'idempotence à la place du module :code:`stat` déjà utilisé dans le tutoriel.

Fichier de configuration :code:`expires.conf` :

.. code-block:: apache

   # Mise en cache des fichiers dans le navigateur
   <IfModule mod_expires.c>
       ExpiresActive On
       ExpiresDefault "access plus 1 month"

       ExpiresByType text/html "access plus 0 seconds"
       ExpiresByType text/xml "access plus 0 seconds"
       ExpiresByType application/xml "access plus 0 seconds"
       ExpiresByType application/json "access plus 0 seconds"
       ExpiresByType application/pdf "access plus 0 seconds"

       ExpiresByType application/rss+xml "access plus 1 hour"
       ExpiresByType application/atom+xml "access plus 1 hour"

       ExpiresByType application/x-font-ttf "access plus 1 month"
       ExpiresByType font/opentype "access plus 1 month"
       ExpiresByType application/x-font-woff "access plus 1 month"
       ExpiresByType application/x-font-woff2 "access plus 1 month"
       ExpiresByType image/svg+xml "access plus 1 month"
       ExpiresByType application/vnd.ms-fontobject "access plus 1 month"

       ExpiresByType image/jpg "access plus 1 month"
       ExpiresByType image/jpeg "access plus 1 month"
       ExpiresByType image/gif "access plus 1 month"
       ExpiresByType image/png "access plus 1 month"

       ExpiresByType video/ogg "access plus 1 month"
       ExpiresByType audio/ogg "access plus 1 month"
       ExpiresByType video/mp4 "access plus 1 month"
       ExpiresByType video/webm "access plus 1 month"

       ExpiresByType text/css "access plus 6 month"
       ExpiresByType application/javascript "access plus 6 month"

       ExpiresByType application/x-shockwave-flash "access plus 1 week"
       ExpiresByType image/x-icon "access plus 1 week"
   </IfModule>


Pour le module *headers*, la procédure est la même. Il est intéressant de faire une boucle pour chacune des actions. N'oubliez pas de recharger le service si l'état d'au moins une des deux tâches avait changé.

Ficher de configuration :code:`headers.conf` :

.. code-block:: apache

   Header unset ETag
   FileETag None

   <IfModule mod_headers.c>
     <FilesMatch "\.(ico|jpe?g|png|gif|swf)$">
       Header set Cache-Control "public"
     </FilesMatch>
     <FilesMatch "\.(css)$">
       Header set Cache-Control "public"
     </FilesMatch>
     <FilesMatch "\.(js)$">
       Header set Cache-Control "private"
     </FilesMatch>
     <FilesMatch "\.(x?html?|php)$">
       Header set Cache-Control "private, must-revalidate"
     </FilesMatch>
   </IfModule>

Page de test
++++++++++++

Déposez cette page de test dans :code:`/var/www/html/testlb.html`. Modifiez la pour afficher le nom de machine et l'adresse IP de l'interface *eth1* du serveur correspondant.

.. code-block:: html+jinja

   <!doctype html>
   <html lang="fr">
     <head>
       <title>Page de test</title>
     </head>
     {{ nom_de_machine }} - {{ adresse_ip_eth1 }}
   </html>

Pour appliquer le rôle aux webservers, créez le playbook :code:`webservers.yml`.

Tests
*****

Maintenant que la haute disponibilité de l'infrastructure est atteinte, il faut tester la répartition de charge. HAProxy intègre un panneau de supervision sur chaque loadbalancer :

- `<http://admin:admin@192.168.56.11:8080/haproxy>`_ pour lb1
- `<http://admin:admin@192.168.56.12:8080/haproxy>`_ pour lb2

Lancez la commande :code:`curl -i http://www.demain.xyz/testlb.html` à partir du manager puis rafraichissez le panneau de supervision du loadbalancer maître. Répétez plusieurs fois l'opération.

.. admonition:: Question

   Commentez les résultats obtenus. La répartition de charge est-elle fonctionnelle ?

Coupez maintenant le service *apache2* d'un des deux serveurs web puis rafraichissez le panneau de supervision du loadbalancer maître. Relancez plusieurs fois la commande :code:`curl` avant de relancer le service *apache2* précédemment arrêté.

.. admonition:: Question

   HAProxy est-il également tolérant aux pannes ? Expliquez.
