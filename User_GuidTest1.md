# User Guide – Script PowerShell Administration Windows

---

## Sommaire

- [Présentation](#présentation)
- [Objectif](#objectif)
- [Pré-requis](#pré-requis)
- [Architecture du projet](#architecture-du-projet)
- [Lancement du script](#lancement-du-script)
- [Fonctionnalités principales](#fonctionnalités-principales)
  - [Gestion des utilisateurs](#gestion-des-utilisateurs)
  - [Inventaire système](#inventaire-système)
  - [Configuration réseau](#configuration-réseau)
  - [Maintenance et sécurité](#maintenance-et-sécurité)
  - [Logs et rapports](#logs-et-rapports)
- [Fichiers générés](#fichiers-générés)
- [Bonnes pratiques](#bonnes-pratiques)
- [Conclusion](#conclusion)

---

## Présentation

Ce projet propose un script PowerShell permettant d’administrer une machine Windows à distance via une interface en ligne de commande.

Le script ne fonctionne pas de manière autonome.  
Il est intégré dans une architecture globale et est appelé depuis un script parent nommé `menu`, qui permet de sélectionner la machine cible.

---

## Objectif

L’objectif du script est de centraliser plusieurs tâches d’administration Windows :

- gestion des utilisateurs
- consultation des informations système
- diagnostic réseau
- actions de maintenance
- suivi via logs et rapports

Le tout depuis une interface simple en console.

---

## Pré-requis

Avant utilisation, vérifier les éléments suivants :

- Machine Windows accessible sur le réseau
- Accès administrateur sur la machine cible
- PowerShell fonctionnel
- Connexion distante activée (WinRM / PowerShell Remoting)
- Script parent `menu` opérationnel

---

## Architecture du projet

Le projet repose sur une organisation simple :

```
Projet/
│
├── menu.ps1 # Script principal (point d’entrée)
├── windows_script.ps1 # Script PowerShell Windows
│
├── info/ # Dossier des rapports générés
│ ├── user.txt
│ ├── system.txt
│ └── network.txt
│
└── log_evt.log # Fichier de journalisation
```


---

## Lancement du script

### 1. Lancer le script principal

```powershell
.\menu.ps1
```
### 2. Sélectionner la cible

Dans le menu affiché :

choisir la machine Windows
### 3. Accéder au module

Le script charge ensuite le module d’administration Windows et affiche le menu principal.

## Fonctionnalités principales
### Gestion des utilisateurs

Permet de gérer les comptes locaux :

création d’un utilisateur
suppression d’un utilisateur
modification du mot de passe
activation ou désactivation d’un compte
ajout à un groupe
affichage de la liste des utilisateurs
export des informations utilisateur
Inventaire système

Permet de consulter les informations de la machine :

nom du poste
système d’exploitation
constructeur
mémoire vive

Les données peuvent être affichées et exportées.

## Configuration réseau

Permet de récupérer les informations réseau :

adresse IP
passerelle
serveurs DNS
interface réseau

Les informations sont enregistrées dans un rapport.

## Maintenance et sécurité

Permet d’effectuer des actions d’administration :

création et suppression de répertoires
activation ou désactivation du pare-feu
vérification de l’état du pare-feu
redémarrage de la machine
Logs et rapports

Permet de consulter :

les actions exécutées dans le script
les fichiers générés
Fichiers générés
Logs
log_evt.log

Contient l’historique des actions réalisées.

Dossier des rapports
```
info/
```

Contient les fichiers générés par le script :

informations utilisateur
inventaire système
configuration réseau
Bonnes pratiques
Toujours lancer le script via menu.ps1
Vérifier la connectivité réseau avant utilisation
Utiliser un compte administrateur
Vérifier les informations avant validation
Consulter les logs après utilisation
Tester dans un environnement contrôlé

## Conclusion

Ce script PowerShell permet de centraliser plusieurs tâches d’administration Windows dans une interface unique.

Grâce à son intégration avec le script menu, il s’inscrit dans une logique d’administration centralisée.

Il permet de :

simplifier les opérations courantes
structurer les actions d’administration
générer des rapports exploitables

Ce projet constitue une base solide pour une administration automatisée et standardisée des systèmes Windows.
