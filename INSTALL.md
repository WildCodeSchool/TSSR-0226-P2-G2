INSTALL.md

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

---

## Prérequis techniques

Avant l'installation, vous devez vous assurer que les machines respectent les critères définis pour le projet :

| Machine | OS | Accès requis |
|---|---|---|
| SRVLX01 | Debian 12 | root ou sudo |
| CLILIN01 | Ubuntu 24 LTS | sudo |
| SRVWIN01 | Windows Server 2022 | Administrateur |
| CLIWIN01 | Windows 10/11 | Administrateur |

---

## 1. Installation sur le serveur Debian SRVLX01

### 1.1 Mise à jour du système

Connectez-vous avec l'utilisateur `wilder` ou `root`, puis mettez à jour le système :

sudo apt update && sudo apt upgrade -y

<img width="778" height="192" alt="sudo apt updat-1" src="https://github.com/user-attachments/assets/c6b236a7-c090-4921-8dc2-33abaced4433" />


### 1.2 Installer le serveur OpenSSH

sudo apt install openssh-server -y

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

sudo ufw allow ssh
sudo ufw enable
sudo ufw status

<img width="521" height="288" alt="Config pare-feu" src="https://github.com/user-attachments/assets/2f0cb5d7-af12-434e-ab6f-a87374a06a8a" />

> Résultat attendu : `22/tcp ALLOW`

---

## 3. Installation sur le serveur Windows SRVWIN01

### 3.1 Installer OpenSSH

Ouvrir PowerShell en tant qu'Administrateur et taper la commande suivante :
powershell
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

<img width="926" height="204" alt="Openssh SRVWIN01" src="https://github.com/user-attachments/assets/27c0e0f2-f66c-432a-ba91-94d28d3aa43e" />


### 3.2 Démarrer le service SSH
```powershell
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic
```

### 3.3 Vérification du service
```powershell
Get-Service sshd
```

> Le statut doit indiquer **Running**.

Tester la connexion en local :
```powershell
ssh localhost
```

---

## 4. Connexion SSH entre les machines

### 4.1 Générer une clé SSH

Depuis la machine **CLILIN01**, générer une clé SSH de type ed25519 :
```bash
ssh-keygen -t ed25519
```

> Appuyer sur **Entrée** pour valider les options par défaut.

### 4.2 Copier la clé sur les machines

Copier la clé publique vers les serveurs :
```bash
# Vers SRVLX01
ssh-copy-id -i ~/.ssh/id_ed25519.pub wilder@172.16.10.10

# Vers SRVWIN01
ssh-copy-id -i ~/.ssh/id_ed25519.pub wilder@172.16.10.5
```

### 4.3 Tester la connexion
```bash
# Connexion vers SRVLX01
ssh wilder@172.16.10.10

# Connexion vers SRVWIN01
ssh wilder@172.16.10.5
```

> La connexion doit s'établir **sans demander de mot de passe**.
