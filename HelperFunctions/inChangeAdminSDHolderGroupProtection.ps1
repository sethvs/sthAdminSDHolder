function inChangeAdminSDHolderGroupProtection
{
    Param(
        [switch]$EnableAccountOperators,
        [switch]$EnableServerOperators,
        [switch]$EnablePrintOperators,
        [switch]$EnableBackupOperators,
        [switch]$DisableAccountOperators,
        [switch]$DisableServerOperators,
        [switch]$DisablePrintOperators,
        [switch]$DisableBackupOperators,
        [switch]$Confirmed
    )

    $RootDSE = New-Object -TypeName System.DirectoryServices.DirectoryEntry -ArgumentList "LDAP://RootDSE"
    $configurationNamingContext = $RootDSE.Properties.Item('configurationNamingContext')
    $DirectoryService = New-Object -TypeName System.DirectoryServices.DirectoryEntry -ArgumentList "LDAP://CN=Directory Service,CN=Windows NT,CN=Services,$configurationNamingContext"
    $dsHeuristics = $DirectoryService.Properties.Item('dsHeuristics').Value

    $Changed = $false

    if ($dsHeuristics)
    {
        Write-Output -InputObject "`nCurrent dsHeuristics value: $dsHeuristics`n"
        
        if ($dsHeuristics.Length -lt 16)
        {
            $dsHeuristics += '0000000001000000'.Substring($dsHeuristics.Length)
        }
    }
    else
    {
        Write-Output -InputObject "`nCurrent dsHeuristics value: null`n"
        $dsHeuristics = '0000000001000000'
    }

    $bitMask = [convert]::ToInt32($dsHeuristics.Substring(15,1),16)

    switch ($true)
    {
        $DisableAccountOperators
        {
            if (-not ($bitMask -band 1))
            {
                $bitMask = $bitMask -bor 1
                Write-Output -InputObject "DISABLED: Account Operators"
            }
            else
            {
                Write-Output 'Account Operators group protection already disabled.'
            }
        }

    $DisableServerOperators
    {
        if (-not ($bitMask -band 2))
        {
            $bitMask = $bitMask -bor 2
            Write-Output -InputObject "DISABLED: Server Operators"
        }
        else
        {
            Write-Output 'Server Operators group protection already disabled.'
        }
    }

    $DisablePrintOperators
    {
        if (-not ($bitMask -band 4))
        {
            $bitMask = $bitMask -bor 4
            Write-Output -InputObject "DISABLED: Print Operators"
        }
        else
        {
            Write-Output 'Print Operators group protection already disabled.'
        }    
    }

    $DisableBackupOperators
    {
        if (-not ($bitMask -band 8))
        {
            $bitMask = $bitMask -bor 8
            Write-Output -InputObject "DISABLED: Backup Operators"
        }
        else
        {
            Write-Output 'Backup Operators group protection already disabled.'
        }    
    }

    $EnableAccountOperators
    {
        if ($bitMask -band 1)
        {
            $bitMask = $bitMask -band (-bnot 1)
            Write-Output -InputObject "ENABLED: Account Operators"
        }
        else
        {
            Write-Output 'Account Operators group protection already enabled.'
        }
    }

    $EnableServerOperators
    {
        if ($bitMask -band 2)
        {
            $bitMask = $bitMask -band (-bnot 2)
            Write-Output -InputObject "ENABLED: Server Operators"
        }
        else
        {
            Write-Output 'Server Operators group protection already enabled.'
        }    
    }

    $EnablePrintOperators
    {
        if ($bitMask -band 4)
        {
            $bitMask = $bitMask -band (-bnot 4)
            Write-Output -InputObject "ENABLED: Print Operators"
        }
        else
        {
            Write-Output 'Print Operators group protection already enabled.'
        }  
    }
    
    $EnableBackupOperators
    {
        if ($bitMask -band 8)
        {
            $bitMask = $bitMask -band (-bnot 8)
            Write-Output -InputObject "ENABLED: Backup Operators"
        }
        else
        {
            Write-Output 'Backup Operators group protection already enabled.'
        }      
    }

    default
    {
        Write-Output -InputObject "No changes were made.`n"
        return
    }
}

    if ($bitMask -ne [convert]::ToInt32($dsHeuristics.Substring(15,1),16))
    {
        $Changed = $true
        $dsHeuristics = $dsHeuristics.Substring(0,15) + [convert]::ToString($bitMask,16) + $dsHeuristics.Substring(16)
    }
 
    if ($Changed)
    {
        Write-Output -InputObject "`nResulting dsHeuristics value: $dsHeuristics`n"
        if ($Confirmed)
        {
            $DirectoryService.Put('dsHeuristics', $dsHeuristics)
            $DirectoryService.SetInfo()
        }
        else
        {
            Write-Output -InputObject "WHATIF: No changes were made.`n"
        }
    }
    else
    {
        if ($Confirmed)
        {
            Write-Output -InputObject "`nNo changes were made.`n"
        }
        else
        {
            Write-Output -InputObject "`nWHATIF: No changes were made.`n"
        }
    }
}