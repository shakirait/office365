#
#Script checks publishing features are enabled for site and web. Then uploads page layouts
#

#Upload page layout and set content type
[CmdletBinding()]
Param(
	[Parameter(Mandatory=$false)][string] $TenantUrl = "https://hccuk.sharepoint.com/sites/",
	[Parameter(Mandatory=$false)][string] $SiteUrl = "NitecoApp",
	[Parameter(Mandatory=$false)][string] $Username = "tnguyen317@hccuk.onmicrosoft.com",
	[Parameter(Mandatory=$false)][string] $Password = "Huyen@2413",
	[Parameter(Mandatory=$false)][boolean] $DeleteLayouts = $false
)

#Add references to SharePoint client assemblies and authenticate to Office 365 site
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

. .\01-Check-SharePointContext

Function Deploy-PageLayout([Microsoft.SharePoint.Client.Web]$Web, [string]$FilePath, [string]$LayoutName, [string]$AssociatedContentTypeId)
{
	 #0x01010007FF3E057FA8AB4AA42FCB67B453FFC100E214EEE741181F4E9F7ACC43278EE811
     #$pageLayoutContentTypeId = "0x01010007FF3E057FA8AB4AA42FCB67B453FFC100E214EEE741181F4E9F7ACC43278EE8110003D357F861E29844953D5CAA1D4D8A3B001EC1BD45392B7A458874C52A24C9F70B"
	 
	 #Base page layout content type Id
     $pageLayoutContentTypeId = "0x01010007FF3E057FA8AB4AA42FCB67B453FFC100E214EEE741181F4E9F7ACC43278EE811" 
							     
	 $fileName = [System.IO.Path]::GetFileName($FilePath)

     $associatedContentType = $Web.AvailableContentTypes.GetById($AssociatedContentTypeId)
     $catalogList = $Web.GetCatalog([Microsoft.SharePoint.Client.ListTemplateType]::MasterPageCatalog)    
     $Web.Context.Load($catalogList.RootFolder)
     $Web.Context.Load($associatedContentType)
     $Web.Context.ExecuteQuery()

     $fileContent = [System.IO.File]::ReadAllBytes($FilePath)
     $fileInfo = New-Object Microsoft.SharePoint.Client.FileCreationInformation
     $fileInfo.Content = $fileContent
     $fileInfo.Url = $catalogList.RootFolder.ServerRelativeUrl + "/" + $fileName
     $fileInfo.Overwrite = $true

     $file = $catalogList.RootFolder.Files.Add($fileInfo)
     $Web.Context.Load($file)
     $Web.Context.ExecuteQuery()

     $listItem = $file.ListItemAllFields
     $listItem["Title"] = $LayoutName;
     #listItem["MasterPageDescription"] = description;
     $listItem["ContentTypeId"] = $pageLayoutContentTypeId
     $listItem["PublishingAssociatedContentType"] = [string]::Format(";#{0};#{1};#", $associatedContentType.Name, $associatedContentType.Id.StringValue)
     $listItem["UIVersion"] = [Convert]::ToString(15)
     $listItem.Update()

     $Web.Context.ExecuteQuery()
}

$WelcomePageContentTypeId = "0x010100C568DB52D9D0A14D9B2FDCC96666E9F2007948130EC3DB064584E219954237AF390064DEA0F50FC8C147B0B6EA0636C4A7D4"
$ArticlePageContentTypeId = "0x010100C568DB52D9D0A14D9B2FDCC96666E9F2007948130EC3DB064584E219954237AF3900242457EFB8B24247815D688C526CD44D"
							# 0x010100C568DB52D9D0A14D9B2FDCC96666E9F2007948130EC3DB064584E219954237AF3900242457EFB8B24247815D688C526CD44D002D8E369E5211204CA6A61CFF72717BEE
							# 0x010100C568DB52D9D0A14D9B2FDCC96666E9F2007948130EC3DB064584E219954237AF3900242457EFB8B24247815D688C526CD44D0043FDAFB51C7BC449989F825C4728E787

#$context = Get-ClientContext -Url $Url -UserName $UserName -Password $Password
Deploy-PageLayout -Web $ctx.Web -FilePath $(Resolve-Path "..\Resources\layouts\NITECOLayout1.aspx") -LayoutName "NITECO Layout 1" -AssociatedContentTypeId $ArticlePageContentTypeId

$ctx.Dispose()