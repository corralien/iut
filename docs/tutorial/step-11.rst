Passage à l'échelle
-------------------

Notre serveur web est désormais fonctionnel mais peut-être me direz vous "tout ça pour ça..." ?
Effectivement si le déploiement s'arrêtait à paramétrer un serveur, la configuration pourrait tout aussi bien se faire manuellement.

La force d'Ansible est de pouvoir passer à l'échelle. Si votre playbook a fonctionné pour 1 serveur, il fonctionnera également pour N serveurs.

Modifiez votre inventaire :code:`hosts` afin de créer un groupe de serveurs :code:`web` :

.. code-block:: cfg
   :linenos:

   vps01 ansible_host=192.168.56.11
   vps02 ansible_host=192.168.56.12
   vps03 ansible_host=192.168.56.13

   [web]
   vps01
   vps02
   vps03

Puis démarrez les serveurs encore éteints avec Vagrant.

.. admonition:: Question

   Vérifiez la connectivité avec tous les serveurs du groupe :code:`web`.

Dans le playbook :code:`web.yml`, corriger la ligne :code:`hosts` en remplaçant la valeur actuelle par le nom du groupe des serveurs web.

Lancer impérativement le playbook avec l'option :code:`--check`

.. code:: shell

   (venv)$ ansible-playbook -b web.yml --check

.. admonition:: Question

   Qu'observez vous ? Expliquez le résultat obtenu.

.. _stat_pattern:

Appliquez les corrections suivantes au playbook :

.. code:: diff

   @@ -12,11 +12,17 @@
          dest: /etc/nginx/sites-available/default
        notify: restart nginx

   +  - name: check default vhost file
   +    stat:
   +      path: /etc/nginx/sites-available/default
   +    register: vhost_conf
   +
      - name: enable default vhost
        file:
          src: /etc/nginx/sites-available/default
          dest: /etc/nginx/sites-enabled/default
          state: link
   +    when: vhost_conf.stat.exists == True
        notify: restart nginx

      - name: copy index.html

Le `module stat <https://docs.ansible.com/ansible/latest/modules/stat_module.html>`_ récupère l'état d'un fichier ou du système de fichiers. Cet état est ensuite enregistré dans une variable Ansible :code:`vhost_conf` pour pouvoir être utilisé ultérieurement. Dans le cas présent, l'activation de la configuration du vhost (lien symbolique) ne sera permise que si le fichier existe bien sur le disque.

Exécutez le playbook sur tous les serveurs.
