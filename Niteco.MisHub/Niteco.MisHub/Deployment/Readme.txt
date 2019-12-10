#Sample deployment script

.\02-EnableDevSiteCollectionFeature.ps1 -TenantUrl "https://mstnd394286.sharepoint.com/sites/" -SiteUrl "onesight-dev" -Username "admin@mstnd394286.onmicrosoft.com"
.\03-ActivateFeatures.ps1 -TenantUrl "https://mstnd394286.sharepoint.com/sites/" -SiteUrl "onesight-dev" -Username "admin@mstnd394286.onmicrosoft.com"
.\10-PowerBIReports.ps1 -TenantUrl "https://mstnd394286.sharepoint.com/sites/" -SiteUrl "onesight-dev" -Username "admin@mstnd394286.onmicrosoft.com"
.\20-LeftNavigation.ps1 -TenantUrl "https://mstnd394286.sharepoint.com/sites/" -SiteUrl "onesight-dev" -Username "admin@mstnd394286.onmicrosoft.com" -AddSampleData
.\30-DocumentLibrary.ps1 -TenantUrl "https://mstnd394286.sharepoint.com/sites/" -SiteUrl "onesight-dev" -Username "admin@mstnd394286.onmicrosoft.com"


#Themes (look in core project resources folder for theme file):
#/sites/onesight-dev/_catalogs/theme/15/Palette033.spcolor
#/sites/onesight-dev/_catalogs/masterpage/seattle.master
#Display Order: 180


.\50-Upload-PageLayouts.ps1 -TenantUrl "https://mstnd394286.sharepoint.com/sites/" -SiteUrl "onesight-dev" -Username "admin@mstnd394286.onmicrosoft.com"
.\60-Create-Pages.ps1 -TenantUrl "https://mstnd394286.sharepoint.com/sites/" -SiteUrl "onesight-dev" -Username "admin@mstnd394286.onmicrosoft.com"
.\70-Upload-Assets.ps1 -TenantUrl "https://mstnd394286.sharepoint.com/sites/" -SiteUrl "onesight-dev" -Username "admin@mstnd394286.onmicrosoft.com"
.\00-Deploy.ps1 -GenerateAddIn -TenantUrl "https://mstnd394286.sharepoint.com/sites/" -SiteUrl "onesight-dev" -Username "admin@mstnd394286.onmicrosoft.com"