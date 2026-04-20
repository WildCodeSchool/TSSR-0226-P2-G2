#Requires -RunAsAdministrator
function Menu-AdminWindows {
param($CIBLE, $cred) # On ajoute $cred ici pour qu'il reçoive celui du parent

#$CIBLE = "172.16.20.20"
$LOG_FILE = Join-Path $PSScriptRoot "log_evt.log"

# --- FONCTION D EXPORTATION (CAHIER DES CHARGES) ---
function Enregistrer-Infos {
param([string]$NomCible, [string]$Donnees)
$dossierInfo = Join-Path $PSScriptRoot "info"
if (-not (Test-Path $dossierInfo)) { New-Item -Path $dossierInfo -ItemType Directory | Out-Null }
$dateF = Get-Date -Format "yyyyMMdd"
$nomFichier = "info_$($NomCible)_$($dateF).txt"
$cheminComplet = Join-Path $dossierInfo $nomFichier
$Donnees | Out-File -FilePath $cheminComplet -Encoding utf8 -Append
Write-Host "`n[INFO] Donnees enregistrees dans info/$nomFichier" -ForegroundColor Gray
}

# --- FONCTION LOG D AUDIT ---
function Ecrire-Log { 
param($Action) 
$d = Get-Date -Format "yyyyMMdd_HHmmss"
"${d}_CIBLE:$CIBLE _USER:$($env:USERNAME)_ACTION:$Action" | Out-File $LOG_FILE -Append 
}

# --- CONNEXION ---
Clear-Host
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "          INITIALISATION DU PILOTAGE DISTANT"           -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
#$cred = Get-Credential -UserName "wilder" -Message "Acces distant Windows 11"

while ($true) {
Clear-Host
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "           PANNEAU D'ADMINISTRATION : $CIBLE"             -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  [1]  Gestion des Utilisateurs et Groupes"
Write-Host "  [2]  Inventaire Materiel et Systeme"
Write-Host "  [3]  Configuration et Diagnostic Reseau"
Write-Host "  [4]  Maintenance, Securite et Alimentation"
Write-Host "  [5]  Consultation des Logs et Rapports"
Write-Host "--------------------------------------------------------" -ForegroundColor Cyan
Write-Host "  [0]  QUITTER LE SCRIPT"
Write-Host "========================================================" -ForegroundColor Cyan

$choix = Read-Host "`nSelectionnez une categorie"
    if ($choix -eq "0") { exit }

    switch ($choix) {
            "1" {
            while ($true) {
Clear-Host
Write-Host "========================================================" -ForegroundColor Yellow
Write-Host "             GESTION DES COMPTES LOCAUX"                         -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Yellow
Write-Host "1) Creer un Utilisateur"
Write-Host "2) Supprimer Utilisateur"
Write-Host "3) Modifier Mot de passe"
Write-Host "4) Modifier Groupe d'utilisateur"
Write-Host "5) Desativer Utilisateur"
Write-Host "6) Activer Utilisateur"
Write-Host "7) Liste d'Utilisateur"
Write-Host "8) Export information Utilisateur"
Write-Host "9) Groupes local d'Utilisateur"
Write-Host "--------------------------------------------------------"
Write-Host "  0. Retour au menu principal"

$sub = Read-Host "`nAction"
    if ($sub -eq "0") { break }
$u = ""
    if ($sub -match "[1-6,8]") { $u = Read-Host "Nom de l utilisateur" }

$resultat = Invoke-Command -ComputerName $CIBLE -Credential $cred -ScriptBlock {
        param($name, $action)
    try {
    if($action -eq "1"){ 
		try{
			New-LocalUser -Name $name -NoPassword -ErrorAction Stop
			Write-Host "`n[SUCCES} Utilisateur $name cree avec succes." -ForegroundColor Green 
			return "Utilisateur $name cree."
			}
			catch {
			Write-host "`n[ERREUR} Impossible de creer l'Utilisateur $name : $($_.Exeption.Message)" -ForegroundColor Red
			return "ERREUR : Creation de $name echouee."
			}
		}
     elseif($action -eq "2"){ 
		try{
			Remove-LocalUser -Name $name -ErrorAction Stop
			Write-Host "`n[SUCCES Utilisateur $name supprime." -ForegroundColor Green
			$resultat = "Utilisateur $name supprime."
			}
			catch {
			Write-Host "`n[ERREUR] Impossible de supprimer $name ." -ForegroundColor Red
			$resultat = "Echec de suppression."
			}
			return $resulat
		}
	elseif($action -eq "3"){
 			$p = Read-Host "Nouveau MDP" -AsSecureString; Set-LocalUser -Name $name -Password $p
			return "[OK] MDP modifie." 
			}
                        elseif($action -eq "4"){ 
                            $g = Read-Host "Nom du groupe"; Add-LocalGroupMember -Group $g -Member $name
                            return "[OK] $name ajoute au groupe $g."
                        }
                        elseif($action -eq "5"){
			 Disable-LocalUser -Name $name; return "[OK] Compte '$name' desactive." 
			}
                        elseif($action -eq "6"){
			 Enable-LocalUser -Name $name; return "[OK] Compte '$name' reactive." 
			}
                        
elseif($action -eq "7"){ 
    $allUsers = Get-LocalUser
    Write-Host "-----------------------------------------------------------------------"
    Write-Host ("NOM".PadRight(20) + "STATUT".PadRight(15) + "GROUPES")
    Write-Host "-----------------------------------------------------------------------"

    foreach ($user in $allUsers) {
        $groups = Get-LocalGroup | Where-Object { 
            (Get-LocalGroupMember -Group $_.Name -ErrorAction SilentlyContinue).Name -contains "$($env:COMPUTERNAME)\$($user.Name)" 
        }
        $nomsGroupes = $groups.Name -join ', '

        # --- AFFICHAGE AVEC COULEUR ---
        Write-Host $user.Name.PadRight(20) -NoNewline
        
        if ($user.Enabled) {
            Write-Host "[ACTIF]".PadRight(15) -ForegroundColor Green -NoNewline
        } else {
            Write-Host "[DESACTIVE]".PadRight(15) -ForegroundColor Red -NoNewline
        }
        
        Write-Host $nomsGroupes
    }
    return "-----------------------------------------------------------------------"
}
    elseif($action -eq "8"){
		 return Get-LocalUser -Name $name | Select * | Out-String 
}
    elseif($action -eq "9"){
		 return Get-LocalGroup | Select Name, Description | Out-String 
}

}
 	catch { 
		return "Erreur : $($_.Exception.Message)" 
}
} -ArgumentList $u, $sub

Write-Host "`n$resultat"
    if ($sub -eq "8") { Enregistrer-Infos -NomCible $u -Donnees $resultat }
    Ecrire-Log "UserAction_$sub"; Pause
    }
}

            "2" {
Clear-Host
Write-Host "========================================================" -ForegroundColor Yellow
Write-Host "            INFORMATIONS SYSTEME DISTANTE"                   -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Yellow
    if (Test-Connection -ComputerName $CIBLE -Count 1 -Quiet) {
    try {
$resultatSys = Invoke-Command -ComputerName $CIBLE -Credential $cred -ScriptBlock {
$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$res = "`n--- RAPPORT SYSTEME ---`n"
$res += "Nom PC     : $($cs.Name)`n"
$res += "Fabricant  : $($cs.Manufacturer)`n"
$res += "OS         : $($os.Caption)`n"
$res += "RAM Totale : $([math]::Round($os.TotalVisibleMemorySize / 1MB, 2)) Go`n"
return $res
    }
Write-Host $resultatSys -ForegroundColor Cyan
Enregistrer-Infos -NomCible "CLIWIN01" -Donnees $resultatSys
    } catch { Write-Host "[ERREUR] Acces refuse." -ForegroundColor Red }
}
    Ecrire-Log "Consultation_Systeme"; Pause
}
"3" {
Clear-Host
Write-Host "========================================================" -ForegroundColor Yellow
Write-Host "                  CONFIGURATION RESEAU"                           -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Yellow
Write-Host "Recuperation et exportation des donnees reseau..." -ForegroundColor Cyan

$resultatNet = Invoke-Command -ComputerName $CIBLE -Credential $cred -ScriptBlock {
$config = Get-NetIPConfiguration | Where-Object {$_.IPv4Address -ne $null}
$res = "`n--- RAPPORT RESEAU ---`n"
foreach ($c in $config) {
$res += "Interface  : $($c.InterfaceAlias)`n"
$res += "Adresse IP : $($c.IPv4Address.IPAddress)`n"
$res += "Passerelle : $($c.IPv4DefaultGateway.NextHop)`n"
$res += "DNS        : $($c.DNSServer.ServerAddresses -join ', ')`n"
$res += "-----------------------------------`n"
}
return $res
}

# Affichage console
Write-Host $resultatNet -ForegroundColor Green

# EXPORTATION DANS LE DOSSIER INFO (Comme demande)
Enregistrer-Infos -NomCible "RESEAU_CLIWIN01" -Donnees $resultatNet

Ecrire-Log "Consultation_Reseau"; Pause
}
# --- MENU MAINTENANCE ---
            "4" {
while ($true) {
Clear-Host
Write-Host "========================================================" -ForegroundColor Yellow
Write-Host "              MAINTENANCE ET SECURITE"                    -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Yellow
Write-Host "1) Creer un repertoire"
Write-Host "2) Supprimer un repertoire"
Write-Host "3) Activer tous les Pare-feu"
Write-Host "4) Desactiver tous les Pare-feu"
Write-Host "5) Verifier l'etat des Pare-feu"
Write-Host "6) Redemarrer la machine distante"
Write-Host "0) Retour"

$sub = Read-Host "`nChoix"
    if ($sub -eq "0") { break }

# Option Redémarrage
    if ($sub -eq "6") {
Ecrire-Log "Demande_Reboot"
Restart-Computer -ComputerName $CIBLE -Credential $cred -Force
exit
}

# Option Vérification Pare-feu (Pas besoin de saisir un chemin)
    if ($sub -eq "5") {
Invoke-Command -ComputerName $CIBLE -Credential $cred -ScriptBlock {
Write-Host "`n--- ETAT DES PROFILS PARE-FEU ---" -ForegroundColor Cyan
Get-NetFirewallProfile | Select-Object Name, Enabled | Format-Table -AutoSize
    }
Ecrire-Log "Verif_Firewall"; Pause; continue
}

# Actions nécessitant une saisie de chemin (Options 1 et 2)
$chemin = ""
if ($sub -eq "1" -or $sub -eq "2") {
$chemin = Read-Host "Entrez le chemin complet (ex: C:\Test)"
}

Invoke-Command -ComputerName $CIBLE -Credential $cred -ScriptBlock {
    param($p, $opt)
    try {
    if($opt -eq "1"){ 
New-Item -Path $p -ItemType Directory -Force -ErrorAction Stop | Out-Null
Write-Host "`n[OK] Le repertoire '$p' a ete cree." -ForegroundColor Green
}
    elseif($opt -eq "2"){ 
Remove-Item -Path $p -Recurse -Force -ErrorAction Stop
Write-Host "`n[OK] Le repertoire '$p' a ete supprime." -ForegroundColor Red
}
    elseif($opt -eq "3"){ 
Set-NetFirewallProfile -All -Enabled True
Write-Host "`n[OK] Tous les profils Pare-feu sont ACTIVES." -ForegroundColor Green
}
    elseif($opt -eq "4"){ 
Set-NetFirewallProfile -All -Enabled False
Write-Host "`n[ATTENTION] Tous les profils Pare-feu sont DESACTIVES." -ForegroundColor Yellow
    }
} catch {
Write-Host "`n[ERREUR] : $($_.Exception.Message)" -ForegroundColor Red
    }
} -ArgumentList $chemin, $sub

Ecrire-Log "Maint_Action_$sub _Cible:$chemin"
Pause
    }
}

        "5" {
while ($true) {
Clear-Host
Write-Host "========================================================" -ForegroundColor Yellow
Write-Host "         MODULE : LOGS ET RAPPORTS EXPORTES"                   -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Yellow

Write-Host "  1. Rechercher dans log_evt.log"
Write-Host "  2. Lire un rapport du dossier /info"
Write-Host "--------------------------------------------------------"
Write-Host "  0. Retour au menu principal"

$choixLog = Read-Host "`nChoix"
    if ($choixLog -eq "0") { break }

    if ($choixLog -eq "1") {
$search = Read-Host "Mot-cle"
Get-Content $LOG_FILE | Select-String -Pattern $search
Pause
}
elseif ($choixLog -eq "2") {
    $dossierInfo = Join-Path $PSScriptRoot "info"
    
    if (Test-Path $dossierInfo) {
        $fichiers = Get-ChildItem -Path $dossierInfo -Filter "*.txt"
        
        if ($fichiers.Count -eq 0) {
            Write-Host "[!] Aucun rapport trouve dans le dossier info." -ForegroundColor Yellow
        } else {
            # Affichage de la liste
            for ($i=0; $i -lt $fichiers.Count; $i++) { 
                Write-Host "  $($i+1). $($fichiers[$i].Name)" 
            }

            $index = Read-Host "`nNumero du fichier a lire"
            
            # Vérification et lecture
            if ($index -match '^\d+$' -and $index -gt 0 -and $index -le $fichiers.Count) {
                $cibleLecture = $fichiers[$index-1].FullName
                Write-Host "`n--- CONTENU DU RAPPORT : $($fichiers[$index-1].Name) ---" -ForegroundColor Cyan
                
                # ON UTILISE WRITE-HOST POUR FORCER L'AFFICHAGE
                $contenu = Get-Content $cibleLecture
                foreach ($ligne in $contenu) { Write-Host $ligne }
                
                Write-Host "--------------------------------------------------------" -ForegroundColor Cyan
            } else {
                Write-Host "[ERREUR] Choix invalide." -ForegroundColor Red
            }
        }
    } else {
        Write-Host "[ERREUR] Le dossier info n'existe pas." -ForegroundColor Red
    }
    Pause
}
