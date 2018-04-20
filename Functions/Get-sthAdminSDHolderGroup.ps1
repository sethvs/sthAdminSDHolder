# .externalhelp ..\sthAdminSDHolder.psm1-help.xml
function Get-sthAdminSDHolderGroup
{
    Param(
        [System.DirectoryServices.DirectoryEntry]$RootDSE = $(New-Object -TypeName System.DirectoryServices.DirectoryEntry -ArgumentList "LDAP://RootDSE")
    )

    $defaultNamingContext = $RootDSE.Properties.Item('defaultNamingContext')
    $configurationNamingContext = $RootDSE.Properties.Item('configurationNamingContext')
    
    $DirectoryService = New-Object -TypeName System.DirectoryServices.DirectoryEntry -ArgumentList "LDAP://CN=Directory Service,CN=Windows NT,CN=Services,$configurationNamingContext"

    $Domain = New-Object -TypeName System.DirectoryServices.DirectoryEntry -ArgumentList "LDAP://$defaultnamingContext"
    $DomainSID = inConvertToSID -ByteArray $Domain.Properties.Item('objectSID')
    
    $ADSISearcher = New-Object -TypeName System.DirectoryServices.DirectorySearcher
    $ADSISearcher.SearchRoot = "LDAP://$defaultNamingContext"

    $AdminSDHolderProtectedGroups = [ordered]@{
        'Account Operators' = 'S-1-5-32-548'
        # Administrator
        'Administrators' = 'S-1-5-32-544'
        'Backup Operators' = 'S-1-5-32-551'
        'Domain Admins' = $DomainSID + '-512'
        'Domain Controllers' = $DomainSID + '-516'
        'Enterprise Admins' = $DomainSID + '-519'
        # Krbtgt
        'Print Operators' = 'S-1-5-32-550'
        'Read-only Domain Controllers' = $DomainSID + '-521'
        'Replicator'  = 'S-1-5-32-552'
        'Schema Admins' = $DomainSID + '-518'
        'Server Operators' = 'S-1-5-32-549'
    }

    $dwAdminSDExMaskMap = @{
        1 = 'Account Operators'
        2 = 'Server Operators'
        4 = 'Print Operators'
        8 = 'Backup Operators'
    }
    
    $dsHeuristics = $DirectoryService.Properties.Item('dsHeuristics').Value

    if ($dsHeuristics)
    {
        if ($dsHeuristics.Length -ge 16)
        {
            $dwAdminSDExMask = [convert]::ToInt32($dsHeuristics.Substring(15,1),16)
            
            $ExcludedGroups = switch ($dwAdminSDExMask)
            {
                {$_ -band 1}
                {
                    inCreateAdminSDHolderExcludedGroupObject -flag 1
                    $AdminSDHolderProtectedGroups.Remove($dwAdminSDExMaskMap[1])
                }
                
                {$_ -band 2}
                {
                    inCreateAdminSDHolderExcludedGroupObject -flag 2
                    $AdminSDHolderProtectedGroups.Remove($dwAdminSDExMaskMap[2])
                }
                
                {$_ -band 4}
                {
                    inCreateAdminSDHolderExcludedGroupObject -flag 4
                    $AdminSDHolderProtectedGroups.Remove($dwAdminSDExMaskMap[4])
                }
                
                {$_ -band 8}
                {
                    inCreateAdminSDHolderExcludedGroupObject -flag 8
                    $AdminSDHolderProtectedGroups.Remove($dwAdminSDExMaskMap[8])
                }
            }
        }
    }
    else
    {
        $dsHeuristics = 'null'
    }

    $ProtectedGroups = foreach ($i in $AdminSDHolderProtectedGroups.GetEnumerator())
    {
        $Filter = "(&(objectCategory=group)(objectSID=$($i.Value)))"
        $ADSISearcher.Filter = $Filter
        if ($Object = $ADSISearcher.FindOne())
        {
            $distinguishedName = $Object.Properties.Item('distinguishedName')
            
            $hash = [ordered]@{
                Name = $i.Key
                SID = $i.Value
                distinguishedName = $distinguishedName[0]
            }
            
            New-Object -TypeName System.Management.Automation.PSObject -Property $hash
        }
    }

    $NonExistentGroups = foreach ($group in $AdminSDHolderProtectedGroups.GetEnumerator())
    {
        if ($group.Name -notin $ProtectedGroups.Name)
        {
            $hash = [ordered]@{
                Name = $group.Name
                SID = $group.Value
                distinguishedName = $null
            }

            New-Object -TypeName System.Management.Automation.PSObject -Property $hash
         }
    } 

    $hash = [ordered]@{
        dsHeuristics = $dsHeuristics
        ProtectedGroups = @($ProtectedGroups)
        ExcludedGroups = @($ExcludedGroups)
        NonExistentGroups = @($NonExistentGroups)
    }

    $Return = New-Object -TypeName System.Management.Automation.PSObject -Property $hash
    
    if ($Return.ExcludedGroups)
    {
        $Return | Add-Member -TypeName 'sth.AdminSDHolderGroups#ExcludedGroups' -PassThru
    }
    else
    {
        $Return | Add-Member -TypeName 'sth.AdminSDHolderGroups' -PassThru
    }
}