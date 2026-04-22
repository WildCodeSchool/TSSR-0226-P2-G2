# User_Guid

## Présentation

Ce dépôt contient le guide d’utilisation du script PowerShell de gestion distante Windows utilisé dans le projet 2.

Ce script ne se lance pas directement seul.  
Il est appelé depuis un **script parent nommé `menu`**, qui permet de choisir la machine cible sur laquelle on souhaite se connecter.

Dans le cadre de ce guide, l’utilisation présentée concerne **la partie Windows**.

---

## Fonctionnement général

Le script parent `menu` permet de :

- choisir la machine cible
- lancer le module correspondant
- accéder au panneau d’administration distant

Pour utiliser ce script PowerShell, il faut donc :

1. lancer le script parent `menu`
2. choisir la cible **Windows**
3. laisser le script ouvrir le panneau d’administration distant
4. utiliser les différentes catégories proposées

---

## Objectif du script

Ce script permet d’administrer à distance une machine Windows depuis une interface en console.

Il permet notamment de :

- gérer les utilisateurs locaux
- consulter des informations système
- afficher la configuration réseau
- effectuer certaines actions de maintenance
- consulter les journaux et rapports exportés

---

## Accès au script

Le script fonctionne dans un environnement où :

- la machine Windows cible est accessible sur le réseau
- les droits administrateur sont disponibles
- la connexion distante PowerShell est opérationnelle
- le lancement se fait depuis le script parent `menu`

---

## Lancement

### Étape 1 : lancer le script parent

Le point d’entrée du projet est le script **`menu`**.

C’est lui qui permet de sélectionner la machine cible.

### Étape 2 : choisir la cible Windows

Dans le menu principal, il faut sélectionner la machine **Windows** pour accéder au script d’administration Windows.

### Étape 3 : utiliser le panneau d’administration

Une fois la connexion établie, le script affiche un menu principal avec plusieurs catégories.

---

## Menu principal

Le panneau d’administration propose les catégories suivantes :

### 1. Gestion des utilisateurs et groupes

Cette partie permet de gérer les comptes locaux de la machine distante.

Fonctions disponibles :

- créer un utilisateur
- supprimer un utilisateur
- modifier un mot de passe
- ajouter un utilisateur à un groupe
- désactiver un utilisateur
- réactiver un utilisateur
- afficher la liste des utilisateurs
- exporter les informations d’un utilisateur
- afficher les groupes locaux

---

### 2. Inventaire matériel et système

Cette partie permet d’obtenir un résumé de la machine distante, par exemple :

- nom du poste
- fabricant
- système d’exploitation
- mémoire vive totale

Les informations récupérées peuvent être affichées et exportées.

---

### 3. Configuration et diagnostic réseau

Cette partie permet de consulter les informations réseau principales de la machine distante, comme :

- nom de l’interface
- adresse IP
- passerelle
- serveurs DNS

Les résultats sont également exportés dans un rapport.

---

### 4. Maintenance, sécurité et alimentation

Cette partie permet d’effectuer plusieurs actions d’administration sur la machine distante :

- créer un répertoire
- supprimer un répertoire
- activer les profils de pare-feu
- désactiver les profils de pare-feu
- vérifier l’état des pare-feu
- redémarrer la machine distante

---

### 5. Consultation des logs et rapports

Cette partie permet de consulter :

- le fichier de journalisation des actions
- les rapports exportés dans le dossier dédié

Elle sert à garder une trace des opérations réalisées et à relire les informations récupérées précédemment.

---

## Fichiers générés

Le script peut générer deux types de fichiers :

### 1. Fichier de log

Un fichier nommé `log_evt.log` est utilisé pour enregistrer les actions exécutées dans le script.

Il permet de suivre les opérations réalisées sur la machine cible.

### 2. Dossier `info`

Un dossier `info` est créé automatiquement si nécessaire.

Il contient les rapports exportés par le script, par exemple :

- informations utilisateur
- rapport système
- rapport réseau

---

## Utilisation recommandée

Pour utiliser le script correctement :

- lancer d’abord le script parent `menu`
- choisir la cible Windows
- vérifier que la machine distante est joignable
- exécuter les actions souhaitées depuis le menu
- consulter les logs et rapports si besoin

---

## Remarques importantes

- Le script doit être exécuté avec des droits administrateur.
- Il est destiné à l’administration d’une machine Windows à distance.
- Certaines actions modifient directement la machine cible.
- Il est conseillé de vérifier les informations saisies avant validation.
- Le script parent `menu` reste le point d’entrée principal du projet.

---

## Conclusion

Ce script PowerShell permet de centraliser plusieurs actions d’administration Windows dans une interface simple en console.

Grâce au script parent `menu`, l’utilisateur peut choisir la machine cible puis accéder au module Windows pour :

- administrer les utilisateurs
- consulter les informations système
- vérifier le réseau
- effectuer des actions de maintenance
- exploiter les logs et les rapports générés

Ce guide a pour objectif de présenter son utilisation générale de manière simple et claire.
