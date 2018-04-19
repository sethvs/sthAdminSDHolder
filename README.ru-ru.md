# sthAdminSDHolder

**sthAdminSDHolder** - модуль, содержащий пять функций для работы с группами и пользовательскими учетными записями Active Directory,
защищенными контейнером AdminSDHolder.

Когда вы добавляете пользователя в одну из защищенных групп, таких как: 'Account Operators', 'Administrators', 'Backup Operators',
'Domain Admins', 'Domain Controllers', 'Enterprise Admins', 'Print Operators', 'Read-only Domain Controllers', 'Replicator',
'Schema Admins' or 'Server Operators', он также становится защищенным.

Атрибут adminCount объекта пользователя устанавливается в значение '1', а права доступа к объекту устанавливаются в соответствии с правами доступа к контейнеру AdminSDHolder (CN=AdminSDHolder,CN=System,DC=domain,DC=com).

По умолчанию, наследование прав доступа для контейнера AdminSDHolder отключено. То же самое касается и защищенных объектов пользователей.

Когда вы удалаете пользователя из защищенной группы, атрибут adminCount не удаляется и его значение не изменяется.
Наследование прав доступа к объекту также не восстанавливается.
Для удаления атрибута adminCount и восстановления наследования прав доступа вы можете использовать функции модуля:
Get-sthAdminSDHolderProtectedUserAccount и Remove-sthAdminSDHolderUserAccountProtection.

Кроме того, вы можете исключить группы 'Account Operators', 'Server Operators', 'Print Operators' или 'Backup Operators' из числа защищенных контейнером AdminSDHolder (или же вернуть их под защиту), изменив значение атрибута dsHeuristics контейнера 'Directory Service' (CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration,DC=domain,DC=com).

Сделать это вы можете при помощи функций: Get-sthAdminSDHolderGroup, Disable-sthAdminSDHolderGroupProtection, Enable-sthAdminSDHolderGroupProtection.

## В модуль входят следующие функции:

[**Get-sthAdminSDHolderProtectedUserAccount**](#get-sthadminsdholderprotecteduseraccount) - Функция отображает учетные записи пользователей Active Directory, защищенные контейнером AdminSDHolder.
Результат выполнения включает в себя имя пользователя, значения атрибутов SamAccountName и UserPrincipalName,
активна ли учетная запись, значение атрибута adminCount, включено ли наследование прав досупа,
а также список защищенных групп, в которые входит пользователь.

[**Remove-sthAdminSDHolderUserAccountProtection**](#remove-sthadminsdholderuseraccountprotection) - Функция удаляет атрибут adminCount и восстанавливает наследование прав доступа для объекта пользователя, если он не входит в группы Active Directory, защищенные контейнером AdminSDHolder.

[**Get-sthAdminSDHolderGroup**](#get-sthadminsdholdergroup) - Функция отображает группы Active Directory, защищенные контейнером AdminSDHolder.
В качестве результатов выводится текущее значение атрибута dsHeuristics, защищенные группы, а также группы, исключенные из списка защищенных, если такие существуют.

[**Disable-sthAdminSDHolderGroupProtection**](#disable-sthadminsdholdergroupprotection) - Функция позволяет исключить группы Account Operators, Server Operators, Print Operators и Backup Operators из числа защищенных контейнером AdminSDHolder.

[**Enable-sthAdminSDHolderGroupProtection**](#enable-sthadminsdholdergroupprotection) - Функция позволяет включить группы Account Operators, Server Operators, Print Operators и Backup Operators в число защищенных контейнером AdminSDHolder.

Вы можете установить модуль sthAdminSDHolder из PowerShell Gallery:

```powershell
Install-Module sthAdminSDHolder
```

## Как с этим работать?

### Get-sthAdminSDHolderProtectedUserAccount

Команда выводит информацию об учетных записях пользователей, защищенных контейнером AdminSDHolder.
Реультат выполнения содежит деактивированные учетные записи.

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

Команда выводит информацию об учетных записях пользователей, защищенных контейнером AdminSDHolder.
Реультат выполнения содежит только активные учетные записи.

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

Команда выводит информацию об учетных записях пользователей, защищенных контейнером AdminSDHolder, с использованием ANR - Ambiguous Name Resolution.

```powershell
Get-sthAdminSDHolderProtectedUserAccount -ANR u
```

```text
Name SamAccountName UserPrincipalName Enabled AdminCountAttribute InheritanceEnabled AdminSDHolderGroups
---- -------------- ----------------- ------- ------------------- ------------------ -------------------
user user           user@domain.com   True    1                   False              {Account Operators}
```

---

Команда выводит информацию об учетных записях пользователей, защищенных контейнером AdminSDHolder, с использованием поиска по атрибуту SamAccountName.

```powershell
Get-sthAdminSDHolderProtectedUserAccount -SamAccountName user
```

```text
Name SamAccountName UserPrincipalName Enabled AdminCountAttribute InheritanceEnabled AdminSDHolderGroups
---- -------------- ----------------- ------- ------------------- ------------------ -------------------
user user           user@domain.com   True    1                   False              {Account Operators}
```

---

Команда выводит информацию об учетных записях пользователей, защищенных контейнером AdminSDHolder, с использованием поиска по атрибуту UserPrincipalName.

```powershell
Get-sthAdminSDHolderProtectedUserAccount -UserPrincipalName user@domain.com
```

```text
Name SamAccountName UserPrincipalName Enabled AdminCountAttribute InheritanceEnabled AdminSDHolderGroups
---- -------------- ----------------- ------- ------------------- ------------------ -------------------
user user           user@domain.com   True    1                   False              {Account Operators}
```

### Remove-sthAdminSDHolderUserAccountProtection

Команда удаляет атрибут adminCount и восстанавливает наследование прав доступа для объекта пользователя.
Учетная запись определятеся значением атрибута SamAccountName.

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

Команда удаляет атрибут adminCount и восстанавливает наследование прав доступа для объекта пользователя.
Учетная запись определятеся значением атрибута UserPrincipalName.

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

Команда не вносит изменений, поскольку пользователь все еще входит в защищенные контейнером AdminSDHolder группы.

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

Команда выводит значение атрибута dsHeuristics и список групп, защищенных контейнером AdminSDHolder.

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

Команда выводит значение атрибута dsHeuristics, список групп, защищенных контейнером AdminSDHolder, а также список групп, исключенных из списка защищенных, что определяется значением 16-го символа атрибута dsHeuristics.

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

Команда исключает группу Account Operators из числа защищенных контейнером AdminSDHolder.

```powershell
Disable-sthAdminSDHolderGroupProtection -AccountOperators -Disable -YesDisable
```

```text
Current dsHeuristics value: null

DISABLED: Account Operators

Resulting dsHeuristics value: 0000000001000001
```

---

Команда исключает группы Account Operators, Server Operators,  Print Operators и Backup Operators из числа защищенных контейнером AdminSDHolder.

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

Команда включает группу Account Operators в число защищенных контейнером AdminSDHolder.

```powershell
Enable-sthAdminSDHolderGroupProtection -AccountOperators -Enable -YesEnable
```

```text
Current dsHeuristics value: 000000000100000f

ENABLED: Account Operators

Resulting dsHeuristics value: 000000000100000e
```

---

Команда включает группы Account Operators, Server Operators, Print Operators и Backup Operators в число защищенных контейнером AdminSDHolder.

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