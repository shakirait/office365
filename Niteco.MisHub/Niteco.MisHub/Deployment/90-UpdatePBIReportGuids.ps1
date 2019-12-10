cls
Set-ExecutionPolicy unrestricted
#Install-Module -Name PowerBIPS

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client") | out-null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime") | out-null

Import-Module ".\Artifacts\PowerBIPS\1.2.0.9\PowerBIPS" -Force

function Get-ReportsfromPowerBI
{
    Param($username,$password,$clientId,$PBIGroupId)

    $securePassword =$password | ConvertTo-SecureString -AsPlainText -Force
    $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $securePassword
    $authToken = Get-PBIAuthToken -ClientId $clientId -Credential $cred 

    #IntoReports 
    $INTOReports= Invoke-RestMethod -Uri "https://api.powerbi.com/beta/myorg/groups/$PBIGroupId/reports" -Header @{"Authorization"="Bearer "+$authToken}  

    write-host "PowerBI reports collection retrieved" -ForegroundColor Green;
    return $INTOReports; 

}

Function Get-SPOContext([string]$Url,[string]$UserName,[string]$Password)
{
    $SecurePassword = $Password | ConvertTo-SecureString -AsPlainText -Force
    $context = New-Object Microsoft.SharePoint.Client.ClientContext($Url)
    $context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName, $SecurePassword)
    return $context
}


Function Get-ListItems([Microsoft.SharePoint.Client.ClientContext]$Context, [String]$ListTitle) {
    $list = $Context.Web.Lists.GetByTitle($listTitle)
    $qry = [Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery()
    $items = $list.GetItems($qry)
    $Context.Load($items)
    $Context.ExecuteQuery()
    return $items 
}

Function Update-ListItem([Microsoft.SharePoint.Client.ClientContext]$Context,$ListName,$ID, $column,$value)
{
    $list = $Context.Web.Lists.GetByTitle($ListName)
    [Microsoft.SharePoint.Client.ListItem]$listItem = $list.GetItemById($ID)     
    $listItem[$column] = $value  
    $listItem.Update()
    $context.ExecuteQuery()
}


#region Input Parameters for PBI
$user = "admin@mstnd394286.onmicrosoft.com"
$pass = "ms!Demos365" 
$clientId="a4b76874-4553-48fc-812b-9cb0a7576869"
$INTOGroupId="d6d3ec84-2152-4f83-92e1-10c453d98ea5";
$SPOSiteUrl="https://mstnd394286.sharepoint.com/sites/onesight-dev-sb"; 
$PBIReportConfigurationListName="PBI Report Configuration" # ReportID column value to be updated
$PBIReportListName="Power BI Reports" # Report Guid value in the URL to be updated
#endregion

#IntoReports 
$INTOReports=Get-ReportsfromPowerBI -username $user -password $pass -clientId $clientId -PBIGroupId $INTOGroupId

#Get SPOContext
$spoCtx= Get-SPOContext -Url $SPOSiteUrl -UserName $user -Password $pass

$PBIReportConfigurationListItems = Get-ListItems -Context $spoCtx -ListTitle $PBIReportConfigurationListName
$PBIReportListItems = Get-ListItems -Context $spoCtx -ListTitle $PBIReportListName


write-host
write-host Updating PBI Report Configuration List -ForegroundColor Green
write-host ======================================
foreach ($i in $PBIReportConfigurationListItems)
{
 if ($INTOReports.value | where {$_.name -eq $i["Title"]} )
 {
    $guidfromPBI =($INTOReports.value | where {$_.name -eq $i["Title"]})|  Select-Object  -Property "Id" 
    write-host "Report Name : " $i["Title"] -ForegroundColor Gray
    write-host "PBI Guid    :"  $i.Id  $i["ReportId"]
    Update-ListItem -Context $spoCtx -ListName $PBIReportConfigurationListName -ID $i.Id -column "ReportId" -value $guidfromPBI.id
    write-host "GUID Updated . . . " -ForegroundColor Green
    write-host
 }
    
}



write-host
write-host Updating PBI Reports List -ForegroundColor Green
write-host =========================
foreach ($i in $PBIReportListItems)
{
   $x=$i["URL"].Url -split("reportUrl=")
   $url=$x[1]
   $title=$i["URL"].Description
   

   if ($INTOReports.value | where {$_.name -eq $title} )
   {
    $guidfromPBI =($INTOReports.value | where {$_.name -eq $title})|  Select-Object  -Property "Id"       
   
    #Construct the new URL 
    $guidpattern = "reports\/[a-fA-F0-9]{8}-([a-fA-F0-9]{4}-){3}[a-fA-F0-9]{12}"
    $newUrl = $url -replace $guidpattern, ("reports/"+$guidfromPBI.id)
    $newUrl=$x[0]+"reportUrl="+ $newUrl
    write-host "Report Name :" $title  -ForegroundColor Gray
    write-host "PBI Guid: " $guidfromPBI.id
    write-host "Old Url : " $i["URL"].Url
    write-host "New Url : " $newUrl
    $valuetoBeUpdated =$newUrl+", "+$title # {Url}, {Description}

       
    Update-ListItem -Context $spoCtx -ListName $PBIReportListName -ID $i.Id -column "URL" -value $valuetoBeUpdated
    write-host "Url Updated . . . " -ForegroundColor Green
    write-host

   }
}

