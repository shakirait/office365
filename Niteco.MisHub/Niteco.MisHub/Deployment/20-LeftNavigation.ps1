[CmdletBinding()]
Param(
	[Parameter(Mandatory=$false)][string] $TenantUrl = "https://mstnd335008.sharepoint.com/sites/",
	[Parameter(Mandatory=$false)][string] $SiteUrl = "onesight-dev",
	[Parameter(Mandatory=$false)][string] $Username = "admin@mstnd335008.onmicrosoft.com",
	[Parameter(Mandatory=$false)][string] $Password = "pass@word1",
	[Parameter(Mandatory=$false)][switch] $DeleteList,
	[Parameter(Mandatory=$false)][switch] $AddSampleData,
	[Parameter(Mandatory=$false)][boolean] $ProvisionList = $true
)

. .\01-Check-SharePointContext.ps1

#Properties
$ListTitle = "LeftNavigation"
$ListUrl = "LeftNavigation"

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
			#$list = $Ctx.Web.Lists.GetByTitle('PowerShell CSOM')
			#$Ctx.Load($list)
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
		$ListInfo.TemplateType = "100"
		$List = $Ctx.Web.Lists.Add($ListInfo)
		$List.Description = $ListTitle
		$List.Update()
		$Ctx.ExecuteQuery()

		#ClassName
		$List.Fields.AddFieldAsXml("<Field Type='Text' DisplayName='Class Name' Required='False' EnforceUniqueValues='FALSE' Indexed='FALSE' StaticName='ClassName' Name='ClassName' Hidden='FALSE' ShowInDisplayForm='TRUE' ShowInEditForm='TRUE' ShowInListSettings='TRUE' ShowInNewForm='TRUE'/>",$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
		$List.Update()
		$Ctx.ExecuteQuery()

		#Icon
		$List.Fields.AddFieldAsXml("<Field Type='URL' DisplayName='Icon' Required='False' EnforceUniqueValues='FALSE' Indexed='FALSE' Format='Hyperlink' StaticName='Icon' Name='Icon' Hidden='FALSE' ShowInDisplayForm='TRUE' ShowInEditForm='TRUE' ShowInListSettings='TRUE' ShowInNewForm='TRUE'/>",$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
		$List.Update()
		$Ctx.ExecuteQuery()

		#HoverIcon
		$List.Fields.AddFieldAsXml("<Field Type='URL' DisplayName='Hover Icon' Required='False' EnforceUniqueValues='FALSE' Indexed='FALSE' Format='Hyperlink' StaticName='HoverIcon' Name='HoverIcon' Hidden='FALSE' ShowInDisplayForm='TRUE' ShowInEditForm='TRUE' ShowInListSettings='TRUE' ShowInNewForm='TRUE'/>",$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
		$List.Update()
		$Ctx.ExecuteQuery()

		#NavigationURL
		$List.Fields.AddFieldAsXml("<Field Type='URL' DisplayName='Navigation URL' Required='TRUE' EnforceUniqueValues='FALSE' Indexed='FALSE' Format='Hyperlink' StaticName='NavigationURL' Name='NavigationURL' Hidden='FALSE' ShowInDisplayForm='TRUE' ShowInEditForm='TRUE' ShowInListSettings='TRUE' ShowInNewForm='TRUE'/>",$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
		$List.Update()
		$Ctx.ExecuteQuery()

		#Order
		$List.Fields.AddFieldAsXml("<Field Type='Number' DisplayName='Order' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' StaticName='Order' Name='Order'/>",$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
		$List.Update()
		$Ctx.ExecuteQuery()
		#NavigationURL
		#$List.Fields.AddFieldAsXml("<Field Type='URL' DisplayName='Navigation URL' Required='TRUE' EnforceUniqueValues='FALSE' Indexed='FALSE' Format='Hyperlink' StaticName='NavigationURL' Name='NavigationURL' Hidden='FALSE' ShowInDisplayForm='TRUE' ShowInEditForm='TRUE' ShowInListSettings='TRUE' ShowInNewForm='TRUE'/>",$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
		#$List.Update()
		#$Ctx.ExecuteQuery()

		#Order
		#$List.Fields.AddFieldAsXml("<Field Type='Number' DisplayName='Sort Order' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' StaticName='SortOrder' Name='SortOrder'/>",$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
		#$List.Update()
		#$Ctx.ExecuteQuery()
	}

	if($AddSampleData) {
		#Add new List Item
		$itemCreateInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
		$listItem = $List.addItem($itemCreateInfo)
		#Set Fields (internal name)
		$listItem['Title'] = "Home"
		$navLinkValue = New-Object Microsoft.SharePoint.Client.FieldUrlValue
		$navLinkValue.Url = $Web.Url + "/Pages/Home.aspx"; 
		$navLinkValue.Description = "Home" 
		$listItem["NavigationURL"] = [Microsoft.SharePoint.Client.FieldUrlValue]$navLinkValue
		$listItem["ClassName"] = "home"
		$listItem['Order'] = 10
		$listItem.update();

		#Execute
		$Ctx.Load($List)
		$Ctx.ExecuteQuery()

		Write-Host "Item added - " + $listItem.Id
	}
}
catch
{
	Write-Host ("Error while checking for list. Error -->> " + $_.Exception.Message) -ForegroundColor Red
}