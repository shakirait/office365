[CmdletBinding()]
Param(
	[Parameter(Mandatory=$false)][string] $TenantUrl = "https://hccuk.sharepoint.com/sites/",
	[Parameter(Mandatory=$false)][string] $SiteUrl = "NitecoApp",
	[Parameter(Mandatory=$false)][string] $Username = "tnguyen317@hccuk.onmicrosoft.com",
	[Parameter(Mandatory=$false)][string] $Password = "Huyen@2413",
	[Parameter(Mandatory=$false)][boolean] $DeletePage = $true
)

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Publishing")


. .\01-Check-SharePointContext


Function Provision-Page([Microsoft.SharePoint.Client.ClientContext]$ctx, [string]$pageName, [string]$pageTitle, [string]$pageLayoutName) {
	#$pageName = "TestPage2.aspx"  
	$lists = $ctx.web.Lists   
	$list = $lists.GetByTitle("Pages")  
	$query = New-Object Microsoft.SharePoint.Client.CamlQuery  
	$query.ViewXml = "<View><Query><Where><Contains><FieldRef Name='FileLeafRef' /><Value Type='Text'>"+$pageName+"</Value></Contains></Where></Query></View>"  
	$listItems = $list.GetItems($query)  
	$ctx.load($listItems)      
	$ctx.executeQuery()  
  
	if($listItems.Count -gt 0){  
		Write-Host "Page already exists."  
		if($DeletePage) {
			for ($i = $listItems.Count-1; $i -ge 0; $i--)
			{
				$listItems[$i].DeleteObject()
			}
			$ctx.ExecuteQuery()
			Write-Host "Page deleted. Provisioning new page..."
		} else {
			return
		}
	}

	#Provision page
	$pageLayoutList = $ctx.web.Lists.GetByTitle("Master Page Gallery")  
	$pageLayoutQuery = New-Object Microsoft.SharePoint.Client.CamlQuery  
	$pageLayoutQuery.ViewXml = "<View><Query><Where><Eq><FieldRef Name='FileLeafRef' /><Value Type='Text'>"+$pageLayoutName+"</Value></Eq></Where></Query></View>"  
	$pageLayouts = $pageLayoutList.GetItems($pageLayoutQuery)  
	$ctx.Load($pageLayouts)  
	$ctx.ExecuteQuery()  
	$pageLayout = $pageLayouts[0]

	#Get the publishing Web  
	$pubWeb = [Microsoft.SharePoint.Client.Publishing.PublishingWeb]::GetPublishingWeb($ctx, $ctx.Web)  
	$ctx.Load($pubWeb)

	$pageInfo = New-Object Microsoft.SharePoint.Client.Publishing.PublishingPageInformation  
	$pageInfo.Name = $pageName  
	#$pageInfo.Title = $pageTitle
	$pageInfo.PageLayoutListItem = $pageLayout  
	$page = $pubWeb.AddPublishingPage($pageInfo)
	
	$page.ListItem.File.CheckIn("", [Microsoft.SharePoint.Client.CheckinType]::MajorCheckIn)
	$page.ListItem.File.Publish("")
	#$page.ListItem.File.Approve("")
	  
	$ctx.Load($page)  
	$ctx.ExecuteQuery()

	# Page added. Now retrieve list item, check it out, 
	# update title and page content, and check back in.
	$listItem = $page.get_listItem()
	$ctx.Load($listItem)
	$ctx.ExecuteQuery()

	$file = $listItem.File
	$file.CheckOut()
	$ctx.Load($file)
	$ctx.ExecuteQuery()

	$listItem.Set_Item("Title", $pageTitle)
	$listItem.Update()
	$listItem.File.CheckIn("", [Microsoft.SharePoint.Client.CheckinType]::MajorCheckIn)
	$listItem.File.Publish("")
	#$listItem.File.Approve("")
	$ctx.Load($listItem)
	$ctx.ExecuteQuery()
}

Provision-Page -ctx $Ctx -pageName "Home.aspx" -pageTitle "Niteco Home" -pageLayout "NITECOLayout1.aspx"