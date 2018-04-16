# sthAdminSDHolder

**sthAdminSDHolder** - it is a module containing five functions for working with Active Directory groups and user accounts, protected by AdminSDHolder container.

It contains following functions:

**Get-sthAdminSDHolderProtectedUserAccount** - Function gets Active Directory user accounts, protected by AdminSDHolder.
It returns Name, SamAccountName, UserPrincipalName, whether account is enabled, adminCount attribute value, whether access rights inheritance is enabled and list of protected groups the user is member of.

**Remove-sthAdminSDHolderUserAccountProtection** - Function removes adminCount attribute and enables access rules inheritance for the user object, that no longer belongs to groups, protected by AdminSDHolder container.

**Get-sthAdminSDHolderGroup** - Function gets the Active Directory groups, protected by AdminSDHolder container.
It returns dsHeuristics attribute value, protected groups, and also groups, excluded from protection, if any.

**Disable-sthAdminSDHolderGroupProtection** - Function disables protection by AdminSDHolder container for Account Operators, Server Operators, Print Operators or Backup Operators groups.

**Enable-sthAdminSDHolderGroupProtection** - Function enables protection by AdminSDHolder container for Account Operators, Server Operators, Print Operators or Backup Operators groups.