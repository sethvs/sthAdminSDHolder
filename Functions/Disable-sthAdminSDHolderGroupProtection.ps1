# .externalhelp ..\sthAdminSDHolder.psm1-help.xml
function Disable-sthAdminSDHolderGroupProtection
{
Param(
    [switch]$AccountOperators,
    [switch]$ServerOperators,
    [switch]$PrintOperators,
    [switch]$BackupOperators,
    [switch]$Disable,
    [switch]$YesDisable
)
    
    $Confirmed = $Disable -and $YesDisable
    $Parameters = @{
        DisableAccountOperators = $AccountOperators
        DisableServerOperators = $ServerOperators
        DisablePrintOperators = $PrintOperators
        DisableBackupOperators = $BackupOperators
        Confirmed = $Confirmed
    }
    
    if (-not ($AccountOperators -or $ServerOperators -or $PrintOperators -or $BackupOperators))
    {
        Write-Output -InputObject "`nSpecify -AccountOperators, -ServerOperators, -PrintOperators or -BackupOperators parameters."
    }
    elseif  (-not $Confirmed)
    {
        Write-Output -InputObject "`nWHATIF: To make changes, specify -Disable and -YesDisable parameters."
    }
    inChangeAdminSDHolderGroupProtection @Parameters
}