# .externalhelp sthAdminSDHolder.psm1-help.xml
function Enable-sthAdminSDHolderGroupProtection
{
Param(
    [switch]$AccountOperators,
    [switch]$ServerOperators,
    [switch]$PrintOperators,
    [switch]$BackupOperators,
    [switch]$Enable,
    [switch]$YesEnable
)
    $Confirmed = $Enable -and $YesEnable
    $Parameters = @{
        EnableAccountOperators = $AccountOperators
        EnableServerOperators = $ServerOperators
        EnablePrintOperators = $PrintOperators
        EnableBackupOperators = $BackupOperators
        Confirmed = $Confirmed
    }
    
    if (-not ($AccountOperators -or $ServerOperators -or $PrintOperators -or $BackupOperators))
    {
        Write-Output -InputObject "`nSpecify -AccountOperators, -ServerOperators, -PrintOperators or -BackupOperators parameters."
    }
    elseif (-not $Confirmed)
    {
        Write-Output -InputObject "`nWHATIF: To make changes, specify -Enable and -YesEnable parameters."
    }
    inChangeAdminSDHolderGroupProtection @Parameters
}