Retour sur SSH
--------------

Avant de passer à la création de playbooks (suite d'instructions Ansible), il faudrait sécuriser un minimum la connexion aux serveurs.
Jusqu'à présent, vous n'avez pas eu besoin de saisir de mot de passe pour vous connecter au serveur :code:`vps01` car votre passphrase est vide.
Dans le cadre de ce tutorial, cela ne pose aucun problème, néanmoins pour un déploiement en production, ce n'est pas acceptable.

Il serait pertinant de crypter la clé privée avec une passphrase :

.. code-block:: shell

   (venv)$ ssh-keygen -p -f id_rsa

Vérifiez que tout fonctionne bien :

.. code-block:: shell

   (venv)$ ansible vps01 -m ping

Normalement, Ansible vous a demandé de saisir votre passphrase. Désormais à chaque commande lancée, Ansible va systématiquement vous demander votre phrase de décryptage de la clé privée, ce qui à l'usage n'est pas très pratique.

Le choix suivant s'offre à vous :

- Vous n'utilisez pas de mot de passe et n'avez aucune garantie sur une éventuelle compromission de votre clé.
- Vous avez défini une phrase de cryptage et avez un certain niveau de sécurité.

Il existe une troisième option permettant d'associer la facilité d'usage et la sécurité. Il est possible d'utiliser l'agent SSH : ce dernier va garder en mémoire les clés privées décryptées par votre mot de passe comme si les clés n'avaient plus de protection.

Démarrez l'agent ainsi :

.. code-block:: shell

   (venv)$ eval $(ssh-agent)

Ajoutez la clé privée à l'agent et décrypter la :

.. code-block:: shell

   (venv)$ ssh-add id_rsa

Vérifiez les clés mémorisées par l'agent :

.. code-block:: shell

   (venv)$ ssh-add -L

.. admonition:: Question

   Expliquez le résultat obtenu.
