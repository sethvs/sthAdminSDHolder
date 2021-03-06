# sthAdminSDHolder

**sthAdminSDHolder** - it is a module containing five functions for work with Active Directory groups and user accounts, protected by AdminSDHolder container.

When you add user to one of the protected groups, like 'Account Operators', 'Administrators', 'Backup Operators',
'Domain Admins', 'Domain Controllers', 'Enterprise Admins', 'Print Operators', 'Read-only Domain Controllers', 'Replicator',
'Schema Admins' or 'Server Operators', it becomes protected too.

User account object's attribute adminCount is set to '1' and access rights become that of the AdminSDHolder container
(CN=AdminSDHolder,CN=System,DC=domain,DC=com).

By default, access rights inheritance for AdminSDHolder is disabled. And so it is for protected user objects.

When you remove user from protected group, adminCount attribute is not removed and its value is not changed. 
Also, permissions inheritance for the object is not enabled.
To remove adminCount attribute and enable access rights inheritance you can use this module's functions:
Get-sthAdminSDHolderProtectedUserAccount and Remove-sthAdminSDHolderUserAccountProtection.

Also, you can exclude 'Account Operators', 'Server Operators', 'Print Operators' or 'Backup Operators' groups from protection (and include again)
by adjusting dsHeuristics attribute of 'Directory Service' container (CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration,DC=domain,DC=com).

You can do this using functions:
Get-sthAdminSDHolderGroup, Disable-sthAdminSDHolderGroupProtection, Enable-sthAdminSDHolderGroupProtection.

## Module contains following functions:

