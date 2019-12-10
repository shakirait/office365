[CmdletBinding()]
Param(
	#[Parameter(Mandatory=$false)][string] $BuildDestinationFolder ="d:\into-deployment\"
	[Parameter(Mandatory=$true)]
	[string]$Path,
	[Parameter(Mandatory=$false)]
	[string]$Title,
	[Parameter(Mandatory=$true)]
	[string]$ClientId,
	[Parameter(Mandatory=$true)]
	[string]$RedirectUrl,
	[Parameter(Mandatory=$true)]
	[string]$TargetFilename,
	[Parameter(Mandatory=$true)]
	[string]$RemoteAppUrl,
	[Parameter(Mandatory=$false)]
	[string]$AppManifestReplacementProductId,
	[Parameter(Mandatory=$false)]
	[string]$AppManifestReplacementName
)
BEGIN {
	. .\01-Check-SharePointContext.ps1
}
PROCESS{
	# Open zip file and copy to temporary location
	function Open-Zip
		{
		Param([string]$file, [string]$destination)
 
		$shell = new-object -com shell.application
		if (Test-Path($destination)) {
			Remove-Item $destination -Recurse -Confirm:$false -ea SilentlyContinue
		}
		$out = New-Item -Path $destination -type Directory -ea SilentlyContinue
		$zip = $shell.NameSpace($file)
		foreach($item in $zip.items())
		{
		$shell.Namespace($destination).copyhere($item)
		}
	}
 
	# Rename to ZIP and open the App package 
	$zip = $Path.Replace(".app", ".zip");
	$out = Copy-item $Path -Destination $zip; 
	$zipFolder = $Path.Replace(".app", "\");   
	Open-Zip $zip $zipFolder
 
	# Get the original info
	[xml]$appManifest = Get-Content ($zipFolder + "AppManifest.xml")
	$orgRedirect = $appManifest.App.Properties.StartPage
	$orgRedirect = $orgRedirect.Substring(0, $orgRedirect.LastIndexOf("/"))
	$orgClientId = $appManifest.App.AppPrincipal.RemoteWebApplication.ClientId
	$appManifestName = $appManifest.App.Name
	$appManifestProductId = $appManifest.App.ProductID

	#$title = $appManifest.App.Properties.Title
	if ($Title.Length -eq 0) {
		$title = $appManifest.App.Properties.Title
	} else {
		$title = $Title
	}
 
	# Replace the path and client ID in files
	$redirect = $RedirectUrl
	if ($redirect.EndsWith("/")) {
		$redirect = $redirect.SubString(0, $redirect.length - 1);
	}
 
	# Fetch XML files, i.e. elements and AppManifest
	$files = Get-ChildItem $zipFolder -Recurse -Include *.xml
	foreach ($file in $files)
	{
        
		$elementsSource = "NA"
		Write-Host $file.name
		if($file.name -like "*elements*") {
		[xml]$elementsManifest = Get-Content ($zipFolder + $file.Name)
			$elementsSource = $elementsManifest.Elements.ClientWebPart.Content.Src
			$elementsSource = $elementsSource.split('/')[0,1,2] -join '/'
			#$elementsSource = $elementsSource.Split("/",3)
			#$elementsSource = $elementsSource.Substring(0, $elementsSource.LastIndexOf("/"))
			Write-Host "elementsSource: " + $elementsSource
		}

		$package = [System.IO.Packaging.Package]::Open($zip, [System.IO.FileMode]::Open)
             
		$fileName = ("/" + $file.Name)
		Write-Host "Processing " + $fileName
		$manifestUri = New-Object System.Uri($fileName, [System.UriKind]::Relative)
		$partNameUri = [System.IO.Packaging.PackUriHelper]::CreatePartUri($manifestUri)
		try {
			$part = $package.GetPart($partNameUri)
			$partStream = $part.GetStream()
  
			# Perform replacement
			$reader = New-Object -Type System.IO.StreamReader -ArgumentList $partStream
			$content = $reader.ReadToEnd()
			if($file.name -like "*elements*") {
				$content = $content.Replace($elementsSource, $RemoteAppUrl)
				Write-Host "Source: " + $elementsSource + "RemoteAppUrl: " + $RemoteAppUrl
			}
			else {
				$content = $content.Replace($orgRedirect, $redirect)
				Write-Host "Org Redirect: " + $orgRedirect + "; Redirect: " + $redirect
			}
			$content = $content.Replace($appManifest.App.Properties.Title, $title)
			$content = $content.Replace($orgClientId, $ClientId)
            
			#Update App Name
			if($AppManifestReplacementName -ne "") {
				$content = $content.Replace($appManifestName, $AppManifestReplacementName)
			}
			#Update App Product ID
			if($AppManifestReplacementProductId -ne "") {
				$content = $content.Replace($appManifestProductId, $AppManifestReplacementProductId)
			}

			$partStream.Position = 0
			$partStream.SetLength(0)
  
			$writer = New-Object -TypeName System.IO.StreamWriter -ArgumentList $partStream
			$writer.Write($content)
			$writer.Flush()
		}
		catch { } # Exception occurs on [Content Types].xml for example due to naming. Ignore.
		finally {
			$package.Close()
		}
	}                    
     
	# Clean up and rename
	#Remove-Item $Path -Force
	Remove-Item $zipFolder -Recurse -Force
	#Move-Item $zip $Path
	#New-Item -Force $TargetFilename
	Move-Item $zip $TargetFilename -Force

	#Copy file to target destination (force creation of target if doesn't exist already)
	#New-Item -Force $TargetFilename
	#Copy-Item -Path $Path -Destination $TargetFileName -Recurse -Force
}
END {}