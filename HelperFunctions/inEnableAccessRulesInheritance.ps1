function inEnableAccessRulesInheritance
{
    Param(
        [Parameter(Mandatory)]
        $AdminSDHolderProtectedAccount
    )

    $user = [ADSI]"LDAP://$($AdminSDHolderProtectedAccount.DistinguishedName)"
    if ($user.psbase.objectSecurity.AreAccessRulesProtected)
    {
        $isProtected = $false
        $preserveInheritance = $true
        $user.psbase.ObjectSecurity.SetAccessRuleProtection($isProtected, $preserveInheritance)
        $user.psbase.CommitChanges()
    }

    Write-Output -InputObject "Access rules inheritance enabled."
}

