$acl = Get-Acl .\sshkey.pem
$acl.SetAccessRuleProtection($true,$false)
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("$whoami","FullControl","Allow")
$whoami = whoami
$acl.SetAccessRule($Ar)
Set-Acl .\sshkey.pem $acl