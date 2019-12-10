[CmdletBinding()]
Param(
	[Parameter(Mandatory=$false)][string] $TenantUrl = "https://hccuk.sharepoint.com/sites/",
	[Parameter(Mandatory=$false)][string] $SiteUrl = "NitecoApp",
	[Parameter(Mandatory=$false)][string] $Username = "tnguyen317@hccuk.onmicrosoft.com",
	[Parameter(Mandatory=$false)][string] $Password = "Huyen@2413",
	
	[Parameter(Mandatory=$false)][boolean] $DeleteFolder = $false,
	[Parameter(Mandatory=$False)]
	[String]$DocLibName = "Site Assets",
	[Parameter(Mandatory=$False)]
	[String]$Folder = $(Resolve-Path "..\Resources") ,
	[Parameter(Mandatory=$false)][string] $TargetFolderName = "Niteco",
	[Parameter(Mandatory=$False)]
	[String]$TempDeploymentFolder = "c:\niteco-deployment\SiteAssets" ,

	[Parameter(Mandatory=$False)]
	[Switch]$Checkin,
	[Parameter(Mandatory=$False)]
	[Switch]$O365
)

#[CmdletBinding()]
#param(
#[Parameter(Mandatory=$True,Position=1)]
#[String]$UserName,
#[Parameter(Mandatory=$True,Position=2)]
#[String]$Password,
#[Parameter(Mandatory=$True, Position=3)]
#[String]$SiteURL,
#[Parameter(Mandatory=$True, Position=4)]
#[String]$DocLibName,
#[Parameter(Mandatory=$True, Position=5)]
#[String]$Folder,
#[Parameter(Mandatory=$False, Position=6)]
#[Switch]$Checkin,
#[Parameter(Mandatory=$False, Position=7)]
#[Switch]$O365
#)


. .\01-Check-SharePointContext.ps1


<#
    Define Functions
#>


function FolderExists($List, $FolderName) {




#	public static int GetFolderCS(ClientContext clientContext, String listTitle, String folderName)
#        {
#            int existingFolder = 0;
 
#            Web web = clientContext.Web;
#            ListCollection lists = web.Lists;
 
#            List list = web.Lists.GetByTitle(listTitle);
 
#            if (list != null)
#            {
#                FolderCollection folders = list.RootFolder.Folders;
#                clientContext.Load(folders, fl => fl.Include(ct => ct.Name).Where(ct => ct.Name == folderName));
#                clientContext.ExecuteQuery();
#                existingFolder = folders.Count();
#            }
 
#            return existingFolder;
#       }

	$Web = $Ctx.Web
	$List = $Web.Lists.GetByTitle($DocLibName)
	$Ctx.Load($Web)
	$Ctx.Load($List)
	$Ctx.load($List.RootFolder.Folders)
	$Ctx.ExecuteQuery()



	$TempFolder= $List.RootFolder.Folders.add($TargetFolderName)
	$Ctx.load($TempFolder)
	$Ctx.ExecuteQuery()


	#$TempFolder = $Web.GetFolderByServerRelativeUrl($Web.ServerRelativeUrl + "/SiteAssets")
	#Write-Host $TempFolder
	#Write-Host $Web.ServerRelativeUrl + "/SiteAssets"
	#$Ctx.Load($List)
	#$Ctx.Load($TempFolder)
	#$Ctx.ExecuteQuery()



}



<#
    Upload File - This function performs the actual file upload
#>
function UploadFile($DestinationFolder, $File)
{
    #Get the datastream of the file, assign it to a variable
    $FileStream = New-Object IO.FileStream($File.FullName,[System.IO.FileMode]::Open)

    #Create an instance of a FileCreationInformation object
    $FileCreationInfo = New-Object Microsoft.SharePoint.Client.FileCreationInformation

    #Indicate whether or not you would like to overwrite files in the event of a conflict
    $FileCreationInfo.Overwrite = $True

    #Make the datastream of the file you wish to create equal to the datastream of the source file 
    $FileCreationInfo.ContentStream = $FileStream

    #Make the URL of the file equal to the $File variable which was passed to the function.  This will be equal to the source file name
    $FileCreationInfo.url = $File

    #Add the file to the destination folder which was passed to the function, using the FileCreationInformation supplied.  Assign this to a variable so that it can be loaded into context.
    $Upload = $DestinationFolder.Files.Add($FileCreationInfo)
    if($Checkin)
    {
        $Ctx.Load($Upload)
        $Ctx.ExecuteQuery()
        if($Upload.CheckOutType -ne "none")
        {
            $Upload.CheckIn("Checked in by Administrator", [Microsoft.SharePoint.Client.CheckinType]::MajorCheckIn)
        }
    }
    $Ctx.Load($Upload)
    $Ctx.ExecuteQuery()
	$FileStream.Dispose()
}

<#
    Create Folder Function.
