Keepalived
----------

`Keepalived <https://www.keepalived.org/>`_ est un logiciel de routage. Le principal objectif de ce logiciel est de mettre en place du loadbalancing et/ou de la haute disponibilité pour les systèmes Linux et des infrastructures basées sur Linux. Le Loadbalancing repose sur la couche de transport `IPVS <http://www.linuxvirtualserver.org/software/ipvs.html>`_ du projet `Linux Virtual Server <http://www.linuxvirtualserver.org/index.html>`_ et la haute disponibilité fonctionne via le `protocole VRRP <https://en.wikipedia.org/wiki/Virtual_Router_Redundancy_Protocol>`_.

Objectifs
*********

Créez un rôle *keepalived* qui :

- installe le paquet et met à jour les dépôts,
- copie la configuration puis **recharge** le service.

**Modules mis en oeuvre** : :code:`apt`, :code:`template`, :code:`systemd`.

Réalisation
***********

.. code-block:: shell

   (venv)$ mkdir -p roles/keepalived/{handlers,tasks,templates}
   (venv)$ touch roles/keepalived/{handlers,tasks}/main.yml
   (venv)$ touch roles/keepalived/templates/keepalived.conf

Installation du paquet
++++++++++++++++++++++

L'installation du paquet ne pose pas de problème particulier. Il suffit de se reporter aux différents exemples du tutoriel.

Configuration du service
++++++++++++++++++++++++

Vous aurez besoin de créer le fichier de configuration :code:`/etc/keepalived/keepalived.conf` sur les deux serveurs. Voici un exemple de configuration fonctionnelle à adapter :

.. code-block::
   :linenos:
   :emphasize-lines: 8,9,11,13

   vrrp_script chk_haproxy {
     script "/usr/bin/pgrep haproxy"
     interval 2
     weight 2
   }

   vrrp_instance VI_1 {
     state MASTER           # SLAVE for the peer
     interface ens3
     virtual_router_id 51
     priority 101           # 100 for the peer
     virtual_ipaddress {
       192.168.30.200/24
     }
     track_script {
       chk_haproxy
     }
   }

Dans l'infrastructure, l'adresse IP virtuelle est fixée à 10.1.102.250/24 et utilise l'interface *eth1*.

Dans le fichier de variables de groupe :code:`group_vars/lbservers.yml`, créez une variable
:code:`keepalived_virtual_ipaddress` avec l'adresse IP virtuelle.

Dans les fichiers de variables d'hôte :code:`host_vars/lb1.yml` et :code:`host_vars/lb2.yml`, créez les variables :code:`keepalived_state` et :code:`keepalived_priority` avec leurs valeurs respectives :

- pour :code:`lb1` MASTER et 101,
- pour :code:`lb2` SLAVE et 100.

Copiez le contenu du fichier ci-dessus dans le fichier :code:`roles/keepalived/templates/keepalived.conf`. Il y a 2 adaptations à faire :

- Modifier l'adresse IP virtuelle et l'interface par les bonnes valeurs.
- Substituer les valeurs d'état et de priorité par les variables nouvellement créées.

Pour appliquer le rôle aux loadbalancers, créez le playbook :code:`lbservers.yml`.

Tests
*****

Il faut désormais vérifier que l'adresse IP virtuelle (flottante) passe bien d'un loadbalancer à l'autre lorsqu'un incident réseau survient.

#. Commencez par lancer un :code:`ping` infini (-t sous Windows) à partir de votre hôte physique vers l'adresse IP 10.1.102.250.

#. Notez la configuration IP de l'interface *eth1* sur chaque loadbalancer avec la commande :code:`ip addr show eth1`.

#. Stoppez le service *keepalived* avec Ansible sur le loadbalancer qui détient l'adresse IP virtuelle.

#. Notez à nouveau la configuration IP de chaque loadbalancer.

#. Démarrez le service *keepalived* précédemment arrêté avec Ansible.

#. Vérifiez que la situation est revenue à la situation initiale.

.. admonition:: Question

   Notez les commandes utilisées et expliquez les résultats obtenus. |br|
   Illustrez vos notes de capture d'écran.
