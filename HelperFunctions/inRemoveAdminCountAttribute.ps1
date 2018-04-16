function inRemoveAdminCountAttribute
{
    Param(
        [Parameter(Mandatory)]
        $AdminSDHolderProtectedAccount
    )

    $ADS_PROPERTY_CLEAR = 1

    $user = [ADSI]"LDAP://$($AdminSDHolderProtectedAccount.DistinguishedName)"   
    if ($user)
    {
        $user.PutEx($ADS_PROPERTY_CLEAR, 'adminCount', 0)
        $user.SetInfo()
    }

    Write-Output -InputObject "`nadminCount attribute removed."
}