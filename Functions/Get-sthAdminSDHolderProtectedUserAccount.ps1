# .externalhelp ..\sthAdminSDHolder.psm1-help.xml
function Get-sthAdminSDHolderProtectedUserAccount
{
    [CmdletBinding(DefaultParameterSetName='default',PositionalBinding=$false)]
    Param(
        # Ambiguous Name Resolution
        [Parameter(ParameterSetName='ANR',Position=0)]
        [string]$ANR,
        # SamAccountName
        [Parameter(ParameterSetName='SamAccountName')]
        [string]$SamAccountName,
        # UserPrincipalName
        [Parameter(ParameterSetName='UserPrincipalName')]
        [string]$UserPrincipalName,
        [switch]$EnabledOnly
    )
    $RootDSE = New-Object -TypeName System.DirectoryServices.DirectoryEntry -ArgumentList "LDAP://RootDSE"
    $defaultNamingContext = "LDAP://$($RootDSE.Properties.Item('defaultNamingContext'))"
    
    $AdminSDHolderProtectedGroups = (Get-sthAdminSDHolderGroup -RootDSE $RootDSE).ProtectedGroups
    
    # Create ADSISearcher
    $ADSISearcher = New-Object -TypeName System.DirectoryServices.DirectorySearcher
    $ADSISearcher.SearchRoot = $defaultNamingContext
    
    # Find Users with AdminCount = 1 and not krbgtg
    $Filter = '(&(objectCategory=person)(adminCount=1)(!samAccountName=krbtgt)'

    if ($EnabledOnly)
    {
        $Filter += "(!userAccountControl:1.2.840.113556.1.4.803:=2)"
    }

    switch ($PSCmdlet.ParameterSetName)
    {
        'ANR'
        {
            $Filter += "(anr=$ANR))"
        }
        'SamAccountName'
        {
            $Filter += "(samaccountname=$SamAccountName))"
        }
        'UserPrincipalName'
        {
            $Filter += "(userprincipalname=$UserPrincipalName))"
        }
        'default'
        {
            $Filter += ')'
        }    
    }
    Write-Verbose -Message $Filter

    $ADSISearcher.Filter = $Filter
    $UsersWithAdminCountAttribute = $ADSISearcher.FindAll()

    if ($UsersWithAdminCountAttribute)
    {
        foreach ($user in $UsersWithAdminCountAttribute)
        {
            $SearchRoot = "LDAP://$($user.Properties.Item('distinguishedName')[0])"
            $ADSISearcher.SearchRoot = $SearchRoot

            $MemberOf = @()

            foreach ($group in $AdminSDHolderProtectedGroups)
            {
                $Filter = "(&(objectCategory=person)(Memberof:1.2.840.113556.1.4.1941:=$($group.distinguishedName)))"
                $ADSISearcher.Filter = $Filter
                
                if ($($ADSISearcher.FindAll()))
                {
                    $MemberOf += $group.Name
                }
            }
            $hash = [ordered]@{
                Name = $user.Properties.Item('Name')[0]
                SamAccountName = $user.Properties.Item('SamAccountName')[0]
                UserPrincipalName = $user.Properties.Item('UserPrincipalName')[0]
                Enabled = $(-not ($user.Properties.Item('UserAccountControl')[0] -band 2))
                AdminCountAttribute = 1
                InheritanceEnabled = -not (([ADSI]"LDAP://$($user.Properties.Item('distinguishedName')[0])").psbase.objectSecurity.AreAccessRulesProtected)
                AdminSDHolderGroups = @($MemberOf)
                DistinguishedName = $user.Properties.Item('DistinguishedName')[0]
            }
            $PSObject = New-Object -TypeName System.Management.Automation.PSObject -Property $hash | Add-Member -TypeName 'sth.AdminSDHolderProtectedUserAccount' -PassThru
            $PSObject
        }
    }
}