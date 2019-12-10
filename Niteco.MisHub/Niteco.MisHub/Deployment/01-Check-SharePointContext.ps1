[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Publishing")
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Packaging")
#[System.Reflection.Assembly]::Load("WindowsBase,Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35")
[System.Reflection.Assembly]::LoadWithPartialName("WindowsBase")

#If the following Global variables are set, use these for local values. Otherwise continue using local values.
$Password = If ($Global:INTOPassword) {$Global:INTOPassword} Else {$Password}
$TenantUrl = If ($Global:INTOTenantUrl ) {$Global:INTOTenantUrl} Else {$TenantUrl}
$SiteUrl = If ($Global:INTOSiteUrl) {$Global:INTOSiteUrl} Else {$SiteUrl}
$Username = If ($Global:INTOUsername) {$Global:INTOUsername} Else {$Username}

$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($TenantUrl + $SiteUrl)
$SecurePassword = ConvertTo-SecureString -AsPlainText -Force $Password
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username, $SecurePassword)
$Ctx.Credentials = $Creds

#$Ctx = If ($Global:INTOCtx ) {$Global:INTOCtx}	Else {$Ctx}