[**Get-sthAdminSDHolderProtectedUserAccount**](#get-sthadminsdholderprotecteduseraccount) - Function gets Active Directory user accounts, protected by AdminSDHolder.
It returns Name, SamAccountName, UserPrincipalName, whether account is enabled, adminCount attribute value, whether access rights inheritance is enabled and list of protected groups the user is member of.

[**Remove-sthAdminSDHolderUserAccountProtection**](#remove-sthadminsdholderuseraccountprotection) - Function removes adminCount attribute and enables access rules inheritance for the user object, that no longer belongs to groups, protected by AdminSDHolder container.

[**Get-sthAdminSDHolderGroup**](#get-sthadminsdholdergroup) - Function gets the Active Directory groups, protected by AdminSDHolder container.
It returns dsHeuristics attribute value, protected groups, and also groups, excluded from protection, if any.

[**Disable-sthAdminSDHolderGroupProtection**](#disable-sthadminsdholdergroupprotection) - Function disables protection by AdminSDHolder container for Account Operators, Server Operators, Print Operators or Backup Operators groups.

[**Enable-sthAdminSDHolderGroupProtection**](#enable-sthadminsdholdergroupprotection) - Function enables protection by AdminSDHolder container for Account Operators, Server Operators, Print Operators or Backup Operators groups.

You can install sthAdminSDHolder module from PowerShell Gallery:

```powershell
Install-Module sthAdminSDHolder
```

## How to use it?

### Get-sthAdminSDHolderProtectedUserAccount

The command returns information about user accounts, protected by AdminSDHolder container.
Output includes disabled user accounts.

```powershell
Get-sthAdminSDHolderProtectedUserAccount
```

```text

Name         SamAccountName UserPrincipalName       Enabled AdminCountAttribute InheritanceEnabled AdminSDHolderGroups
----         -------------- -----------------       ------- ------------------- ------------------ -------------------
admin        admin          admin@domain.com        True    1                   False              {Administrators, Domain Admins, Enterprise Admins, Schema Admins}
user         user           user@domain.com         True    1                   False              {Account Operators}
disableduser disableduser   disableduser@domain.com False   1                   False              {Print Operators}
```

---

The command returns information about user accounts, protected by AdminSDHolder container.
Output includes only enabled user accounts.

```powershell
Get-sthAdminSDHolderProtectedUserAccount -EnabledOnly
```

```text
Name  SamAccountName UserPrincipalName Enabled AdminCountAttribute InheritanceEnabled AdminSDHolderGroups
----  -------------- ----------------- ------- ------------------- ------------------ -------------------
admin admin          admin@domain.com  True    1                   False              {Administrators, Domain Admins, Enterprise Admins, Schema Admins}
user  user           user@domain.com   True    1                   False              {Account Operators}
```

---

The command returns information about user accounts, protected by AdminSDHolder container,
using ambiguous name resolution.

```powershell
Get-sthAdminSDHolderProtectedUserAccount -ANR u
```

```text
Name SamAccountName UserPrincipalName Enabled AdminCountAttribute InheritanceEnabled AdminSDHolderGroups
---- -------------- ----------------- ------- ------------------- ------------------ -------------------
user user           user@domain.com   True    1                   False              {Account Operators}
```

---

The command returns information about user account, protected by AdminSDHolder container,
using SamAccountName user object attribute.

```powershell
Get-sthAdminSDHolderProtectedUserAccount -SamAccountName user
```

```text
Name SamAccountName UserPrincipalName Enabled AdminCountAttribute InheritanceEnabled AdminSDHolderGroups
---- -------------- ----------------- ------- ------------------- ------------------ -------------------
user user           user@domain.com   True    1                   False              {Account Operators}
```

---

The command returns information about user account, protected by AdminSDHolder container,
using UserPrincipalName user object attribute.

```powershell
Get-sthAdminSDHolderProtectedUserAccount -UserPrincipalName user@domain.com
```

```text
Name SamAccountName UserPrincipalName Enabled AdminCountAttribute InheritanceEnabled AdminSDHolderGroups
---- -------------- ----------------- ------- ------------------- ------------------ -------------------
user user           user@domain.com   True    1                   False              {Account Operators}
```

### Remove-sthAdminSDHolderUserAccountProtection

The command removes adminCount attribute and enables access rules inheritance for the user account.
The account was specified by using its SamAccountName.

```powershell
Remove-sthAdminSDHolderUserAccountProtection -SamAccountName user -Remove -YesRemove
```

```text
Removing adminCount attribute and enabling access rules inheritance.

Name SamAccountName UserPrincipalName Enabled AdminCountAttribute InheritanceEnabled AdminSDHolderGroups
---- -------------- ----------------- ------- ------------------- ------------------ -------------------
user user           user@domain.com   True    1                   False              {}

adminCount attribute removed.
Access rules inheritance enabled.
```

---

The command removes adminCount attribute and enables access rules inheritance for the user account.
The account was specified by using its UserPrincipalName.

```powershell
Remove-sthAdminSDHolderUserAccountProtection -UserPrincipalName user@domain.com -Remove -YesRemove
```

```text
Removing adminCount attribute and enabling access rules inheritance.

Name SamAccountName UserPrincipalName Enabled AdminCountAttribute InheritanceEnabled AdminSDHolderGroups
---- -------------- ----------------- ------- ------------------- ------------------ -------------------
user user           user@domain.com   True    1                   False              {}

adminCount attribute removed.
Access rules inheritance enabled.
```

---

The command does not make changes to user account, because it still is a member of a protected group.

```powershell
Remove-sthAdminSDHolderUserAccountProtection -SamAccountName username -Remove -YesRemove
```

```text
Account is a member of AdminSDHolder protected groups.

Name SamAccountName UserPrincipalName Enabled AdminCountAttribute InheritanceEnabled AdminSDHolderGroups
---- -------------- ----------------- ------- ------------------- ------------------ -------------------
user user           user@domain.com   True    1                   False              {Account Operators}

No changes were made.
```

### Get-sthAdminSDHolderGroup

The command gets the value of dsHeuristics attribute and a list of groups, protected by AdminSDHolder container.

```powershell
Get-sthAdminSDHolderGroup
```

```text
    dsHeuristics: null

    Protected Groups:

Name                         SID                                           distinguishedName
----                         ---                                           -----------------
Account Operators            S-1-5-32-548                                  CN=Account Operators,CN=Builtin,DC=domain,DC=com
Administrators               S-1-5-32-544                                  CN=Administrators,CN=Builtin,DC=domain,DC=com
Backup Operators             S-1-5-32-551                                  CN=Backup Operators,CN=Builtin,DC=domain,DC=com
Domain Admins                S-1-5-21-1234567890-1234567890-1234567890-512 CN=Domain Admins,CN=Users,DC=domain,DC=com
Domain Controllers           S-1-5-21-1234567890-1234567890-1234567890-516 CN=Domain Controllers,CN=Users,DC=domain,DC=com
Enterprise Admins            S-1-5-21-1234567890-1234567890-1234567890-519 CN=Enterprise Admins,CN=Users,DC=domain,DC=com
Print Operators              S-1-5-32-550                                  CN=Print Operators,CN=Builtin,DC=domain,DC=com
Read-only Domain Controllers S-1-5-21-1234567890-1234567890-1234567890-521 CN=Read-only Domain Controllers,CN=Users,DC=domain,DC=com
Replicator                   S-1-5-32-552                                  CN=Replicator,CN=Builtin,DC=domain,DC=com
Schema Admins                S-1-5-21-1234567890-1234567890-1234567890-518 CN=Schema Admins,CN=Users,DC=domain,DC=com
Server Operators             S-1-5-32-549                                  CN=Server Operators,CN=Builtin,DC=domain,DC=com
```

---

The command gets the value of dsHeuristics attribute and a list of groups protected by AdminSDHolder container.
Also function returns the list of groups, excluded from protection by virtue of 16'th character's value of dsHeuristics attribute.

```powershell
Get-sthAdminSDHolderGroup
```

```text
    dsHeuristics: 000000000100000f

    Protected Groups:

Name                         SID                                           distinguishedName
----                         ---                                           -----------------
Administrators               S-1-5-32-544                                  CN=Administrators,CN=Builtin,DC=domain,DC=com
Domain Admins                S-1-5-21-1234567890-1234567890-1234567890-512 CN=Domain Admins,CN=Users,DC=domain,DC=com
Domain Controllers           S-1-5-21-1234567890-1234567890-1234567890-516 CN=Domain Controllers,CN=Users,DC=domain,DC=com
Enterprise Admins            S-1-5-21-1234567890-1234567890-1234567890-519 CN=Enterprise Admins,CN=Users,DC=domain,DC=com
Read-only Domain Controllers S-1-5-21-1234567890-1234567890-1234567890-521 CN=Read-only Domain Controllers,CN=Users,DC=domain,DC=com
Replicator                   S-1-5-32-552                                  CN=Replicator,CN=Builtin,DC=domain,DC=com
Schema Admins                S-1-5-21-1234567890-1234567890-1234567890-518 CN=Schema Admins,CN=Users,DC=domain,DC=com



    Excluded Groups:

Name                         SID                                           distinguishedName
----                         ---                                           -----------------
Account Operators            S-1-5-32-548                                  CN=Account Operators,CN=Builtin,DC=domain,DC=com
Server Operators             S-1-5-32-549                                  CN=Server Operators,CN=Builtin,DC=domain,DC=com
Print Operators              S-1-5-32-550                                  CN=Print Operators,CN=Builtin,DC=domain,DC=com
Backup Operators             S-1-5-32-551                                  CN=Backup Operators,CN=Builtin,DC=domain,DC=com
```

### Disable-sthAdminSDHolderGroupProtection

The command disables protection by AdminSDHolder container for Account Operators group.

```powershell
Disable-sthAdminSDHolderGroupProtection -AccountOperators -Disable -YesDisable
```

```text
Current dsHeuristics value: null

DISABLED: Account Operators

Resulting dsHeuristics value: 0000000001000001
```

---

The command disables protection by AdminSDHolder container for Account Operators, Server Operators, 
Print Operators and Backup Operators groups.

```powershell
Disable-sthAdminSDHolderGroupProtection -AccountOperators -ServerOperators -PrintOperators -BackupOperators -Disable -YesDisable
```

```text
Current dsHeuristics value: null

DISABLED: Account Operators
DISABLED: Server Operators
DISABLED: Print Operators
DISABLED: Backup Operators

Resulting dsHeuristics value: 000000000100000f
```

### Enable-sthAdminSDHolderGroupProtection

The command enables protection by AdminSDHolder container for Account Operators group.

```powershell
Enable-sthAdminSDHolderGroupProtection -AccountOperators -Enable -YesEnable
```

```text
Current dsHeuristics value: 000000000100000f

ENABLED: Account Operators

Resulting dsHeuristics value: 000000000100000e
```

---

The command enables protection by AdminSDHolder container for Account Operators, Server Operators, 
Print Operators and Backup Operators groups.

```powershell
Enable-sthAdminSDHolderGroupProtection -AccountOperators -ServerOperators -PrintOperators -BackupOperators -Enable -YesEnable
```

```text
Current dsHeuristics value: 000000000100000f

ENABLED: Account Operators
ENABLED: Server Operators
ENABLED: Print Operators
ENABLED: Backup Operators

Resulting dsHeuristics value: 0000000001000000
```