# User_Guid

---

## Sommaire

- [Présentation](#présentation)
- [Objectif du script](#objectif-du-script)
- [Accès au script](#accès-au-script)
- [Utilisation recommandée](#utilisation-recommandée)
- [Remarques importantes](#remarques-importantes)
- [Fonctionnement général](#fonctionnement-général)
- [Lancement](#lancement)
- [Menu principal](#menu-principal)
  - [Gestion des utilisateurs et groupes](#1-gestion-des-utilisateurs-et-groupes)
  - [Inventaire matériel et système](#2-inventaire-matériel-et-système)
  - [Configuration et diagnostic réseau](#3-configuration-et-diagnostic-réseau)
  - [Maintenance, sécurité et alimentation](#4-maintenance-sécurité-et-alimentation)
  - [Consultation des logs et rapports](#5-consultation-des-logs-et-rapports)
- [Fichiers générés](#fichiers-générés)
- [Conclusion](#conclusion)

---

## Présentation

Ce dépôt contient le guide d’utilisation du script PowerShell de gestion distante Windows utilisé dans le projet 2.

Ce script ne se lance pas directement seul.  
Il est appelé depuis un script parent nommé `menu`, qui permet de choisir la machine cible sur laquelle on souhaite se connecter.

Dans le cadre de ce guide, l’utilisation présentée concerne la partie Windows.

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

## Fonctionnement général

Le script parent `menu` permet de :

- choisir la machine cible
- lancer le module correspondant
- accéder au panneau d’administration distant

Pour utiliser ce script PowerShell, il faut donc :

1. lancer le script parent `menu`
2. choisir la cible Windows
3. laisser le script ouvrir le panneau d’administration distant
4. utiliser les différentes catégories proposées

---

## Lancement

### Étape 1 : lancer le script parent

Le point d’entrée du projet est le script `menu`.

### Étape 2 : choisir la cible Windows

Dans le menu principal, sélectionner la machine Windows.

### Étape 3 : utiliser le panneau d’administration

Une fois la connexion établie, le menu principal du script s’affiche.

---

## Menu principal

Le panneau d’administration propose plusieurs catégories.

---

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

Permet d’obtenir des informations sur la machine :

- nom du poste
- fabricant
- système d’exploitation
- mémoire vive totale

Les informations peuvent être exportées.

---

### 3. Configuration et diagnostic réseau

Permet de consulter les informations réseau :

- nom de l’interface
- adresse IP
- passerelle
- serveurs DNS

Les résultats sont exportés dans un rapport.

---

### 4. Maintenance, sécurité et alimentation

Permet d’effectuer des actions sur la machine :

- créer un répertoire
- supprimer un répertoire
- activer les profils de pare-feu
- désactiver les profils de pare-feu
- vérifier l’état des pare-feu
- redémarrer la machine distante

---

### 5. Consultation des logs et rapports

Permet de consulter :

- le fichier de journalisation des actions
- les rapports exportés dans le dossier dédié

---

## Fichiers générés

Le script génère deux types de fichiers.

### Fichier de log

```plaintext
log_evt.log