#>
function PopulateFolder($ListRootFolder, $FolderRelativePath)
{
    #split the FolderRelativePath passed into chunks (between the backslashes) so that we can check if the folder structure exists
    $PathChunks = $FolderRelativePath.substring(1).split("\")

    #Make sure we start with a fresh WorkingFolder for every folder passed to the function
    if($WorkingFolder)
    {
        Remove-Variable WorkingFolder
    }

    #Start with the root folder of the list, load this into context
    $WorkingFolder = $ListRootFolder
    $Ctx.load($WorkingFolder)
    $Ctx.ExecuteQuery()

    #Load the folders of the current working folder into context
    $Ctx.load(($WorkingFolder.folders))
    $Ctx.executeQuery()

    #Set the FileSource folder equal to the absolute path of the folder that passed to the function
    $FileSource = $TempDeploymentFolder + $FolderRelativePath
    
    #Loop through the folder chunks, ensuring that the correct folder hierarchy exists in the destination
    foreach($Chunk in $PathChunks)
    {
        #Check to find out if a subfolder exists in the current folder that matches the patch chunk being evaluated
        if($WorkingFolder.folders | ? {$_.name -eq $Chunk})
        {
            #Log the status to the PowerShell host window
            Write-Host "Folder $Chunk Exists in" $WorkingFolder.name -ForegroundColor Green

            #Since we will be evaluating other chunks in the path, set the working folder to the current folder and load this into context.
            $WorkingFolder = $WorkingFolder.folders | ? {$_.name -eq $Chunk}
            $Ctx.load($WorkingFolder)
            $Ctx.load($WorkingFolder.folders)
            $Ctx.ExecuteQuery()

        }
        else
        {
            #If the folder doesn't exist, Log a message indicating that the folder doesn't exist, and another message indicating that it is being created
            Write-Host "Folder $Chunk Does Not Exist in" $WorkingFolder.name -ForegroundColor Yellow
            Write-Host "Creating Folder $Chunk in" $WorkingFolder.name -ForegroundColor Green
            
            #Load the working folder into context and create a subfolder with a name equal to the chunk being evaluated, and load this into context
            $Ctx.load($WorkingFolder)
            $Ctx.load($WorkingFolder.folders)
            $Ctx.ExecuteQuery()
            $WorkingFolder= $WorkingFolder.folders.add($Chunk)
            $Ctx.load($WorkingFolder)
            $Ctx.load($WorkingFolder.folders)
            $Ctx.ExecuteQuery()
            
        }

    }

    #Folder is confirmed existing or created - now it's time to list all files in the source folder, and assign this to a variable
    $FilesInFolder = Get-ChildItem -Path $FileSource | ? {$_.psIsContainer -eq $False}
    
    #For each file in the source folder being evaluated, call the UploadFile function to upload the file to the appropriate location
    Foreach ($File in ($FilesInFolder))
    {

        #Notify the operator that the file is being uploaed to a specific location
        Write-Host "Uploading file " $file.Name "to" $WorkingFolder.name -ForegroundColor Cyan

        #Upload the file
        UploadFile $WorkingFolder $File

    }   
}




#Connection
#$password = Read-Host -Prompt "Please enter your password" -AsSecureString
#$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($TenantUrl + $SiteUrl)
#if($O365)
#{
#    $creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($DeploymentUser,$password)
#}
#else
#{
#    $creds = New-Object System.Net.NetworkCredential($DeploymentUser, (ConvertTo-SecureString $password -AsPlainText -Force))
#}
#$Ctx.Credentials = $creds


<#
    Retrieve the library, and load it into the context
#>

robocopy $Folder $TempDeploymentFolder /E

$Web = $Ctx.Web
$List = $Web.Lists.GetByTitle($DocLibName)
$Ctx.Load($Web)
$Ctx.Load($List)
$Ctx.load($List.RootFolder.Folders)
$Ctx.ExecuteQuery()



$TempFolder= $List.RootFolder.Folders.add($TargetFolderName)
$Ctx.load($TempFolder)
$Ctx.ExecuteQuery()


#$TempFolder = $Web.GetFolderByServerRelativeUrl($Web.ServerRelativeUrl + "/SiteAssets")
#Write-Host $TempFolder
#Write-Host $Web.ServerRelativeUrl + "/SiteAssets"
#$Ctx.Load($List)
#$Ctx.Load($TempFolder)
#$Ctx.ExecuteQuery()

#Get a recursive list of all folders beneath the folder supplied by the operator
#$AllFolders = Get-ChildItem -Recurse -Path $Folder |? {$_.psIsContainer -eq $True}

Write-Host $TempDeploymentFolder
Write-Host $Folder

$AllFolders = Get-ChildItem -Recurse -Path $TempDeploymentFolder |? {$_.psIsContainer -eq $True}

#Get a list of all files that exist directly at the root of the folder supplied by the operator
#$FilesInRoot = Get-ChildItem -Path $Folder | ? {$_.psIsContainer -eq $False}

#Upload all files in the root of the folder supplied by the operator
#Foreach ($File in ($FilesInRoot))
#{

#    #Notify the operator that the file is being uploaded to a specific location
#    Write-Host "Uploading file " $File.Name "to" $DocLibName -ForegroundColor Cyan

#    #Upload the file
#    UploadFile($list.RootFolder) $File
    

#}
#Loop through all folders (recursive) that exist within the folder supplied by the operator
foreach($CurrentFolder in $AllFolders)
{
    #Set the FolderRelativePath by removing the path of the folder supplied by the operator from the fullname of the folder
    #$FolderRelativePath = ($CurrentFolder.FullName).Substring($Folder.Length)
	$FolderRelativePath = ($CurrentFolder.FullName).Substring($TempDeploymentFolder.Length)
    
    #Call the PopulateFolder function for the current folder, which will ensure that the folder exists and upload all files in the folder to the appropriate location
    #PopulateFolder ($list.RootFolder) $FolderRelativePath
	PopulateFolder ($TempFolder) $FolderRelativePath
}