# ============================================================= -ForegroundColor Green
#                STATION DE CONTROLE - SRVWIN01                        -ForegroundColor Green
# ============================================================= -ForegroundColor Green

# Chemin complet vers tes scripts sur ton SERVEUR
$PathWin = "C:\Users\Administrator\Documents\TSSR-0226-P2-G2\admin_windows.ps1"
$PathLin = "C:\Users\Administrator\Documents\TSSR-0226-P2-G2\admin_debian.sh"

function Lancer-Push {
    param([string]$IP, [string]$User, [string]$Type)
    Write-Host "`n[SSH] Envoi du script vers $IP..." -ForegroundColor Cyan
    
    if ($Type -eq "win") {
        if (Test-Path $PathWin) {
            # On lit le script local et on l'injecte dans le PowerShell distant
            Get-Content $PathWin | ssh "$User@$IP" "powershell -ExecutionPolicy Bypass -Command -"
        } else {
            Write-Host "Erreur : $PathWin introuvable sur le serveur." -ForegroundColor Red
        }
    } else {
        if (Test-Path $PathLin) {
            Get-Content $PathLin | ssh "$User@$IP" "bash -s"
        } else {
            Write-Host "Erreur : $PathLin introuvable sur le serveur." -ForegroundColor Red
        }
    }
}

while ($true) {
    Clear-Host
    Write-Host "====================================================" -ForegroundColor Green
    Write-Host "       MENU DE CONTROLE SYSTEME (SRVWIN01)" -ForegroundColor Green
    Write-Host "====================================================" -ForegroundColor Green
    Write-Host "  1- Piloter Client Ubuntu (172.16.20.30)"
    Write-Host "  2- Piloter Client Windows 11 (172.16.20.20)"
    Write-Host "  0- Quitter"
    
    $choix = Read-Host "Selectionnez une option"
    if ($choix -eq "0") { break }

    switch ($choix) {
        "1" { Lancer-Push -IP "172.16.20.30" -User "root" -Type "lin" }
  
	# ... (Tes autres options de menu)
	"2" {
    # On définit le chemin vers l'autre script dans le même dossier
    $cheminAdmin = Join-Path $PSScriptRoot "admin_windows.ps1"
    
    if (Test-Path $cheminAdmin) {
        Write-Host "Ouverture de l'administration distante..." -ForegroundColor Yellow
        # Lancement avec les bonnes politiques
        powershell.exe -ExecutionPolicy Bypass -File $cheminAdmin
    } else {
        Write-Host "Erreur : Le fichier $cheminAdmin est introuvable !" -ForegroundColor Red
        Pause
    }
}
	"3" {
   		 Write-Host "Operation terminee." -ForegroundColor Gray
    		Read-Host "Appuyez sur Entree pour continuer..."
		}
	}
}
