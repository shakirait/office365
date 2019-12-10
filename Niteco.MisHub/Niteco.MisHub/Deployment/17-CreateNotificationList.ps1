[CmdletBinding()]
Param(
	[Parameter(Mandatory=$false)][string] $TenantUrl = "https://mstnd335008.sharepoint.com/sites/",
	[Parameter(Mandatory=$false)][string] $SiteUrl = "onesight-dev",
	[Parameter(Mandatory=$false)][string] $Username = "",
	[Parameter(Mandatory=$false)][string] $Password = "",
	[Parameter(Mandatory=$false)][string] $ListName = "Notifications",
	[Parameter(Mandatory=$false)][string] $ListDescription = "Notifications List"
)

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Publishing")
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Packaging")
[System.Reflection.Assembly]::LoadWithPartialName("WindowsBase")

. .\01-Check-SharePointContext.ps1

try 
{    
    Write-Host "----------------------------------------------------------------------------"  -foregroundcolor Green 
    Write-Host "Creating List $ListName in $TenantUrl $SiteUrl !!" -ForegroundColor Green 
    Write-Host "----------------------------------------------------------------------------"  -foregroundcolor Green         
 
    $spoWeb=$Ctx.Web 
    $spoListCreationInformation=New-Object Microsoft.SharePoint.Client.ListCreationInformation 
    $spoListCreationInformation.Title=$ListName
    
    $spoListCreationInformation.TemplateType=[int][Microsoft.SharePoint.Client.ListTemplatetype]::GenericList 
    $spoList=$spoWeb.Lists.Add($spoListCreationInformation) 
    $spoList.Description=$ListDescription 
    $spoList.Fields.AddFieldAsXml("<Field Type='Note' DisplayName='Notification Body' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' NumLines='6' RichText='TRUE' RichTextMode='FullHtml' IsolateStyles='TRUE' Sortable='FALSE' StaticName='Body' Name='Body' ColName='ntext2' RowOrdinal='0' Version='1' />",$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $spoList.Fields.AddFieldAsXml("<Field Type='DateTime'  Name='Expires' DisplayName='Expires'/>",$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $spoList.Fields.AddFieldAsXml("<Field Type='Choice' Name='Icon' DisplayName='Icon' FillInChoice='False' Format='Dropdown' >
									<Default>
                                        info
                                    </Default>
                                    <CHOICES>
                                        <CHOICE>
                                            info
                                        </CHOICE>
                                        <CHOICE>
                                            warning
                                        </CHOICE>
                                        <CHOICE>
                                            user
                                        </CHOICE>
                                    </CHOICES>
                                    </Field>",
		$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)

    $spoList.Fields.AddFieldAsXml("<Field Type='Boolean'  StaticName='ShowCheckBox' Name='ShowCheckBox'  DisplayName='Show CheckBox'/>",$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
      
    $Ctx.ExecuteQuery() 
 
    Write-Host "----------------------------------------------------------------------------"  -foregroundcolor Green 
    Write-Host "List $ListName created in $TenantUrl $SiteUrl !!" -ForegroundColor Green 
    Write-Host "----------------------------------------------------------------------------"  -foregroundcolor Green   
    #$Ctx.Dispose() 
} 
catch [System.Exception] 
{ 
    Write-Host -ForegroundColor Red $_.Exception.ToString()    
}     
