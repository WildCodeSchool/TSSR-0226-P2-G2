#Requires -RunAsAdministrator

# ==============================================================================
# 1. CONFIGURATION ET VARIABLES GLOBALES
# ==============================================================================
$IP_WIN = "172.16.20.20"
$IP_LIN = "172.16.20.30"
$USER_WIN = "wilder"
$LOG_FILE = Join-Path $PSScriptRoot "log_evt.log"

# --- FONCTION D'EXPORTATION ---
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

# --- FONCTION LOG D'AUDIT ---
function Ecrire-Log { 
    param($Action, $Cible) 
    $d = Get-Date -Format "yyyyMMdd_HHmmss"
    "${d}_CIBLE:$Cible _USER:$($env:USERNAME)_ACTION:$Action" | Out-File $LOG_FILE -Append 
}

# ==============================================================================
# 2. MENU PRINCIPAL
# ==============================================================================
while ($true) {
    Clear-Host
    Write-Host "====================================================" -ForegroundColor Green
    Write-Host "       STATION DE CONTROLE MULTI-PLATEFORME"         -ForegroundColor Green
    Write-Host "====================================================" -ForegroundColor Green
    Write-Host "  1- Piloter Client Ubuntu     ($IP_LIN)"
    Write-Host "  2- Piloter Client Windows 11 ($IP_WIN)"
    Write-Host "  0- Quitter le script"
    Write-Host "====================================================" -ForegroundColor Green
    
    $choixPrincipal = Read-Host "`nFaites votre choix"
    
    switch ($choixPrincipal) {
        "1" { 
            Write-Host "`n[TENTATIVE] Connexion SSH vers $IP_LIN..." -ForegroundColor Yellow
            ssh "$USER_WIN@$IP_LIN"
        }

        "2" { 
            Write-Host "`n[TENTATIVE] Connexion WinRM vers $IP_WIN..." -ForegroundColor Cyan
            # On demande les identifiants ici pour qu'ils servent à tout le menu Windows
            $global:remoteCred = Get-Credential -UserName $USER_WIN -Message "Acces WinRM vers Windows 11"

            if (Test-WSMan -ComputerName $IP_WIN -ErrorAction SilentlyContinue) {
                Write-Host "[OK] Connexion etablie avec succes. Lancement du menu..." -ForegroundColor Green
                Pause
                # APPEL DE LA FONCTION : On lance ton menu ici
                Menu-AdminWindows -CIBLE $IP_WIN
            } else {
                Write-Host "[ERREUR] Impossible d'etablir la connexion WinRM." -ForegroundColor Red
                Pause
            }
        }

        "0" { exit }
    }
}

