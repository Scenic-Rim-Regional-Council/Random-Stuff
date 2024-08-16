## Script to pull information on all mailboxes and list who has what permission on them.
## By Mark Slingo (mark.sl) Aug 2024

$user_find_permissions = Read-Host "User to search: "
If(!$user_find_permissions) {
    Write-Host "`nName cannot be blank. Please try again." -ForegroundColor Red
    Return
}
Connect-ExchangeOnline
$allpermissions = @()
$MBXs= Get-Mailbox -ResultSize Unlimited
Foreach ($MBX in $MBXs){
$MBXfolders=Get-MailboxFolderStatistics $MBX.PrimarySmtpAddress | Select-Object Name
Foreach ($MBXfolder in $MBXfolders){
try {
$folder=$MBX.PrimarySmtpAddress + ":\" + $MBXfolder.name
$folderpermessions= Get-MailboxFolderPermission -Identity $folder -ErrorAction Stop | Where-Object {($_.user -like $user_find_permissions)}
$allpermissions += $folderpermessions
}
catch {
Continue
}
}
}
$allpermissions | Select-Object Identity, FolderName, User,AccessRights