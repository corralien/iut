.. _workspace:

Environnement de travail
========================

Afin d'avoir une configuration homogène pour tout le monde, vous allez déployer des machines virtuelles avec `Vagrant <https://www.vagrantup.com/>`_ sous `VirtualBox <https://www.virtualbox.org/>`_.

Téléchargez et installez :download:`VirtualBox <https://www.virtualbox.org/wiki/Downloads/>` et :download:`Vagrant <https://www.vagrantup.com/downloads.html>`

Infrastructure
--------------

Pour réaliser ce tutoriel, vous allez avoir besoin de plusieurs VMs :

- un hôte pour centraliser et déployer les configurations,
- de serveurs pour tester nos déploiements.

La configuration suivante de Vagrant permet de créer une infrastructure multi-host :

.. literalinclude:: ../Vagrantfile
   :language: ruby
   :linenos:

Créez un répertoire de travail :code:`TD_Ansible` et copiez y le contenu ci-dessus dans un fichier nommé :code:`Vagrantfile`.

Ce fichier est à adapter selon les ressources disponibles sur votre machine (CPU, RAM) et les instructions qui vous seront données au fur et à mesure de l'avancement du tutoriel

Vous devriez avoir l'arborescence suivante :

.. code-block::

   TD_Ansible
   └── Vagrantfile

Plan d'adressage IP
-------------------

Les VMs auront toujours les adresses IP suivantes :

- **admin** : 192.168.56.7
- **vps01** : 192.168.56.11
- **vps02** : 192.168.56.12
- **vps03** : 192.168.56.13
- ...
- **vps09** : 192.168.56.19

Machines virtuelles
-------------------

Premier démarrage
*****************

Il est temps d'initialiser une première machine virtuelle. Lors de sa création, son image (Debian 10) va être téléchargée depuis internet si elle n'est pas trouvée sur votre disque. Bien que l'image soit optimisée et compressée, le téléchargement peut être long selon la vitesse de votre connexion à internet.

Démarrez la machine d'administration :

.. code-block:: shell

   $ vagrant up admin

Vérifiez que la machine virtuelle est bien fonctionnelle :

.. code-block:: shell

   $ vagrant status
   Current machine states:

   admin                     running (virtualbox)
   vps01                     not created (virtualbox)
   vps02                     not created (virtualbox)
   vps03                     not created (virtualbox)

   This environment represents multiple VMs. The VMs are all listed
   above with their current state. For more information about a specific
   VM, run `vagrant status NAME`.

Connexion à la VM
*****************

Sous Linux, les connexions distantes sont en général réalisées avec SSH. Ici, c'est la même chose mais Vagrant fournit un raccourci bien utile :

.. code-block:: shell

   $ vagrant ssh admin

La connexion se fait par un échange de clés sans mot de passe avec le compte utilisateur :code:`vagrant`. 

Vous êtes désormais connecté à la machine virtuelle d'administration.

Cycle de vie
************

Vagrant est une application permettant de rendre le développement plus facile. Associé avec Ansible, les administrateurs systèmes disposent d'un outil puissant pour mettre au point le déploiement de leur infrastructure :

- Vagrant crée des VMs avec un système de base
- Ansible déploie les services et applications

Dans votre phase de mise au point, il ne faut pas hésiter à créer et supprimer les VMs autant de fois que nécessaire. Pour ce faire :

.. code-block:: shell

   $ vagrant destroy vmname

Vous pouvez commencez le tutoriel.
