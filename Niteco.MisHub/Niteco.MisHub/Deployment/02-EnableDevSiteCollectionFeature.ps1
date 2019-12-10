[CmdletBinding()]
Param(
	[Parameter(Mandatory=$false)][string] $TenantUrl = "https://hccuk.sharepoint.com/sites/",
	[Parameter(Mandatory=$false)][string] $SiteUrl = "NitecoApp",
	[Parameter(Mandatory=$false)][string] $Username = "tnguyen317@hccuk.onmicrosoft.com",
	[Parameter(Mandatory=$false)][string] $Password = "Huyen@2413"
)

Write-Host "Activating Developer Site Collection Features"
. .\01-Check-SharePointContext.ps1

#region
$Ctx.Site.Features.Add([System.Guid]("e374875e-06b6-11e0-b0fa-57f5dfd72085"), $true,[Microsoft.SharePoint.Client.FeatureDefinitionScope]::farm)
$Ctx.ExecuteQuery()
#endregion