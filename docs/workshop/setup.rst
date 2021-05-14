Préparation
-----------

Créez un répertoire de travail :code:`TP_Ansible` et copiez y le fichier :code:`Vagrantfile` de la section :ref:`workspace`.

Appliquez les changements suivants :

.. code-block:: diff

   @@ -20,15 +20,16 @@
      config.vm.define "admin", primary: true do |admin|
        admin.vm.hostname = "admin"
        admin.vm.network "private_network", ip: "10.1.102.7"
   -    admin.vm.network "forwarded_port", guest: 22, host: 2200, id: "ssh"
   +    admin.vm.network "forwarded_port", guest: 22, host: 2300, id: "ssh"
      end

      # Virtual Private Server
      (1..$NUM_VPS).each do |i|
        config.vm.define vm_name = "vps%02d" % i, autostart: false do |vps|
          vps.vm.hostname = vm_name
   +      vps.vm.box = "bento/debian-10"
          vps.vm.network "private_network", ip: "10.1.102.#{i+10}"
   -      vps.vm.network "forwarded_port", guest: 22, host: 2200+i, id: "ssh"
   +      vps.vm.network "forwarded_port", guest: 22, host: 2300+i, id: "ssh"
        end
      end

Vous adapterez la variable :code:`NUM_VPS` (ligne 5) et la mémoire allouée :code:`vb.memory` à chaque VM (ligne 15) selon vos besoins et la capacité de votre ordinateur (minimum possible 384Mo).

Une fois connecté à la machine d'administration, suivez les 3 premières étapes du tutoriel.

- :ref:`tutorial/step-01:Installation d'Ansible`
- :ref:`tutorial/step-02:Ajout des clés SSH`
- :ref:`tutorial/step-03:Configuration d'Ansible`

Pour l'inventaire :

- la machine :code:`vps01` aura comme alias :code:`lb1` et fera partie du groupe :code:`lbservers`,
- la machine :code:`vps02` aura comme alias :code:`lb2` et fera partie du groupe :code:`lbservers`,
- la machine :code:`vps03` aura comme alias :code:`web1` et fera partie du groupe :code:`webservers`,
- la machine :code:`vps04` aura comme alias :code:`web2` et fera partie du groupe :code:`webservers`,
- la machine :code:`vps05` aura comme alias :code:`db1` et fera partie du groupe :code:`dbservers`.

Créez les répertoires et les fichiers vides manquants :

.. code-block:: shell

  /home/vagrant
  ├── ansible.cfg
  ├── group_vars                # variables à appliquer aux groupes
  │   ├── dbservers.yml
  │   ├── lbservers.yml
  │   └── webservers.yml
  ├── hosts
  ├── host_vars                 # variables à appliquer aux hôtes
  │   ├── db1.yml
  │   ├── lb1.yml
  │   ├── lb2.yml
  │   ├── web1.yml
  │   └── web2.yml
  ├── id_rsa
  ├── id_rsa.pub
  └── roles                     # rôles de l'infrastructure

.. warning::

   Adaptez les instructions au contexte. Réfléchissez à votre infrastructure !
