# INSTALL.md

## Sommaire

1. [Installation sur le serveur Debian SRVLX01](#1-installation-sur-le-serveur-debian-srvlx01)
   - 1.1 [Mise à jour du système](#11-mise-à-jour-du-système)
   - 1.2 [Installer le serveur OpenSSH](#12-installer-le-serveur-openssh)
   - 1.3 [Vérification du service](#13-vérification-du-service)
2. [Installation sur le client Ubuntu CLILIN01](#2-installation-sur-le-client-ubuntu-clilin01)
   - 2.1 [Installer OpenSSH](#21-installer-openssh)
   - 2.2 [Configuration du fichier SSH](#22-configuration-du-fichier-ssh)
3. [Installation sur le serveur Windows SRVWIN01](#3-installation-sur-le-serveur-windows-srvwin01)
   - 3.1 [Installer OpenSSH](#31-installer-openssh)
   - 3.2 [Démarrer le service SSH](#32-démarrer-le-service-ssh)
   - 3.3 [Vérification du service](#33-vérification-du-service)
4. [Connexion SSH entre les machines](#4-connexion-ssh-entre-les-machines)
   - 4.1 [Générer une clé SSH](#41-générer-une-clé-ssh)
   - 4.2 [Copier la clé sur les machines](#42-copier-la-clé-sur-les-machines)
   - 4.3 [Tester la connexion](#43-tester-la-connexion)
5. [Installation de Powershell sur Ubuntu](#5-installation-de-powershell-sur-ubuntu)

---

## Prérequis techniques

Avant l'installation, vous devez vous assurer que les machines respectent les critères définis pour le projet :

| Machine | OS | Accès requis |
|---|---|---|
| SRVLX01 | Debian | root ou sudo |
| CLILIN01 | Ubuntu 24 LTS | sudo |
| SRVWIN01 | Windows Server 2022 | Administrateur |
| CLIWIN01 | Windows 10/11 | Administrateur |

---

## 1. Installation sur le serveur Debian SRVLX01

### 1.1 Mise à jour du système

Connectez-vous avec l'utilisateur `wilder` ou `root`, puis mettez à jour le système :
```
sudo apt update && sudo apt upgrade -y
```
<img width="778" height="192" alt="sudo apt updat-1" src="https://github.com/user-attachments/assets/c6b236a7-c090-4921-8dc2-33abaced4433" />


### 1.2 Installer le serveur OpenSSH
```
sudo apt install openssh-server -y
```
<img width="940" height="451" alt="open ssh" src="https://github.com/user-attachments/assets/87e01651-f6c9-4d64-99e3-305fe6485267" />


### 1.3 Vérification du service
```
sudo systemctl status ssh
```
<img width="716" height="302" alt="verif ssh" src="https://github.com/user-attachments/assets/96c95c45-e151-480a-bb82-dc76185b3857" />

>  Le statut doit indiquer **active (running)** en vert.

---

## 2. Installation sur le client Ubuntu CLILIN01

### 2.1 Installer OpenSSH

Ouvrir le terminal et taper la commande suivante :
```
sudo apt update && sudo apt install openssh-server -y
```
<img width="738" height="152" alt="sudo apt ubuntu" src="https://github.com/user-attachments/assets/dd6590b8-52a3-43dc-95c1-5df1f205903a" />


Ensuite, démarrer et activer le service SSH :
```
sudo systemctl start ssh
sudo systemctl enable ssh
sudo systemctl status ssh
```
<img width="1122" height="539" alt="systemctl status" src="https://github.com/user-attachments/assets/269bc57f-b64d-41af-8630-9d4b809da96a" />


> Le statut doit indiquer **active (running)** en vert.

### 2.2 Configuration du fichier SSH

Configuration du pare-feu. Ubuntu active le pare-feu par défaut et bloque les connexions entrantes, y compris SSH. Il faut donc autoriser le port 22 :
```
sudo ufw allow ssh
sudo ufw enable
sudo ufw status
```
<img width="521" height="288" alt="Config pare-feu" src="https://github.com/user-attachments/assets/2f0cb5d7-af12-434e-ab6f-a87374a06a8a" />

> Résultat attendu : `22/tcp ALLOW`

---

# 3. Configuration des machine windows et Administration Distante de PowerShell (WinRM)


## 3.1. Installation de PowerShell 7 (poste serveur)


- Version de PowerShell actuelle

Commande pour connaitre la version de son PowerShell
```
$PsVersionTable.PSVersion
```

![Administration-Distante-powershell-1](RESOURCE/Administration-Distante-Powershell-1.png)


- Le but ?
Passer de Windows PowerShell 5.1 à PowerShell Core (pwsh).

- Pourquoi ? 
Pour avoir le même langage sur Windows et Ubuntu (Multiplateforme). Cela évite les erreurs de compatibilité de syntaxe entre tes scripts.

Commande (Installation propre par MSI) :

 Ouvrir l'invite de commande "Powershell".

Premièrement taper :

```
$url = "https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/PowerShell-7.4.1-win-x64.msi"
```
![Administration-Distante-Powershell-2](RESOURCE/Administration-Distante-Powershell-2.png)

Puis 
```
$dest = "$env:TEMP\pwsh.msi"
```
![Administration-Distante-Powershell-3](RESOURCE/Administration-Distante-Powershell-3.png)

Ensuite
```
Invoke-WebRequest -Uri $url -OutFile $dest
```
![Administration-Distante-Powershell-4](RESOURCE/Administration-Distante-Powershell-4.png)

![Administration-Distante-Powershell-5](RESOURCE/Administration-Distante-Powershell-5.png)

Enfin
```
Start-Process msiexec.exe -ArgumentList "/i $dest /quiet /norestart" -Wait``
```
![Administration-Distante-Powershell-6](RESOURCE/Administration-Distante-Powershell-6.png)




Pour finir : Verification que Powershell 7 est bien installé 

Aller dans la barre de recherche windows et taper 
```
Windows Powershell
```

![[Administration-Distante-Powershell-8.png]](RESOURCE/Administration-Distante-Powershell-8.png)

Il est bien présent : l'installation a réussie.

- Au lancement de powershell, il m'indique qu'une nouvelle version existe a télécharger via ce lien :
```
https://github.com/PowerShell/PowerShell/releases/tag/v7.6.0
```
![[Administration-Distante-Powershell-10.png]](RESOURCE/Administration-Distante-Powershell-10.png)

Une fois téléchargé, le lancer :

![[Administration-Distante-Powershell-9.png]](RESOURCE/Administration-Distante-Powershell-9.png)


Dans le dossier téléchargement :


![[Administration-Distante-Powershell-11.png]](RESOURCE/Administration-Distante-Powershell-11.png)


![[Administration-Distante-Powershell-12.png]](RESOURCE/Administration-Distante-Powershell-12.png)

![[Administration-Distante-Powershell-13.png]](RESOURCE/Administration-Distante-Powershell-13.png)

![[Administration-Distante-Powershell-14.png]](RESOURCE/Administration-Distante-Powershell-14.png)

![[Administration-Distante-Powershell-15.png]](RESOURCE/Administration-Distante-Powershell-15.png)


![[Administration-Distante-Powershell-16.png]](RESOURCE/Administration-Distante-Powershell-16.png)


Installation complète.

![[Administration-Distante-Powershell-17.png]](RESOURCE/Administration-Distante-Powershell-17.png)


Ouverture de Powershell 7.6 :

![[Administration-Distante-Powershell-18.png]](RESOURCE/Administration-Distante-Powershell-18.png)










#### 3.2. Configuration du Poste Client (Cible : Windows 11)

Attention !!!     =>  C'est l'étape la plus critique. Sans ces 3 points, le serveur ne peut pas "entrer" dans le client.

#### A. Le Profil Réseau (La clé du Pare-feu)

Pourquoi ?
- Par défaut, une VM peut être en profil "Public". Windows bloque alors WinRM pour des raisons de sécurité. Le passer en "Privé" ouvre automatiquement les routes nécessaires.


Dans l'invite de commande PowerShell et taper :

``` 
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
```

![[Administration-Distante-Powershell-19.png]](RESOURCE/Administration-Distante-Powershell-19.png)



#### B. Activation de WinRM (Le protocole)

Pourquoi ? 
- C'est le service qui écoute les ordres envoyés par Invoke-Command. On le configure en automatique pour qu'il survive à un redémarrage (Reboot).


Tapez 
```
Enable-PSRemoting -Force
```


![[Administration-Distante-Powershell-20.png]](RESOURCE/Administration-Distante-Powershell-20.png)


Puis
```
Set-Service WinRM -StartupType Automatic
```


![[Administration-Distante-Powershell-21.png]](RESOURCE/Administration-Distante-Powershell-21.png)


#### C. La Levée du Verrou Admin (UAC Distant).

Pourquoi ? 
- Dans un groupe de travail (sans domaine AD), Windows bloque les privilèges "Admin" pour les connexions distantes.
- Cette clé de registre permet à ton utilisateur "$USER" d'avoir les pleins pouvoirs à distance.

Taper 
```
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -Value 1 -PropertyType DWord -Force
Diagnostic et Vérification (Depuis le Serveur),
```


![[Administration-Distante-Powershell-22.png]](RESOURCE/Administration-Distante-Powershell-22.png)


###### D. Le but  étant de tester avant de lancer le script final.

Test de port (Couche 4) : Vérifie si le port 5985 (WinRM HTTP) est ouvert.

```
Test-NetConnection -ComputerName 172.16.20.20 -Port 5985
```

![[Administration-Distante-Powershell-23.png]](RESOURCE/Administration-Distante-Powershell-23.png)




Puis

Test WinRM (Couche 7) : Vérifie si le service répond intelligemment.

```
Test-WSMan -ComputerName 172.16.20.20 
```

![[Administration-Distante-Powershell-24.png]](RESOURCE/Administration-Distante-Powershell-24.png)

---

## 4. Connexion SSH entre les machines

### 4.1 Générer une clé SSH

Depuis la machine **CLILIN01**, générer une clé SSH de type ed25519 :
```
ssh-keygen -t ed25519
```

> Appuyer sur **Entrée** pour valider les options par défaut.

### 4.2 Copier la clé sur les machines

Copier la clé publique vers les serveurs :
```
# Vers SRVLX01
ssh-copy-id -i ~/.ssh/id_ed25519.pub wilder@172.16.10.10

# Vers SRVWIN01
ssh-copy-id -i ~/.ssh/id_ed25519.pub wilder@172.16.10.5
```

### 4.3 Tester la connexion
```
# Connexion vers SRVLX01
ssh wilder@172.16.10.10

# Connexion vers SRVWIN01
ssh wilder@172.16.10.5
```

> La connexion doit s'établir **sans demander de mot de passe**.



## 5. Installation de Powershell sur Ubuntu

# Powershell

Powershell est le shell système de Microsoft pour ses socles Windows. Vous pouvez utiliser ce shell Microsoft sous Linux pour piloter des applications et développer vos propres scripts.

## Prérequis

Vous devez d'abord récupérer le paquetage Microsoft d'installation des outils sous Linux.

```
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
```

![[Installation-Powershell-Linux-1.png]](RESOURCE/Installation-Powershell-Linux-1.png)


Installez ce paquetage.

````
dpkg -i packages-microsoft-prod.deb
`````

![[Pasted image 20260417101545.png]](RESOURCE/Installation-Powershell-Linux-2.png)


Mettez à jours la base Ubuntu des applications.

````
sudo apt-get update
`````

![[Installation-Powershell-Linux-3.png]](RESOURCE/Installation-Powershell-Linux-3.png)


![[Installation-Powershell-Linux-4.png]](RESOURCE/Installation-Powershell-Linux-4.png)



## Installation

Vous pouvez maintenant installer le Powershell sous Linux avec la commande ci-dessous

````
sudo apt-get install -y powershell
`````

![[Installation-Powershell-Linux-5.png]](RESOURCE/Installation-Powershell-Linux-5.png)

