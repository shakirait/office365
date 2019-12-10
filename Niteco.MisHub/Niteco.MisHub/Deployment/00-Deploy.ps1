[CmdletBinding()]
Param(
	[Parameter(Mandatory=$false)][string] $TenantUrl = "https://hccuk.sharepoint.com/sites/",
	[Parameter(Mandatory=$false)][string] $SiteUrl = "NitecoApp",
	[Parameter(Mandatory=$false)][string] $Username = "tnguyen317@hccuk.onmicrosoft.com",
	[Parameter(Mandatory=$false)][string] $Password = "Huyen@2413",
	[Parameter(Mandatory=$false)][string] $LogFilePrefix = "Deploy", 
	[Parameter(Mandatory=$false)][string] $BuildDestinationFolder ="c:\niteco-deployment\",
	[Parameter(Mandatory=$false)][string] $ConfigFilePath = "d:\niteco\niteco-ext-prod-config.json",
#	[Parameter(Mandatory=$false)][boolean] $DeleteList = $false,
#	[Parameter(Mandatory=$false)][boolean] $ProvisionList = $true

	#
	[switch]$All,
	[switch]$Refresh,
	[switch]$EnableFeatures, 
	[switch]$ApplyTheme,
	[switch]$ProvisionGroups,
	[switch]$GenerateAddIn,
	[switch]$CreateDocumentLibrary,
	[switch]$CreatePowerBILibrary,
	[switch]$CreateKPIPrefLists,
	[switch]$CreateReportsList,
	[switch]$UploadAssets,
	[switch]$UploadPageLayouts,
	[switch]$CreatePages,
	[switch]$AddWebPartsToPages,
	[switch]$AddNavigationToLibraryViews,
	[switch]$AddSampleData
)
BEGIN {
	#if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)  
	#{ 
    #	Add-PSSnapin "Microsoft.SharePoint.PowerShell" 
	#} 
	#Set global variables for use in child scripts
	$Global:INTOTenantUrl = $TenantUrl
	$Global:INTOSiteUrl = $SiteUrl
	$Global:INTOPassword = $Password
	$Global:INTOUsername = $Username
	#
	. .\01-Check-SharePointContext.ps1
}

PROCESS {
	if($EnableFeatures -or $All) {. .\03-ActivateFeatures.ps1 }
	
	#Lists and Libraries
	if($CreateDocumentLibrary -or $All) {. .\30-DocumentLibrary.ps1 -DeleteList}
	if($CreatePowerBILibrary -or $All) {. .\10-PowerBIReports.ps1 -DeleteList}
	if($CreateKPIPrefLists -or $All) {. .\15-Create-KPIPrefLists.ps1 -DeleteList}
	if($CreateReportsList -or $All) {. .\15-Create-ReportsList.ps1 -DeleteList}
	
	if($ApplyTheme -or $All) { . .\40-Apply-Theme.ps1}
	if($ProvisionGroups -or $All) {. .\45-Create-SiteGroups.ps1}
	if($UploadAssets) {. .\70-Upload-Assets.ps1}
	if($UploadPageLayouts) { . .\50-Upload-PageLayouts.ps1}
	if($CreatePages -or $All) {. .\60-Create-Pages.ps1 }
	if($AddWebPartsToPages) {. .\Add-WebParts.ps1}
	if($AddNavigationToLibraryViews) {}
	if($AddSampleData) {
		#User preferences
		#Report list
		#KPI list
		#Power BI Reports
		#Document Library
	}

	# Packaging - One file per environment to accomodate upload to a single app catalog
	if($GenerateAddIn -or $All) {
		#Dev
		. .\80-Package-App.ps1 `
			-Path $(Resolve-Path "..\..\Niteco.MisHub.PBI\bin\Debug\app.publish\1.0.0.0\Niteco.MisHub.PBI.app") `
			-Title "Dev - Niteco PBI Viewer" `
			-ClientId "4d0a91d1-a021-4be9-89dd-714cc0894409" `
			-RedirectUrl "https://intomishubdev.azurewebsites.net/Home/Index" `
			-TargetFilename $($BuildDestinationFolder + "Dev.Niteco.MisHub.PBI.app") `
			-RemoteAppUrl "https://intomishubdev.azurewebsites.net" #`
			#-AppManifestReplacementProductId "{7be9602f-17fb-4f2f-84bd-534267a60714}" `
			#-AppManifestReplacementName "NitecoPBIViewer"
		#Test
		. .\80-Package-App.ps1 `
			-Path $(Resolve-Path "..\..\Niteco.MisHub.PBI\bin\Debug\app.publish\1.0.0.0\Niteco.MisHub.PBI.app") `
			-Title "Test - Niteco PBI Viewer" `
			-ClientId "d40bfa78-8cc2-4946-b2cd-f1204d3b0bc9" `
			-RedirectUrl "https://intomishubtest.azurewebsites.net/Home/Index" `
			-TargetFilename $($BuildDestinationFolder + "Test.Niteco.MisHub.PBI.app") `
			-RemoteAppUrl "https://intomishubtest.azurewebsites.net" #`
			#-AppManifestReplacementProductId "{7be9602f-17fb-4f2f-84bd-534267a60714}" `
			#-AppManifestReplacementName "NitecoPBIViewer"
		#NITECO UAT
		. .\80-Package-App.ps1 `
			-Path $(Resolve-Path "..\..\Niteco.MisHub.PBI\bin\Debug\app.publish\1.0.0.0\Niteco.MisHub.PBI.app") `
			-Title "UAT - Niteco PBI Viewer" `
			-ClientId "e33348cf-078d-49d5-9f97-04b476fbad55" `
			-RedirectUrl "https://onesight-uat.azurewebsites.net/Home/Index" `
			-TargetFilename $($BuildDestinationFolder + "UAT.Niteco.MisHub.PBI.app") `
			-RemoteAppUrl "https://onesight-uat.azurewebsites.net" #`
			#+ "UAT.Niteco.MisHub.PBI.Viewer.app") `
			#-AppManifestReplacementProductId "{7be9602f-17fb-4f2f-84bd-534267a60714}" `
			#-AppManifestReplacementName "NitecoPBIViewer"
		#NITECO Production
		. .\80-Package-App.ps1 `
			-Path $(Resolve-Path "..\..\Niteco.MisHub.PBI\bin\Debug\app.publish\1.0.0.0\Niteco.MisHub.PBI.app") `
			-Title "Niteco PBI Viewer" `
			-ClientId "42aa02f2-fe6b-465b-b20a-0a70e6bf12a4" `
			-RedirectUrl "https://onesight.azurewebsites.net/Home/Index" `
			-TargetFilename $($BuildDestinationFolder + "Niteco.MisHub.PBI.app") `
			-RemoteAppUrl "https://onesight.azurewebsites.net" #`
			#+ "UAT.Niteco.PBI.Viewer.app") `
			#-AppManifestReplacementProductId "{7be9602f-17fb-4f2f-84bd-534267a60714}" `
			#-AppManifestReplacementName "NitecoPBIViewer"
	}

	

	#Create Page Instances
	#

	#Add Web/App Parts per page
	#


	#Add navigation to OOB list/library pages
	#

	#Provision sample data
	#


    #Remove-Variable Password -Scope Global -Force
    #Remove-Variable Password -Scope Global -Force
    Clear-Variable INTO* -Scope Global
}
END {
	
}