# ==============================================================================
# 3. FONCTION : ADMINISTRATION WINDOWS
# ==============================================================================
function Menu-AdminWindows {
    param($CIBLE)
    
    # On récupère les identifiants saisis dans le menu principal
    $cred = $global:remoteCred

    while ($true) {
        Clear-Host
        Write-Host "========================================================" -ForegroundColor Cyan
        Write-Host "         PANNEAU d'ADMINISTRATION : $CIBLE"             -ForegroundColor Cyan
        Write-Host "========================================================" -ForegroundColor Cyan
        Write-Host "  [1]  Gestion des Utilisateurs et Groupes"
        Write-Host "  [2]  Inventaire Materiel et Systeme"
        Write-Host "  [3]  Configuration et Diagnostic Reseau"
        Write-Host "  [4]  Maintenance, Securite et Alimentation"
        Write-Host "  [5]  Consultation des Logs et Rapports"
        Write-Host "--------------------------------------------------------" -ForegroundColor Cyan
        Write-Host "  [0]  RETOUR AU MENU PRINCIPAL"
        Write-Host "========================================================" -ForegroundColor Cyan
        
        $choix = Read-Host "`nSelectionnez une categorie"
        if ($choix -eq "0") { break }

        switch ($choix) {
            "1" {
                while ($true) {
                    Clear-Host
                    Write-Host "========================================================" -ForegroundColor Cyan
                    Write-Host "               GESTION DES COMPTES LOCAUX " -ForegroundColor Yellow
                    Write-Host "========================================================" -ForegroundColor Cyan
                    Write-Host "1) Creer"
                    Write-Host "2) Supprimer"
                    Write-Host "3) Modifier Mot de Passe"
                    Write-Host "4) Groupe d'Utilisateurs"
                    Write-Host "5) Desactiver Utilisateur"
                    Write-Host "6) Activer Utilisateur"
                    Write-Host "7) Liste d'Utilisateur" 
                    Write-Host "8) Exporter utilisateur" 
                    Write-Host "9) Groupes local d'Utilisateur"
                    Write-Host "--------------------------------------------------------"
                    Write-Host "  0. Retour au menu principal" 
                    Write-Host "========================================================" -ForegroundColor Cyan

                    $sub = Read-Host "`nChoix"
                    if ($sub -eq "0") { break }
                    
                    $u = ""
                    if ($sub -match "[1-6,8]") { $u = Read-Host "Nom de l'utilisateur" }

                    # CORRECTION : Utilisation de -ComputerName au lieu de -HostName
                    $resultat = Invoke-Command -ComputerName $CIBLE -Credential $cred -ScriptBlock {
                        param($name, $action)
                        try {
                            if($action -eq "1"){ New-LocalUser -Name $name -NoPassword; return "Utilisateur $name cree." }
                            elseif($action -eq "2"){ Remove-LocalUser -Name $name; return "Supprime" }
                            elseif($action -eq "3"){ $p = Read-Host "Nouveau MDP" -AsSecureString; Set-LocalUser -Name $name -Password $p; return "[OK] MDP modifie." }
                            elseif($action -eq "4"){ $g = Read-Host "Nom du groupe"; Add-LocalGroupMember -Group $g -Member $name; return "[OK] ajoute au groupe $g." }
                            elseif($action -eq "5"){ Disable-LocalUser -Name $name; return "[OK] Compte '$name' desactive." }
                            elseif($action -eq "6"){ Enable-LocalUser -Name $name; return "[OK] Compte '$name' reactive." }
                            elseif($action -eq "7"){ 
                                $allUsers = Get-LocalUser
                                $report = ""
                                foreach ($user in $allUsers) {
                                    $groups = Get-LocalGroup | Where-Object { (Get-LocalGroupMember -Group $_.Name -ErrorAction SilentlyContinue).Name -contains "$($user.Name)" }
                                    $report += "Utilisateur : $($user.Name) | Etat : $(if($user.Enabled){'Active'}else{'Desactive'}) | Groupes : $($groups.Name -join ', ')`n"
                                }
                                return $report
                            }
                            elseif($action -eq "8"){ return Get-LocalUser -Name $name | Select * | Out-String }
                            elseif($action -eq "9"){ return Get-LocalGroup | Select Name, Description | Out-String }
                        } catch { return "Erreur : $($_.Exception.Message)" }
                    } -ArgumentList $u, $sub
                    
                    Write-Host "`n$resultat"
                    if ($sub -eq "8") { Enregistrer-Infos -NomCible $u -Donnees $resultat }
                    Ecrire-Log -Action "UserAction_$sub" -Cible $CIBLE; Pause
                }
            }

            "2" {
                Clear-Host
                Write-Host "========================================================" -ForegroundColor Yellow
                Write-Host "             INFORMATIONS SYSTEME DISTANTE" -ForegroundColor Yellow
                Write-Host "========================================================" -ForegroundColor Yellow
                Write-Host "Chargement des donnees en cours..." -ForegroundColor Cyan

                Invoke-Command -ComputerName $CIBLE -Credential $cred -ScriptBlock {
                    $os = Get-CimInstance Win32_OperatingSystem
                    $cs = Get-CimInstance Win32_ComputerSystem
                    Write-Host "`n--- CARACTERISTIQUES MATERIELLES ---" -ForegroundColor Green
                    [PSCustomObject]@{ Modele = $cs.Model; Fabricant = $cs.Manufacturer; Processeur = (Get-CimInstance Win32_Processor).Name } | Format-List
                    Write-Host "--- SYSTEME D'EXPLOITATION ---" -ForegroundColor Green
                    [PSCustomObject]@{ Version_OS = (Get-ComputerInfo).OsName; Architecture = $os.OSArchitecture; UAC = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System").EnableLUA } | Format-List
                    Write-Host "--- MEMOIRE RAM ---" -ForegroundColor Green
                    Write-Host "RAM Totale : $([math]::Round($os.TotalVisibleMemorySize / 1MB, 2)) Go"
                    Write-Host "RAM Libre  : $([math]::Round($os.FreePhysicalMemory / 1MB, 2)) Go"
                }
                Ecrire-Log -Action "Consultation_Systeme" -Cible $CIBLE; Pause
            }

            "3" {
                Clear-Host
                Write-Host "========================================================" -ForegroundColor Yellow
                Write-Host "          CONFIGURATION RESEAU"                           -ForegroundColor Yellow
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
                Write-Host $resultatNet -ForegroundColor Green
                Enregistrer-Infos -NomCible "RESEAU_$CIBLE" -Donnees $resultatNet
                Ecrire-Log -Action "Consultation_Reseau" -Cible $CIBLE; Pause
            }

            "4" {
                Clear-Host
                Write-Host "========================================================" -ForegroundColor Cyan
                Write-Host "              MAINTENANCE ET SECURITE " -ForegroundColor Yellow
                Write-Host "========================================================" -ForegroundColor Cyan
                Write-Host "1) Creer un repertoire"
                Write-Host "2) Supprimer un repertoire"
                Write-Host "3) Activer Pare-feu"
                Write-Host "4) Desactiver Pare-feu"
                Write-Host "5) Verifier l'etat des Pare-feu"
                Write-Host "6) Redemarrer la machine distante"
                Write-Host "--------------------------------------------------------"
                Write-Host "  0. Retour au menu principal"
                Write-Host "========================================================" -ForegroundColor Cyan

                $sub = Read-Host "`nAction (0 pour retour)"
                if ($sub -eq "0") { break }

                if ($sub -eq "6") {
                    Ecrire-Log -Action "REBOOT" -Cible $CIBLE
                    Restart-Computer -ComputerName $CIBLE -Credential $cred -Force
                    Write-Host "Redemarrage en cours..." -ForegroundColor Red; exit
                }

                $chemin = ""
                if ($sub -eq "1" -or $sub -eq "2") { $chemin = Read-Host "Entrez le chemin complet" }

                Invoke-Command -ComputerName $CIBLE -Credential $cred -ScriptBlock {
                    param($p, $opt)
                    try {
                        if($opt -eq "1"){ New-Item -Path $p -ItemType Directory -Force | Out-Null; return "Cree." }
                        elseif($opt -eq "2"){ Remove-Item -Path $p -Recurse -Force; return "Supprime." }
                        elseif($opt -eq "3"){ Set-NetFirewallProfile -All -Enabled True; return "Pare-feu ACTIVE." }
                        elseif($opt -eq "4"){ Set-NetFirewallProfile -All -Enabled False; return "Pare-feu DESACTIVE." }
                        elseif($opt -eq "5"){ return Get-NetFirewallProfile | Select Name, Enabled | Out-String }
                    } catch { return "Erreur : $($_.Exception.Message)" }
                } -ArgumentList $chemin, $sub | Write-Host -ForegroundColor Green

                Ecrire-Log -Action "Maint_$sub" -Cible $CIBLE; Pause
            }

            "5" {
                while ($true) {
                    Clear-Host
                    Write-Host "========================================================" -ForegroundColor Yellow
                    Write-Host "--- LOGS ET RAPPORTS EXPORTES ---" -ForegroundColor Yellow
                    Write-Host "========================================================" -ForegroundColor Yellow
                    Write-Host "  1. Rechercher dans log_evt.log"
                    Write-Host "  2. Lire un rapport du dossier /info"
                    Write-Host "--------------------------------------------------------"
                    Write-Host "  0. Retour au menu principal"
                    Write-Host "========================================================" -ForegroundColor Cyan
                    
                    $clog = Read-Host "`nChoix"
                    if ($clog -eq "0") { break }
                    if ($clog -eq "1") {
                        $s = Read-Host "Mot-cle"; 
                        if(Test-Path $LOG_FILE){ Get-Content $LOG_FILE | Select-String $s }
                    } elseif ($clog -eq "2") {
                        $inf = Join-Path $PSScriptRoot "info"
                        if(Test-Path $inf){ 
                            $files = Get-ChildItem $inf | Select-Object -ExpandProperty Name
                            Write-Host "Fichiers disponibles :`n$($files -join "`n")"
                            $f = Read-Host "`nNom du fichier"
                            if (Test-Path (Join-Path $inf $f)) { Get-Content (Join-Path $inf $f) }
                        }
                    }
                    Pause
                }
            }
        }
    }
}

# ==============================================================================
# 4. FONCTION : ADMINISTRATION LINUX (SSH)
# ==============================================================================
function Menu-AdminLinux {
    param($CIBLE)
    Write-Host "Connexion SSH vers Ubuntu ($CIBLE)..." -ForegroundColor Yellow
    ssh "wilder@$CIBLE"
}
