Installation d'Ansible
----------------------

Avant d'installer Ansible, il est préférable de créer un environnement virtuel Python. Il s'agit d'une bonne pratique pour ne pas *"polluer"* l'interpréteur système Python et créer des conflits ou des incompatibilités.

.. code-block:: shell

   $ sudo apt update
   $ sudo apt install python3-venv
   $ python3 -m venv venv

Activez l'environnement virtuel et installez Ansible.

.. code-block:: shell

   $ source venv/bin/activate
   (venv)$ pip install -U pip setuptools
   (venv)$ pip install ansible

Vérifiez la bonne installation d'Ansible :

.. code-block:: shell

   (venv)$ ansible --version
   ansible 2.9.9
     config file = None
     configured module search path = ['/home/vagrant/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
     ansible python module location = /home/vagrant/venv/lib/python3.6/site-packages/ansible
     executable location = /home/vagrant/ansible/venv/bin/ansible
     python version = 3.6.9 (default, Apr 18 2020, 01:56:04) [GCC 8.4.0]

.. note::

   Ansible n'a pas besoin d'être installé sur les serveurs distants. Ces derniers n'ont besoin que d'un serveur SSH et de Python.

Testez le bon fonctionnement d'Ansible en lançant une première commande :

.. code-block:: shell

   (venv)$ ansible localhost -m ping

.. admonition:: Question

   Que fait cette commande ? La commande a-t-elle bien fonctionné ? Expliquez.
