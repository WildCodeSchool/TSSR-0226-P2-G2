# User Guide — Script Bash d’administration Ubuntu

---

## Sommaire

- [Présentation](#présentation)
- [Objectif du script](#objectif-du-script)
- [Architecture du projet](#architecture-du-projet)
- [Accès au script](#accès-au-script)
- [Utilisation recommandée](#utilisation-recommandée)
- [Remarques importantes](#remarques-importantes)
- [Fonctionnement général](#fonctionnement-général)
- [Lancement](#lancement)
- [Menu principal](#menu-principal)
  - [1. Actions ordinateur](#1-actions-ordinateur)
  - [2. Informations ordinateur](#2-informations-ordinateur)
  - [3. Actions utilisateur](#3-actions-utilisateur)
  - [4. Informations utilisateur](#4-informations-utilisateur)
  - [5. Consultation des logs](#5-consultation-des-logs)
- [Fichiers générés](#fichiers-générés)
- [Conclusion](#conclusion)

---

## Présentation

Ce dépôt contient le guide d’utilisation d’un **script Bash de gestion distante Ubuntu** utilisé dans le projet 2.

Ce script est exécuté depuis un **serveur Debian** et permet d’administrer une **machine cliente Ubuntu** à travers une interface en console.

L’objectif est de centraliser plusieurs tâches d’administration dans un seul menu, afin de simplifier l’utilisation du script et de rendre les actions plus lisibles.

---

## Objectif du script

Ce script permet d’administrer à distance une machine Ubuntu via **SSH**.

Il permet notamment de :

- gérer des utilisateurs
- consulter des informations système
- afficher des informations réseau
- effectuer certaines actions de maintenance
- consulter les logs d’activité
- enregistrer certaines informations dans des fichiers texte

Le script est conçu pour proposer une utilisation simple, à travers des menus successifs, sans devoir relancer manuellement chaque commande.

---

## Architecture du projet

Le projet repose sur une organisation simple :

```text
Projet/
│
├── script.sh             # Script principal Bash
├── log_evt.log           # Fichier de journalisation
├── info/                 # Dossier des rapports générés
│   └── info_*.txt
└── USER_GUIDE.md         # Guide utilisateur
```

Cette structure permet de séparer clairement :

- le script principal,
- les journaux d’exécution,
- les fichiers d’informations exportés,
- la documentation utilisateur.

---

## Accès au script

Le script fonctionne dans un environnement où :

- le serveur de lancement est sous Debian,
- la machine cible est sous Ubuntu,
- la connexion SSH vers la machine distante est opérationnelle,
- l’utilisateur qui exécute le script possède les droits nécessaires,
- certaines commandes distantes peuvent être exécutées avec `sudo`.

---

## Utilisation recommandée

Pour utiliser le script correctement, il est conseillé de :

- vérifier que la machine Ubuntu est joignable,
- vérifier que l’hôte distant correspond bien à la variable `REMOTE_HOST`,
- lancer le script depuis le serveur Debian,
- utiliser les menus pour naviguer dans les fonctionnalités,
- consulter les fichiers générés si une trace est nécessaire.

---

## Remarques importantes

- Le script agit sur une machine distante Ubuntu.
- Certaines actions modifient directement la machine cible.
- Plusieurs fonctions nécessitent des droits administrateur.
- Les informations récupérées peuvent être enregistrées dans le dossier `info/`.
- Les actions principales sont journalisées dans le fichier `log_evt.log`.
- Certaines opérations sensibles, comme la suppression ou le redémarrage, doivent être utilisées avec prudence.

---

## Fonctionnement général

Le script démarre sur un **menu principal**.

L’utilisateur peut ensuite :

1. choisir la machine Ubuntu,
2. accéder aux fonctions d’administration,
3. consulter les logs,
4. quitter proprement le script.

Une fois la machine sélectionnée, le script affiche plusieurs sous-menus permettant de séparer les actions par catégorie.

---

## Lancement

### Étape 1 : rendre le script exécutable

```bash
chmod +x script.sh
```

### Étape 2 : lancer le script

```bash
./script.sh
```

### Étape 3 : utiliser le menu principal

Une fois le script lancé, l’utilisateur peut naviguer dans les différentes sections proposées.

---

## Menu principal

Le panneau principal propose plusieurs catégories permettant de gérer et superviser une machine Ubuntu distante.

| Choix | Description |
|--------|-------------|
| 1) Choisir la machine Ubuntu | Ouvre le menu principal de gestion de la machine distante |
| 2) Consulter les logs | Permet de rechercher des actions dans le fichier de log |
| 3) Quitter | Ferme le script |

---

### 1. Actions ordinateur

#### Actions possibles

Le script permet d’effectuer les actions suivantes sur la machine cliente :

| Action | Description |
|--------|-------------|
| 1) Redémarrage | Redémarre la machine distante |
| 2) Création de répertoire | Crée un nouveau dossier sur la machine distante |
| 3) Suppression de répertoire | Supprime un dossier existant sur la machine distante |
| 4) Activation du pare-feu | Active le pare-feu système sur Ubuntu |

**Notes importantes :**

- Les actions 1, 2, 3 et 4 peuvent nécessiter des droits administrateur.
- L’action 1 (Redémarrage) provoque une déconnexion immédiate de la machine distante.
- La suppression d’un répertoire doit être utilisée avec prudence.
- Toutes les actions importantes sont journalisées dans le fichier `log_evt.log`.

---

### 2. Informations ordinateur

#### Informations disponibles

Le script permet de consulter les informations suivantes sur la machine distante :

| Information | Description |
|--------|-------------|
| 1) Informations système | Affiche le nom de la machine, la date et le temps de fonctionnement |
| 2) Ports ouverts | Affiche les ports réseau actuellement ouverts |
| 3) Configuration réseau | Affiche l’adresse IP et la passerelle |
| 4) Liste des interfaces | Affiche les interfaces réseau disponibles |
| 5) Version de l’OS | Affiche la version du système Ubuntu |
| 6) Paquets installés | Affiche la liste des paquets présents sur la machine |
| 7) Services en cours | Affiche les services actifs |
| 8) RAM totale | Affiche la quantité totale de mémoire vive |
| 9) Utilisation de la RAM | Affiche l’état de la mémoire utilisée |
| 10) Mises à jour manquantes | Affiche les mises à jour disponibles |

