## Sommaire 

1. [ Introduction](#1-introduction)
2. [ Description du projet](#2-description-du-projet)
3. [ Membres du groupe par sprint](#3-membres-du-groupe-par-sprint)
4. [Technologies Utilisées](#4-technologies-utilisées)
5. [ Logiciel](#5-logiciel)
6. [ Difficultées rencontrées](#6-Difficultées-rencontrées)
7. [ Solutions apportées](#7-solutions-apportées)
8. [ Améliorations possibles](#8-améliorations-possibles)

# 1. Introduction

L’objectif consiste à concevoir et développer une solution d’administration centralisée permettant la gestion et la supervision de systèmes opérant sur des plateformes hétérogènes.

# 2. Description du projet

L'objectif principal est de fournir une interface facilitant l'exécution de tâches via des scripts telles que la configuration, le déploiement de correctifs, la gestion des utilisateurs et la surveillance des performances, réduisant ainsi la complexité opérationnelle et améliorant l'efficacité et la sécurité à travers l'ensemble du parc informatique, depuis des servers Debian et Windows vers des clients Linux et Windows.


![Schéma_synoptique.drawio.png](RESOURCE/Schéma_synoptique.drawio.png)


# 3. Membres du groupe par sprint

**Sprint 1**

| Membre  | Rôle       | Missions                                                                               |
| ------- | ---------- | -------------------------------------------------------------------------------------- |
| Révine  | PO         | BackLog, configuration machine Win11/Debian ,changer nom des machines/utilisateur, ssh |
| Cédric  | SM         | README.md , pseudo-code, configuration machine Win11/WinServer  ,ssh                   |
| Saiah   | Technicien | GUID_USER.md , configuration machine Ubuntu/WinServer , ssh                            |
| Grégory | Technicien | INSTALL.md , configuration machine Ubuntu/Debian , ssh                                 |

**Sprint 2**

| Membre  | Rôle       | Missions                                                                               |
| ------- | ---------- | -------------------------------------------------------------------------------------- |
| Révine  | SM         | Backlog, script Bash, Test du script                                                   |
| Cédric  | PO         | Script Powershell, Test script, Configuration WinRM                                    |
| Saiah   | Technicien | Script Bash, MAJ Github                                                                |


**Sprint 3**

| Membre  | Rôle         | Missions                                                                                     |
| ------- | ------------ | -------------------------------------------------------------------------------------------- |
| Révine  | Technicien   | Finalisation du script Bash,                                                                 |
| Cédric  | SM           | Finalisation du script Powershell,                                                           |
| Saiah   | PO           | Backlog, Livrable, Prez de la Présentation , Finalisation Script Bash                        |


**Sprint 4**

| Membre  | Rôle | Missions                                                                                     |
| ------- | ---- | -------------------------------------------------------------------------------------------- |
| Cédric  |  PO  | Verification fonctionnalitées script Powershell, Livrable, finalisation projet               |
| Saiah   |  SM  | Verification fonctionnalitées du script Bash, Livrable, finalisation projet                  |


# 4. Technologies Utilisées

Avant de déployer l'outil d'administration centralisée, les éléments suivants doivent être en place :

## Infrastructure réseau
- Réseau : 172.16.10.0/24
- Passerelle : 172.16.10.254
- Masque : 255.255.255.0
- DNS : 8.8.8.8

## Machines virtuelles
4 VMs hébergées sur Proxmox :

| Machine  | IP            | OS                           | Rôle                    |
|----------|---------------|------------------------------|-------------------------|
| SRVLX01  | 172.16.10.10  | Debian 12/13 CLI             | Serveur principal       |
| SRVWIN01 | 172.16.10.5   | Windows Server 2022/2025 GUI | Serveur secondaire      |
| CLILIN01 | 172.16.10.30  | Ubuntu 24 LTS                | Client Linux            |
| CLIWIN01 | 172.16.10.20  | Windows 10/11                | Client Windows          |

## Logiciels requis

### Sur SRVLX01 (Debian) :
- OpenSSH Server
- keychain (gestion des clés SSH)
- Bash 4.0+

### Sur SRVWIN01 (Windows Server) :
- OpenSSH Server (Windows Feature)
- PowerShell Core 7.4+ minimum
- ssh-agent (service Windows)
- WinRM
  
### Sur CLILIN01 (Ubuntu) :
- OpenSSH Server

### Sur CLIWIN01 (Windows) :
- OpenSSH Server (Windows Feature)
- WinRM

## Compte utilisateur
- Un compte utilisateur **`wilder`** doit exister sur les 4 machines
- Avec les mêmes permissions (sudo/admin selon l'OS)
- Utilisé pour toutes les connexions SSH

---

**Note :** Pour les instructions d'installation détaillées, consulter [INSTALL.md](INSTALL.md)

# 5. Logiciel
    

   - OpenSSH Server (sur toutes les machines)
   - Keychain (sur SRVLX01 - Debian)
   - ssh-agent (sur SRVWIN01 - Windows Server)
   - PowerShell Core 7.4+ (sur SRVWIN01)
   - WinRm (sur SRVWIN01 / CLIWIN01)

### Détails des choix SSH et PowerShell :

**Authentification SSH par clés :**
- Type de clé : **ed25519** (plus sécurisée et performante que RSA)
- Gestion des clés sur Debian : **keychain** (persiste les clés entre les sessions)
- Gestion des clés sur Windows : **ssh-agent** (service Windows natif)

**PowerShell Core :**
- Version minimale : **7.4+** (requis pour SRVWIN01)
- Avantages : compatibilité multiplateforme, performances améliorées, syntaxe moderne
- Installation : via `winget install Microsoft.PowerShell`

**Compte utilisateur uniforme :**
- Un utilisateur identique **`wilder`** est créé sur les 4 machines
- Facilite la gestion SSH et les permissions
- Simplifie les scripts (pas de gestion multi-utilisateurs)


# 6. Difficultées rencontrés
   
1. Déconnexion de WinRM après redémarrage :
Le service WinRM n’était pas automatiquement actif après le redémarrage de la machine, entraînant des pertes de connexion.

2. Manque de structuration des tâches dans le script Bash (Sprint 3) :
Absence d’une liste claire des tâches à implémenter, rendant difficile la vision globale des fonctionnalités à développer.

3.Perte de membres dans l’équipe :
Réduction des ressources humaines impactant l’avancement et la répartition des tâches du projet.

4. Gestion du fichier de logs via PowerShell :
Difficultés liées au bon fonctionnement du script de journalisation : bien que le fichier de logs soit correctement créé et stocké sur le serveur, certaines commandes ne s’exécutent pas comme prévu, empêchant l’enregistrement complet de toutes les actions réalisées.

# 7. Solutions apportées

1. Activation automatique du service WinRM :
Configuration du service pour un démarrage automatique, garantissant sa disponibilité après chaque redémarrage.

2. Mise en place d’une liste de tâches structurée :
Création et intégration d’une liste claire des tâches dans le dépôt GitHub afin d’améliorer la visibilité et la coordination au sein de l’équipe.

3. Réorganisation interne de l’équipe :
Adaptation de la répartition des tâches sans recrutement supplémentaire, afin de maintenir la continuité du projet.

4. Correction en cours du système de logs :
Analyse et débogage des commandes PowerShell afin d’assurer un enregistrement complet et fiable de toutes les actions dans le fichier de logs centralisé.
Ce point est actuellement en cours de traitement et fait partie de la phase de maintenance.

# 8. Améliorations possibles

1. Améliorer la gestion du temps de projet :
Optimiser l’organisation et la planification afin d’assurer la finalisation complète du projet dans les délais impartis.

2. Mettre en place un alias pour l’exécution du script :
Créer un alias permettant de simplifier le lancement du script, afin d’éviter la saisie répétitive des commandes.

3. Renforcer la sécurité du service SSH :
Modifier le port par défaut du service SSH (port 22) vers un port personnalisé (ex : 222) afin de réduire les risques d’attaques automatisées.

