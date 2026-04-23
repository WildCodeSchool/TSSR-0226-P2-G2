1. Introduction

Ce document décrit les étapes d’installation et de configuration nécessaires à la mise en place de l’environnement technique du projet.

L’objectif est de permettre le déploiement et le bon fonctionnement des différentes machines (serveurs et clients), ainsi que la communication entre elles via SSH et WinRM, et l’exécution de scripts automatisés.

2. Sommaire
# 3. [Prérequis](Prérequis)
# 4. [Installation et configuration du serveur Debian (SRVLX01)](Installation-et-configuration-du-serveur-Debian-(SRVLX01))
# 5. [Configuration du client Ubuntu (CLILIN01)](Configuration-du-client-Ubuntu-(CLILIN01))
# 6. [Configuration des machines Windows (SRVWIN01 et CLIWIN01)](Configuration-des-machines-Windows-(SRVWIN01-et-CLIWIN01))
# 7. [Installation de PowerShell 7](Installation-de-PowerShell-7)

# 3. Prérequis

Avant de commencer, assurez-vous de disposer des éléments suivants :

Environnement technique

- 4 machines virtuelles :
- 1 serveur Debian (SRVLX01)
- 1 client Ubuntu (CLILIN01)
- 1 serveur Windows (SRVWIN01)
- 1 client Windows (CLIWIN01)
- Accès administrateur sur toutes les machines
- Connexion réseau fonctionnelle entre les machines (ping opérationnel)

Outils nécessaires
- Accès à un terminal (Linux / PowerShell)
- Connexion Internet pour l’installation des paquets
- Navigateur web (pour téléchargement si nécessaire)

Vérifications préalables

Avant de commencer les configurations, vérifier :

- La connectivité réseau entre les machines :
```
ping <adresse_ip>
```
- La bonne résolution des noms (si DNS configuré)
- L’accès root (Linux) ou administrateur (Windows)

# 4. Installation et configuration du serveur Debian (SRVLX01)
   Objectif :

Configurer un serveur Debian afin de :

- permettre les connexions SSH
- sécuriser les accès réseau
- préparer l’environnement pour l’exécution des scripts

  ## 4.1 Configuration réseau

Configurer une adresse IP statique sur le serveur Debian.

Exemple de configuration :

Fichier à modifier :
```
/etc/network/interfaces
```
Configuration type :
```
auto ens18
iface ens18 inet static
    address 172.16.10.10
    netmask 255.255.255.0
    gateway 172.16.10.1
 Redémarrage du service réseau
systemctl restart networking
```
 Vérification 
 ```
ip a
```
Vérifier que l’adresse IP est bien appliquée.
```
ping 172.16.10.X
```
Vérifier la communication avec les autres machines.



  ## 4.2 Installation et configuration de SSH :

  Installation du service SSH :
  ```
apt update
apt install -y openssh-server
```
Démarrage et activation du service :
  ```
systemctl start ssh
systemctl enable ssh
```
Vérification du service :
```
systemctl status ssh
```
Résultat attendu :
```
active (running)
```

  ## 4.3 Configuration du pare-feu (UFW)
Installation :
```
apt install -y ufw
```
Autoriser le port SSH
```
ufw allow 22/tcp
```
(Si modification du port SSH, adapter cette règle)

Activation du pare-feu
```
ufw enable
```
Vérification
```
ufw status
```
Résultat attendu :
```
22/tcp ALLOW
```
  ## 4.4 Sécurisation du service SSH

Modifier le fichier de configuration :
```
nano /etc/ssh/sshd_config
```
Modifications recommandées :
```
Port 222
PermitRootLogin no
PasswordAuthentication no
```
Redémarrage du service SSH :
```
systemctl restart ssh
```
Vérification :

Connexion depuis un client :
```
ssh utilisateur@172.16.10.10 -p 222
```
La connexion doit fonctionner avec une clé SSH.

Résultat attendu :

À la fin de cette étape :

Le serveur Debian est accessible en SSH
Le service SSH est sécurisé
Le pare-feu est actif et configuré
La communication réseau est fonctionnelle

# 5. Configuration du client Ubuntu (CLILIN01)

Objectif :

Configurer un poste client Ubuntu afin de :

- communiquer avec le serveur Debian via SSH
- permettre l’exécution de scripts distants
- tester la connectivité réseau

  ## 5.1 Configuration réseau

Configurer une adresse IP statique sur le client Ubuntu.

Configuration (interface graphique ou Netplan)

Exemple avec Netplan :

Fichier à modifier :
```
/etc/netplan/01-netcfg.yaml
```
Configuration type :
```
network:
  version: 2
  ethernets:
    ens18:
      dhcp4: no
      addresses:
        - 172.16.10.20/24
      gateway4: 172.16.10.1
```
Appliquer la configuration :
```
netplan apply
```
Vérification :
```
ip a
```
Vérifier que l’adresse IP est correcte
```
ping 172.16.10.10
```
Vérifier la communication avec le serveur Debian

  ## 5.2 Installation du client SSH :

Ubuntu possède généralement SSH installé, sinon :
```
apt update
apt install -y openssh-client
```
  ## 5.3 Génération d’une clé SSH :

Afin de sécuriser la connexion sans mot de passe :
```
ssh-keygen
```
Valider les options par défaut.

  ## 5.4 Envoi de la clé publique vers le serveur
```
ssh-copy-id utilisateur@172.16.10.10 -p 222
```
Vérification :

