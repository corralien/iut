HAProxy
-------

`HAProxy <https://www.haproxy.org/>`_ est une solution gratuite, très rapide et fiable offrant une haute disponibilité, un équilibrage de charge et un proxy pour les applications TCP et HTTP. Il est particulièrement adapté aux sites web à très fort trafic et utilisé par bon nombre de sites les plus visités au monde.

Objectifs
*********

Créez un rôle *haproxy* qui :

- installe le paquet et met à jour les dépôts,
- copie la configuration puis **recharge** le service,
- modifie les options de démarrage puis **redémarre** le service.

**Modules mis en oeuvre** : :code:`apt`, :code:`template`, :code:`stat`, :code:`lineinfile`, :code:`systemd`.

Réalisation
***********

.. code-block:: shell

   (venv)$ mkdir -p roles/haproxy/{handlers,tasks,templates}
   (venv)$ touch roles/haproxy/{handlers,tasks}/main.yml
   (venv)$ touch roles/haproxy/templates/web.cfg

Installation du paquet
++++++++++++++++++++++

Comme précédemment, l'installation du paquet est trivial.

Configuration du service
++++++++++++++++++++++++

La configuration de base est fonctionnelle, il faut cependant définir un *frontend* web à l'écoute des clients et son *backend* pour rediriger les requêtes HTTP sur les serveurs webs.

Voici un exemple de configuration à adapter :

.. code-block::
  :linenos:
  :emphasize-lines: 9-10

  frontend ft_web
    bind *:80
    mode http
    default_backend bk_web

  backend bk_web
    balance roundrobin
    option forwardfor
    server srv1 192.168.30.80:80 check
    server srv2 192.168.30.81:80 check

  listen stats
    bind *:8080
    stats enable
    stats uri /haproxy
    stats show-legends
    stats show-node
    stats realm Auth\ required
    stats auth admin:admin
    stats admin if TRUE

Pour configurer la liste des serveurs webs (lignes 9-10) qui composent le *backend*, vous allez construire dynamiquement en utilisant les variables de l'inventaire définies au lancement par les facts.

.. code-block:: jinja

   {% for host in groups['webservers'] -%}
   server {{ hostvars[host].inventory_hostname }} {{ hostvars[host].ansible_host }}:80 check
   {% endfor %}

Utilisez le module :code:`template` pour réaliser cette tâche.

Pour ne pas toucher la configuration originale :code:`/etc/haproxy/haproxy.cfg`, copiez la configuration du proxy web dans :code:`/etc/haproxy/web.cfg`.

Options de démarrage
+++++++++++++++++++++

Pour prendre en compte le fichier de configuration :code:`/etc/haproxy/web.cfg`, il est nécessaire de modifier l'option de démarrage :code:`EXTRAOPTS` du service qui se trouve dans :code:`/etc/default/haproxy`.

Adaptez cet exemple de la documentation du module :code:`lineinfile` pour modifier la configuration :

.. code-block:: yaml

   - name: Ensure the default Apache port is 8080
     lineinfile:
       path: /etc/httpd/conf/httpd.conf
       regexp: '^Listen '
       insertafter: '^#Listen '
       line: Listen 8080

.. warning::

	 Le fichier :code:`/etc/default/haproxy` n'existe pas avant l'installation du service. Utilisez le module :code:`stat` comme décrit dans :ref:`l'exemple du tutoriel <stat_pattern>`.

Pour appliquer le rôle aux loadbalancers, ajoutez au playbook :code:`lbservers.yml` votre nouveau rôle.

Tests
*****

Même si le réseau est fonctionnel, il est possible que le répartiteur de charge tombe. Il faut donc s'assurer que l'adresse IP virtuelle change bien de loadbalancer.

#. Commencez par lancer un :code:`ping` infini (-t sous Windows) à partir de votre hôte physique vers l'adresse IP 10.1.102.250.

#. Affichez le journal de logs en continu du service *keepalived* avec la commande :code:`journalctl -n0 -u keepalived -f`.

#. Stoppez le service *haproxy* avec Ansible sur le loadbalancer qui détient l'adresse IP virtuelle.

#. Attendez quelques secondes et redémarrez le service *haproxy* précédemment arrêté avec Ansible.

.. admonition:: Question

   Observez les sorties de logs et expliquez les résultats obtenus. |br|
   Illustrez vos observations de capture d'écran.