**Notes importantes :**

- Cette section permet d’obtenir rapidement une vue d’ensemble de la machine distante.
- Les informations récupérées peuvent être exportées automatiquement dans le dossier `info/`.
- Ces données sont utiles pour le diagnostic, la supervision ou la documentation.

---

### 3. Actions utilisateur

#### Actions possibles

Le script permet d’effectuer les actions suivantes sur les comptes utilisateurs de la machine distante :

| Action | Description |
|--------|-------------|
| 1) Lister les utilisateurs | Affiche les comptes présents sur la machine |
| 2) Créer un utilisateur | Crée un nouveau compte utilisateur |
| 3) Supprimer un utilisateur | Supprime un compte utilisateur existant |
| 4) Désactiver un utilisateur | Verrouille un compte sans le supprimer |
| 5) Ajouter à un groupe | Ajoute un utilisateur à un groupe existant |
| 6) Ajouter au groupe administration | Ajoute un utilisateur au groupe `sudo` |
| 7) Modifier le mot de passe | Change le mot de passe d’un utilisateur |

**Notes importantes :**

- Ces actions modifient directement les comptes de la machine Ubuntu.
- Les opérations de création, suppression et modification nécessitent généralement des droits administrateur.
- La suppression d’un utilisateur est une action sensible et doit être vérifiée avant validation.
- Le changement de mot de passe suit les règles définies dans le script.

---

### 4. Informations utilisateur

#### Informations disponibles

Le script permet de consulter certaines informations ciblées sur un utilisateur :

| Information | Description |
|--------|-------------|
| 1) Groupes d’appartenance | Affiche les groupes auxquels appartient un utilisateur |
| 2) Permissions sur un fichier | Affiche les droits d’accès d’un fichier ou dossier |

**Notes importantes :**

- Cette section permet de vérifier rapidement les droits associés à un utilisateur.
- Les résultats obtenus peuvent être enregistrés dans le dossier `info/`.
- Ces informations sont utiles pour contrôler les accès et comprendre les permissions appliquées.

---

### 5. Consultation des logs

#### Actions possibles

Le script permet de rechercher les opérations enregistrées pendant son utilisation :

| Action | Description |
|--------|-------------|
| 1) Recherche par utilisateur | Recherche les actions liées à un utilisateur dans le fichier de log |
| 2) Recherche par machine | Recherche les actions liées à une machine dans le fichier de log |
| 3) Retour | Revient au menu précédent |

**Notes importantes :**

- Le fichier `log_evt.log` permet de suivre l’historique des actions effectuées.
- Cette section est utile pour vérifier une opération, relire un historique ou confirmer une action passée.
- Les recherches se font directement dans le fichier de log créé par le script.

---

## Fichiers générés

Le script génère plusieurs fichiers utiles pendant son exécution.

### Fichier de log

```text
log_evt.log
```

Ce fichier contient l’historique des actions réalisées dans le script.

### Dossier des rapports

```text
info/
```

Ce dossier contient les fichiers texte créés lors de certaines consultations d’informations.

### Exemple de rapport généré

```text
info/info_ubuntu_20260422.txt
```

Ces fichiers permettent de conserver une trace des informations collectées sur la machine distante.

---

## Conclusion

Ce script Bash permet de centraliser plusieurs actions d’administration Ubuntu dans une interface simple en console.

Grâce à sa structure en menus, l’utilisateur peut accéder facilement aux fonctionnalités suivantes :

- administration de la machine distante,
- gestion des utilisateurs,
- consultation des informations système,
- diagnostic réseau,
- consultation des logs,
- export d’informations dans des fichiers texte.

Ce guide reprend une structure claire avec sommaire, sections et tableaux, afin de faciliter son utilisation dans un dépôt GitHub ou dans un rendu de projet.
