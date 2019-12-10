param(
	[parameter(Mandatory = $true)] [string]$env
)

. .\Environments\$env.ps1

$username = $environmentVariables.username
$password = $environmentVariables.password
$encpassword = convertto-securestring -String $password -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $encpassword

$webparttokens = @{
	"{rootWebAbsoluteUrl}" = $environmentVariables.rootWebAbsoluteUrl
	"{sitecollectionurl}" = $environmentVariables.sitecollectionurl    
}

$webpartsToUpdate = @{
            "/Pages/Home.aspx;Company Announcements" = $webparttokens["{sitecollectionurl}"] + '/SiteAssets/Niteco/webparts/CompanyAnnouncements/co-announcement.html'                   
			"/Pages/Home.aspx;Announcements" = $webparttokens["{sitecollectionurl}"] + '/SiteAssets/Niteco/webparts/Announcements/announcement.html'
			"/Pages/Home.aspx;Our Nitecans" = $webparttokens["{sitecollectionurl}"] + '/SiteAssets/Niteco/webparts/OurNitecans/our-nitecans.html'
			"/Pages/Home.aspx;Upcoming Events" = $webparttokens["{sitecollectionurl}"] + '/SiteAssets/Niteco/webparts/UpcomingEvents/upcoming-events.html'
			"/Pages/Home.aspx;Forms And Templates" = $webparttokens["{sitecollectionurl}"] + '/SiteAssets/Niteco/webparts/FormsAndTemplates/forms-templates.html'
			"/Pages/Home.aspx;Discussion View" = $webparttokens["{sitecollectionurl}"] + '/SiteAssets/Niteco/webparts/DiscussionView/discussion-view.html'
			"/Pages/Home.aspx;Company Gallery" = $webparttokens["{sitecollectionurl}"] + '/SiteAssets/Niteco/webparts/CompanyGallery/co-gallery.html'
}

$webpartsToAdd = @{
            "/Pages/Home.aspx;wpHotNews;Company Announcements;0" = '\webparts\HomeCompanyAnnouncements.dwp'
            "/Pages/Home.aspx;wpAnnouncements;Announcements;0" = '\webparts\HomeAnnouncements.dwp'  
			"/Pages/Home.aspx;wpOurNitecans;Our Nitecans;0" = '\webparts\HomeOurNitecans.dwp'
            "/Pages/Home.aspx;wpUpcomingEvents;Upcoming Events;0" = '\webparts\HomeUpcomingEvents.dwp' 
			"/Pages/Home.aspx;wpFormsAndTemplates;Forms And Templates;0" = '\webparts\HomeFormsAndTemplates.dwp'
            "/Pages/Home.aspx;wpDiscussionView;Discussion View;0" = '\webparts\HomeDiscussionView.dwp' 
			"/Pages/Home.aspx;wpCompanyGallery;Company Gallery;0" = '\webparts\HomeCompanyGallery.dwp'
}



function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  Split-Path $Invocation.MyCommand.Path
}

$webUrl = $webparttokens["{rootWebAbsoluteUrl}"] + $webparttokens["{sitecollectionurl}"]
Connect-PnpOnline $webUrl -Credentials $cred
$ctx = Get-PnPContext

#Add webparts
foreach($item in $webpartsToAdd.GetEnumerator()){
   $values = $item.Name.Split(';')
   $pageUrl = $webparttokens["{sitecollectionurl}"]+$values[0]
   $zone = $values[1]      
   $webpart = Get-PnPWebpart -ServerRelativePageUrl $pageUrl -Identity $values[2]      
   $currentDir = Get-ScriptDirectory
   if($webpart -eq $null){
        $file= Get-PnPFile -Url $pageUrl 
        if($file.CheckedOutByUser.Id -le 0){
            $file.CheckOut()
            Write-host "Checking out page, "$pageUrl -foregroundcolor "yellow"
        }

        $path = $currentDir+$item.Value
        Write-host "Adding webpart, "$pageUrl" at "$path -foregroundcolor "yellow"
        Add-PnPWebPartToWebPartPage -path $path -ServerRelativePageUrl $pageUrl -ZoneId $zone -ZoneIndex $values[3]
        Write-host "Checking in the page, "$pageUrl -foregroundcolor "yellow"    
        Set-PnPFileCheckedIn -Url $pageUrl -CheckinType MajorCheckIn        
    }
    else{
        Write-host "The webpart already existed, "$pageUrl" at "$path -foregroundcolor "Cyan"
    }
}

#Update webpart
foreach($item in $webpartsToUpdate.GetEnumerator()){
   $values = $item.Name.Split(';')
   $pageUrl = $webparttokens["{sitecollectionurl}"]+$values[0]
    $webpart = Get-PnPWebpart -ServerRelativePageUrl $pageUrl -Identity $values[1]      
    if($webpart -ne $null){
        $webpartId = $webpart.Id 
        $file= Get-PnPFile -Url $pageUrl 
        if($file.CheckedOutByUser.Id -le 0){
            $file.CheckOut()
            Write-host "Checking out page,"$pageUrl -foregroundcolor "yellow"
        }

        $htmllinkurl = $values[1]
        Write-host "Updating the webpart,"$htmllinkurl -foregroundcolor "yellow"
        Set-PnPWebPartProperty -ServerRelativePageUrl $pageUrl -Identity $webpartId -Key ContentLink -Value $item.Value         
        Write-host "Checking in the page, "$pageUrl -foregroundcolor "yellow"
        Set-PnPFileCheckedIn -Url $pageUrl -CheckinType MajorCheckIn
    }
    else{
        Write-host "The webpart cannot be found, "$pageUrl" at "$path -foregroundcolor "Cyan"
    }
}

       