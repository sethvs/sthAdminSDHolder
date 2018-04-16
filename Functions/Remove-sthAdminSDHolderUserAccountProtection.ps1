# .externalhelp sthAdminSDHolder.psm1-help.xml
function Remove-sthAdminSDHolderUserAccountProtection
{
    [CmdletBinding(DefaultParameterSetName='default')]
    Param(
        [Parameter(ParameterSetName='SamAccountName')]
        [string]$SamAccountName,
        [Parameter(ParameterSetName='UserPrincipalName')]
        [string]$UserPrincipalName,
        [switch]$Remove,
        [switch]$YesRemove
    )

    switch ($PSCmdlet.ParameterSetName)
    {
        'SamAccountName'
        {
            $Parameters = @{SamAccountName = $SamAccountName}
        }
        'UserPrincipalName'
        {
            $Parameters = @{UserPrincipalName = $UserPrincipalName}
        }
        'default'
        {
            return "`nSpecify -SamAccountName or -UserPrincipalName parameters.`n"
        }
    }

    if ($AdminSDHolderProtectedAccount = $(Get-sthAdminSDHolderProtectedUserAccount @Parameters))
    {
        if ($AdminSDHolderProtectedAccount.AdminSDHolderGroups)
        {
            Write-Output -InputObject "`nAccount is a member of AdminSDHolder protected groups."
            $AdminSDHolderProtectedAccount
            Write-Output -InputObject "`nNo changes were made."
        }
        else
        {
            if ($Remove -and $YesRemove)
            {
                if ($AdminSDHolderProtectedAccount.AdminCountAttribute -and -not $AdminSDHolderProtectedAccount.InheritanceEnabled)
                {
                    Write-Output -InputObject "`nRemoving adminCount attribute and enabling access rules inheritance."
                    $AdminSDHolderProtectedAccount
                    inRemoveAdminCountAttribute -AdminSDHolderProtectedAccount $AdminSDHolderProtectedAccount
                    inEnableAccessRulesInheritance -AdminSDHolderProtectedAccount $AdminSDHolderProtectedAccount
                }
                elseif ($AdminSDHolderProtectedAccount.AdminCountAttribute)
                {
                    Write-Output -InputObject "`nRemoving adminCount attribute."
                    $AdminSDHolderProtectedAccount
                    inRemoveAdminCountAttribute -AdminSDHolderProtectedAccount $AdminSDHolderProtectedAccount
                }
            }
            else 
            {
                Write-Output -InputObject "`nWHATIF: To remove adminCount attribute and restore access rules inheritance, specify -Remove and -YesRemove parameters."
                $AdminSDHolderProtectedAccount
                # Write-Output -InputObject "`n`nTo remove adminCount attribute and restore access rules inheritance specify -Remove and -YesRemove parameters.`nNo changes were made."
                Write-Output -InputObject "`nWHATIF: No changes were made."
            }
        }
    }
    else
    {
        Write-Output -InputObject "`nAccount $SamAccountName$UserPrincipalName not found.`n"
    }
}