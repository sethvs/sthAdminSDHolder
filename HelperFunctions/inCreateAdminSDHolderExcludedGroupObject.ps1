function inCreateAdminSDHolderExcludedGroupObject
{
    Param(
        [int]$flag
    )

    $hash = [ordered]@{
        Name = $dwAdminSDExMaskMap[$flag]
        SID = $AdminSDHolderProtectedGroups[$dwAdminSDExMaskMap[$flag]]
    }
    
    $Filter = "(&(objectCategory=group)(objectSID=$($hash.SID)))"
    $ADSISearcher.Filter = $Filter
    if ($Object = $ADSISearcher.FindOne())
    {
        $hash.Add('distinguishedName', $Object.Properties.Item('distinguishedName').Item(0))
    }
    else
    {
        $hash.Add('distinguishedName', $null)
    }
    
    New-Object -TypeName System.Management.Automation.PSObject -Property $hash
}