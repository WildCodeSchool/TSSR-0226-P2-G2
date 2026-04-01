INSTALL.md

---
**Sommaire**

 1. [ Installation sur le serveur Debian SRVLX01](#installation-sur-le-serveurèdebian-srvlx01)
    
     1.1   [ Mise à jour du système](#Mise-à-jour-du-système)
        
     1.2   [ Installer le serveur OpenSSH](#installer-le-serveur)

     1.3   [ Vérification du service](#vérication-du-serveur)

 2. [ Installation sur le client Ubuntu CLILIN01](#installation-sur-le-client-ubuntu-clilin01)

        
     2.1   [ Sur la machine CLILIN01, ouvrir le terminal et utiliser la commmande](#sur-la-machine-CLILIN01,-ouvrir-le-terminal-et-utiliser-la-commande)

 3. [ Installation sur le serveur Windows (Windows Server 2022)](#installation-sur-le-serveur-windows-(windows-server-2022))
---

## Connection ssh des machines du réseau :

### Prérequis techniques :


    Avant l'installation, vous devez vous assurez que les machines 
    respectent les critères définis pour le projet :

- Serveur : Debian (SRVLX01) accès root ou sudo
- Client : Ubuntu 24 LTS (CLILIN01) avec accès sudo



**1. Installation sur le serveur Debian**

#### 1.1 **Mise à jour du système**


Connectez-vous avec l'utlisateur wilder ou root, et mettre à jour avec la commande :
`sudo apt update`

<img width="778" height="192" alt="sudo apt updat-1" src="https://github.com/user-attachments/assets/5e9bd04c-e322-4e7b-bfce-560cdb13fd8d" />


1.2 **Installer le serveur OpenSSH** 
Utilisez la commande :
 `apt install openssh-server -y`

<img width="940" height="451" alt="open ssh" src="https://github.com/user-attachments/assets/6f0c6c36-e27d-4126-9edd-a41ddbe42106" />

1.3 **Vérification du service** 
Utilisez la commande suivante (toujours sur root) : `systemctl status ssh`

<img width="716" height="302" alt="verif ssh" src="https://github.com/user-attachments/assets/6cfabcca-428a-45ed-bb71-f2e97db61b63" />


- Le statut doit indiquer active (running) en vert.
  

---


**2. Installation sur le Client Ubuntu (CLILIN01)**

2.1 Sur la machine CLILIN01, ouvrir le terminal et utiliser la commmande :

- `sudo apt update && sudo apt install openssh-server -y`

<img width="738" height="152" alt="sudo apt ubuntu" src="https://github.com/user-attachments/assets/6d548639-4435-4bc7-9b0b-6270db3ed95f" />

Ensuite nous devons utilisez les commandes suivantes :
- `sudo systemctl start`
- `sudo systemctl enable`
- `sudo systemctl status ssh`

<img width="1122" height="539" alt="systemctl status" src="https://github.com/user-attachments/assets/d705dfc8-0758-46b9-b69b-403c8cc3d212" />

2.2 Configuration du ficher configuration SSH**


 Configuration du pare-feu par défaut. Nous devons autoriser le port SSH (22) car, 
Ubuntu active le pare-feu par défaut et bloque les connexions entrant, y compris **SSH.**
 - `sudo ufw allow ssh` puis `sudo ufw enable` et on vérifie le port SSH (22) en tapant `sudo ufw status`

<img width="1122" height="539" alt="systemctl status" src="https://github.com/user-attachments/assets/1be59acb-c163-42ea-84dd-b0642b003a1c" />

 **Résultat attendu** : 22/tcp ALLOW
 

  **3. Installation sur le serveur Windows (Windows Server 2022)**

  3.1 Sur la machine SRVWIN01, installer OpenSSH, ouvrir le terminal utilisez la commande suivante :
  
  `Add-WindowsCapability -Online -Name`

<img width="926" height="204" alt="Openssh SRVWIN01" src="https://github.com/user-attachments/assets/c3dc47f8-6b6b-42c4-96b0-2bac621215f0" />

  ensuite pour confirmer l'utilisation de SSH :
  `ssh localhost`


<img width="926" height="148" alt="ssh localhost" src="https://github.com/user-attachments/assets/862566f2-d87b-4f22-a4ec-b10d8b83e20b" />
