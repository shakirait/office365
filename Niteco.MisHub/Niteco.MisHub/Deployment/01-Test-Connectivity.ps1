[CmdletBinding()]
Param(
	[Parameter(Mandatory=$false)][string] $TenantUrl = "https://hccuk.sharepoint.com/sites/",
	[Parameter(Mandatory=$false)][string] $SiteUrl = "NitecoApp",
	[Parameter(Mandatory=$false)][string] $Username = "tnguyen317@hccuk.onmicrosoft.com",
	[Parameter(Mandatory=$false)][string] $Password = "Huyen@2413",
	[Parameter(Mandatory=$false)][string] $LogFilePrefix = "Deploy", 
	[Parameter(Mandatory=$false)][string] $BuildDestinationFolder ="c:\niteco-deployment\"
)

#Functions
##############################################################################    
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Publishing")
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Packaging")
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



$Web = $Ctx.Web
$Ctx.Load($Web)
$Ctx.ExecuteQuery()
$title = $Web.Title
Write-Host $title