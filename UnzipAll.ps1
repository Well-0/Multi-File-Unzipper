param (
    [string]$folderPath
)

# Append a ` only before [ and ] chars
$folderPath = $folderPath -replace '(\[|\])', '`$1'

if (-not $folderPath) {
    $folderPath = Read-Host "Enter the folder path to extract .zip files"
}
 
Write-Output "Modified folder path: $folderPath"


# Prompt for folder path if not provided


# Recursively get all .zip files in the specified folder and subfolders
$zipFiles = Get-ChildItem -Path "$folderPath" -Filter *.zip -Recurse

if ($zipFiles.Count -eq 0) {
    Write-Output "No .zip files found in the directory: $folderPath"
    Start-Sleep -Seconds 2
    exit
}

foreach ($zipFile in $zipFiles) {
    # Create a new directory for extraction using the base name of the zip file
    #$baseName = [System.IO.Path]::GetFileNameWithoutExtension($zipFile.Name)
 
    #Join-Path -Path $zipFile.DirectoryName -ChildPath $baseName
    try {
        Write-Output "`nExtracting $($zipFile.FullName) to "

        $ExtractedFolderPath = $zipFile.FullName -replace ".zip$"

        Write-Output "`nPrepping folder: $ExtractedFolderPath  "
        
        $ExtractedFolderName = Split-Path -Path $ExtractedFolderPath -Leaf  
        Write-Output "`nExtracted folder path: $ExtractedFolderName"

        #$destinationPath = Join-Path -Path $folderPath -ChildPath $ExtractedFolderPath 

                # Create the destination directory if it doesn't exist
      

        #Out null -> to suppress the output

        #  extract the zip file
        #Expand-Archive -Path $zipFile -DestinationPath $destinationPath -Force

        # Extract the zip file and overwrite existing files
        Expand-7Zip -ArchiveFileName $zipFile.FullName -TargetPath $ExtractedFolderPath 
        

       #Add-Type -AssemblyName System.IO.Compression.FileSystem
       #[System.IO.Compression.ZipFile]::ExtractToDirectory($zipFile.FullName, "$folderPath\$ExtractedFolderName") 
        



        Write-Output "Extraction completed."

        $extractedItems = Get-ChildItem -Path $destinationPath -Recurse
        Write-Output "Extracted $(($extractedItems | Measure-Object).Count) items"

        if (($extractedItems | Measure-Object).Count -eq 0) {
            Write-Output "WARNING: No files found in extracted directory!"
        } else {
            Write-Output "Successfully extracted to: $destinationPath"
        }
    }
    catch {
        $errorLineNumber = $_.InvocationInfo.ScriptLineNumber
        $scriptFilePath = $_.InvocationInfo.ScriptName
        $errorLine = (Get-Content -Path $scriptFilePath)[$errorLineNumber - 1]
    
        Write-Output "ERROR extracting $($zipFile.FullName): $($_.Exception.Message)"
        Write-Output "Error occurred at line $errorLineNumber : $errorLine"
    }
}
Write-Output "Extraction completed."
Start-Sleep -Seconds 2
#D:\`[GigaCourse.Com`] Udemy - The Complete 2024 Web Development Bootcamp\04 - Multi-Page Websites
#e.g zip file names Jessie.zip , walter.zip , etc
