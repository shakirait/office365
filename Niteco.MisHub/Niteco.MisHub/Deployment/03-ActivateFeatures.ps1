[CmdletBinding()]
Param(
	[Parameter(Mandatory=$false)][string] $TenantUrl = "https://hccuk.sharepoint.com/sites/",
	[Parameter(Mandatory=$false)][string] $SiteUrl = "NitecoApp",
	[Parameter(Mandatory=$false)][string] $Username = "tnguyen317@hccuk.onmicrosoft.com",
	[Parameter(Mandatory=$false)][string] $Password = "Huyen@2413"
)

Write-Host "Activating Features"
. .\01-Check-SharePointContext.ps1

#Connection
#$Password = Read-Host -Prompt "Please enter your password" -AsSecureString

#region - Enable site and web publishing features
$Ctx.Site.Features.Add([System.GUID]("f6924d36-2fa8-4f0b-b16d-06b7250180fa"), $true,[Microsoft.SharePoint.Client.FeatureDefinitionScope]::None)
$Ctx.ExecuteQuery()
$Ctx.Web.Features.Add([System.GUID]("22a9ef51-737b-4ff2-9346-694633fe4416"), $true, [Microsoft.SharePoint.Client.FeatureDefinitionScope]::None)
$Ctx.ExecuteQuery()
#endregion

#Connect-PnPOnline –Url https://intoonesight.sharepoint.com/sites/UniversityPortal –Credentials (Get-Credential)


#Get-Command -Module *PnP*

#Disable-PnPFeature –Identity "F6924D36-2FA8-4f0b-B16D-06B7250180FA" -Scope Site
#Disable-PnPFeature –Identity "AEBC918D-B20F-4a11-A1DB-9ED84D79C87E" -Scope Site
#Disable-PnPFeature –Identity "22A9EF51-737B-4ff2-9346-694633FE4416" -Scope Web
#Disable-PnPFeature –Identity "D3F51BE2-38A8-4e44-BA84-940D35BE1566" -Scope Site
#Disable-PnPFeature –Identity "94C94CA6-B32F-4da9-A9E3-1F3D343D7ECB" -Scope Web

#Enable-PnPFeature –Identity "F6924D36-2FA8-4f0b-B16D-06B7250180FA" -Scope Site
#Enable-PnPFeature –Identity "AEBC918D-B20F-4a11-A1DB-9ED84D79C87E" -Scope Site
#Enable-PnPFeature –Identity "22A9EF51-737B-4ff2-9346-694633FE4416" -Scope Web
#Enable-PnPFeature –Identity "D3F51BE2-38A8-4e44-BA84-940D35BE1566" -Scope Site
#Enable-PnPFeature –Identity "94C94CA6-B32F-4da9-A9E3-1F3D343D7ECB" -Scope Web