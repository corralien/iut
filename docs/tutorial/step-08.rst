Options utiles
--------------

:code:`--check`
***************

Cet argument des commandes :code:`ansible` et :code:`ansible-playbook` est probablement le plus important. Plutôt que d'exécuter réellement une commande ou un playbook, cette option va vous permettre de simuler vos modifications.

Attention, toutefois, ce n'est pas parce que la simulation se passe bien que la réalisation se passera bien également. Par exemple, les tâches appelant le module :code:`shell` ne seront jamais simulées mais juste passées (*skipped*)

:code:`--diff`
**************

Lorsqu'un playbook est configuré, il arrive très souvent d'avoir besoin de modifier des fichiers. Cette option va vous permettre d'afficher les modifications appliquées au niveau des fichiers. Il est recommandé d'utiliser cette option conjointement avec la précédente.

Il y a bien d'autres options intéressantes à connaître mais ces dernières sont **indispensables** à la réalisation de playbook. Un autre scénario d'usage très apprécié consiste à vérifier l'intégrité d'un système à intervalle régulier.

Consultez la `documentation en ligne <https://docs.ansible.com/ansible/latest/user_guide/command_line_tools.html>`_ pour avoir la liste des options disponibles.