Connexion au serveur :

``` ssh utilisateur@172.16.10.10 -p 222 ```

La connexion doit se faire sans mot de passe

  ## 5.5 Test d’exécution de commande distante
``` ssh utilisateur@172.16.10.10 -p 222 "ls /home" ```

Permet de vérifier que le client peut exécuter des commandes sur le serveur

  ## 5.6 Transfert de fichiers (optionnel)

Utilisation de scp :

``` scp fichier.txt utilisateur@172.16.10.10:/home/utilisateur/ ```
Résultat attendu

À la fin de cette étape :

- Le client Ubuntu communique avec le serveur Debian
- La connexion SSH est fonctionnelle sans mot de passe
- Les commandes distantes peuvent être exécutées
- Le transfert de fichiers est possible

# 6. Configuration des machines Windows (SRVWIN01 et CLIWIN01)

Objectif :

Configurer les machines Windows afin de :

- activer la communication distante via WinRM
- permettre l’exécution de commandes à distance via PowerShell
- préparer l’environnement pour l’automatisation des scripts

  ## 6.1 Configuration réseau

Attribuer une adresse IP statique sur chaque machine.

Exemple :
SRVWIN01 : 172.16.10.5
CLIWIN01 : 172.16.10.6

Vérification :

Dans PowerShell :
``` 
ipconfig
ping 172.16.10.5 
``` 
Vérifier la communication entre les machines


  ## 6.2 Activation de WinRM

Lancer PowerShell en tant qu’administrateur :
``` 
winrm quickconfig
``` 
Répondre Y aux questions.

Vérification :
``` 
winrm enumerate winrm/config/listener
``` 
Vérifier que le listener est actif

  ## 6.3 Activation automatique du service WinRM

Pour éviter les problèmes après redémarrage :
``` 
Set-Service -Name WinRM -StartupType Automatic
Start-Service WinRM
``` 
Vérification :
``` 
Get-Service WinRM
``` 
Résultat attendu :

Status : Running

  ## 6.4 Configuration du pare-feu

Autoriser WinRM dans le pare-feu Windows :
``` 
Enable-PSRemoting -Force
``` 
Cette commande :

active WinRM
configure le pare-feu automatiquement

  ## 6.5 Autorisation des machines distantes

Ajouter la machine cliente dans les hôtes de confiance :
``` 
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "172.16.10.6"
``` 
(Pour plusieurs machines, séparer par des virgules)

Vérification :
``` 
Get-Item WSMan:\localhost\Client\TrustedHosts
``` 
  ## 6.6 Test de connexion distante

Depuis la machine cliente :
``` 
Test-WSMan 172.16.10.5
``` 
Permet de vérifier que WinRM répond

  ## 6.7 Exécution de commande à distance :
  ``` 
Invoke-Command -ComputerName 172.16.10.5 -ScriptBlock { hostname }
``` 
Avec authentification
```Enter-PSSession -ComputerName 172.16.10.5 -Credential (Get-Credential) ``` 

Résultat attendu

À la fin de cette étape :

- WinRM est actif et fonctionnel
- Le service démarre automatiquement
- Les machines peuvent communiquer à distance
- Les commandes PowerShell peuvent être exécutées à distance

# 7. Installation de PowerShell 7

Objectif :

Installer PowerShell 7 sur les machines Windows et Linux afin de :

- utiliser une version moderne et multiplateforme de PowerShell
- exécuter des scripts compatibles entre Windows et Linux
- faciliter l’administration distante et l’automatisation
-  Installation sur Windows (SRVWIN01 et CLIWIN01)
-  éléchargement

Télécharger la dernière version stable depuis le site officiel :

[https://github.com/PowerShell/PowerShell/releases](https://github.com/PowerShell/PowerShell/releases)


Choisir le fichier :

PowerShell-7.x.x-win-x64.msi

Installation :

Lancer le fichier .msi
Suivre l’assistant d’installation
Laisser les options par défaut recommandées

Vérification :

Ouvrir PowerShell 7 (pwsh) :
``` 
$PSVersionTable
``` 
Résultat attendu :
PowerShell 7 est installé
La commande pwsh fonctionne
La version affichée correspond à la version installée
7.2 Installation sur Linux (Debian / Ubuntu)
Installation via dépôt Microsoft
``` 
apt update
apt install -y wget apt-transport-https software-properties-common

wget -q https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb

apt update
apt install -y powershell
``` 
Lancement de PowerShell :
``` 
pwsh
``` 
Vérification :

Dans PowerShell :
``` 
$PSVersionTable
``` 
Résat attendu
PowerShell 7 est installé sur Linux
La commande pwsh fonctionne
L’environnement PowerShell est opérationnel

  ## 7.3 Utilisation dans le projet

PowerShell 7 permet :

- l’exécution de scripts sur Windows et Linux
- la gestion des machines à distance via WinRM
- la centralisation des tâches d’administration


À la fin de cette section :

PowerShell 7 est installé sur toutes les machines
Les scripts peuvent être exécutés de manière homogène
L’environnement est prêt pour l’automatisation complète du projet

Conclusion du document

L’ensemble des machines est maintenant configuré et opérationnel :

- Réseau fonctionnel entre tous les systèmes
- Accès SSH opérationnel sur Linux
- Accès distant via WinRM sur Windows
- PowerShell 7 installé sur toutes les machines

L’environnement est prêt pour le déploiement et l’exécution des scripts du projet.


