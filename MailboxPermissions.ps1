## Script to pull information on all mailboxes and list who has what permission on them.
## By Mark Slingo (mark.sl) Aug 2024

$user_find_permissions= "*Henrietta Fischer*"
$allpermissions = @()
$MBXs= Get-Mailbox -ResultSize Unlimited
Foreach ($MBX in $MBXs){
$MBXfolders=Get-MailboxFolderStatistics $MBX.PrimarySmtpAddress |select Name
Foreach ($MBXfolder in $MBXfolders){
try {
$folder=$MBX.PrimarySmtpAddress + ":\" + $MBXfolder.name
$folderpermessions= Get-MailboxFolderPermission -Identity $folder -ErrorAction Stop | where {($_.user -like $user_find_permissions)}
$allpermissions += $folderpermessions
}
catch {
Continue
}
}
}
$allpermissions | select Identity, FolderName, User,AccessRights