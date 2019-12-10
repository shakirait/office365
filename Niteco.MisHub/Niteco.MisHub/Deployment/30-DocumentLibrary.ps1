[CmdletBinding()]
Param(
	[Parameter(Mandatory=$false)][string] $TenantUrl = "https://mstnd335008.sharepoint.com/sites/",
	[Parameter(Mandatory=$false)][string] $SiteUrl = "onesight-dev",
	[Parameter(Mandatory=$false)][string] $Username = "admin@mstnd335008.onmicrosoft.com",
	[Parameter(Mandatory=$false)][string] $Password = "pass@word1",
	[Parameter(Mandatory=$false)][switch] $DeleteList,
	[Parameter(Mandatory=$false)][boolean] $ProvisionList = $true
)

. .\01-Check-SharePointContext.ps1

#Properties
$ListTitle = "Document Library"
$ListUrl = "DocumentLibrary"

#Check if list exists. Provision / delete and provision as configured.
try
{
	$Web = $Ctx.Web 
	$Lists = $Web.Lists
	$Ctx.Load($Web)
	$Ctx.Load($Lists)
	$Ctx.ExecuteQuery()
	$List = $Web.Lists | where{$_.Title -eq $ListTitle}
	if($List)
	{
		#Execute if list exists
		Write-Host "List " $ListTitle " exists." -ForegroundColor Green
		#$ProvisionList = Read-Host "Do you wish to delete the list (y/n)?"
		#if($ProvisionList -eq "y") {
		if($DeleteList){
			#$list = $context.Web.Lists.GetByTitle('PowerShell CSOM')
			#$context.Load($list)
			$List.DeleteObject()
			#$List.Update()
			$Ctx.ExecuteQuery()
			Write-Host "List deleted"
		} else {
			Write-Host "Aborting list provisioning. List already exists."
			return
		}
	}

	if($ProvisionList) {
		#Execute if list does not exist
		Write-Host "List " $ListTitle " does not exist. Creating..." -ForegroundColor Green
		#return $false

		#Create List
		$ListInfo = New-Object Microsoft.SharePoint.Client.ListCreationInformation
		$ListInfo.Title = $ListTitle
		$ListInfo.Url = $ListUrl
		$ListInfo.TemplateType = "101"
		$List = $Ctx.Web.Lists.Add($ListInfo)
		$List.Description = $ListTitle
		$List.Update()
		$Ctx.ExecuteQuery()

		#Name
		#$List.Fields.AddFieldAsXml("<Field Type='Text' DisplayName='Name' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='TRUE' MaxLength='255' StaticName='Name' Name='AppID' InternalName='Name'/>",$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
		#$List.Update()
		#$Context.ExecuteQuery()

		#ResearchType
		$List.Fields.AddFieldAsXml("<Field Type='Choice' DisplayName='Research Type' Required='TRUE' EnforceUniqueValues='FALSE' Indexed='FALSE' Format='Dropdown' FillInChoice='FALSE' StaticName='ResearchType' Name='ResearchType' ><Default>Research Type 1</Default><CHOICES><CHOICE>Research Type 1</CHOICE><CHOICE>Research Type 2</CHOICE></CHOICES></Field>",$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
		$List.Update()
		$Ctx.ExecuteQuery()
	}
}
catch
{
	Write-Host ("Error while checking for list. Error -->> " + $_.Exception.Message) -ForegroundColor Red
}