function Install-Program {

  [CmdletBinding()]
  param (
      [Parameter(Mandatory=$false)]
      [array]$ProgramsArray=@("Chrome","Skype","AdobeReader","LightShot"),
      [Parameter(Mandatory=$true)]
      [ValidateSet("Chrome","Skype","AdobeReader","LightShot","All")]
      [string]$ProgramName,
      [Parameter(Mandatory=$false)]
      [string]$DownloadFolder="$env:TEMP\"
  )
      Write-Host "Set parameters to install $ProgramName"
      $Programs=@()
      $executionFiles=@()
      if ($ProgramName -eq "All") {
          $Programs=$ProgramsArray
      }
      else {
          $Programs=$ProgramName
      }

      foreach ($Program in $Programs) {
          switch -Wildcard ($Program) {
              Chrome { 
                  $url = "http://dl.google.com/chrome/install/375.126/chrome_installer.exe";
                  $executionFile = "ChromeSetup.exe";
                  $arguments = "/silent /install";
              }
              Skype { 
                  $url = "http://www.skype.com/go/getskype-full";
                  $executionFile = "skype.exe";
                  $arguments = "/VERYSILENT /SP- /NOCANCEL /NORESTART /SUPPRESSMSGBOXES /NOLAUNCH";
              }
              AdobeReader { 
                  $url = "https://admdownload.adobe.com/rdcm/installers/live/readerdc64.exe";
                  $executionFile = "readerdc_ru_xa_cra_install.exe";
                  $arguments = "/i $DownloadFolder/$executionFile /qn /sAll /rs /l /msi /qb- /norestart EULA_ACCEPT=YES REMOVE_PREVIOUS=YES DISABLE_ARM_SERVICE_INSTALL=1 UPDATE_MODE=0";
              }
              LightShot { 
                  $url = "https://app.prntscr.com/build/setup-lightshot.exe";
                  $executionFile = "setup-lightshot.exe";
                  $arguments = "/SILENT";
              }
          }

          Write-Verbose "URL value: $url"
          Write-Verbose "Execution file: $executionFile"
          Write-Verbose "Installation arguments: $arguments"

          Write-Host "Starting download of $Program"
          $destinationPath = "$("{0}{1}" -f $DownloadFolder, $executionFile)"
          # Invoke-WebRequest -Uri $url -OutFile $destinationPath
          $WebClient = New-Object System.Net.WebClient
          $WebClient.DownloadFile($url, $destinationPath)

          Write-Host "Starting $Program installation"
          try {
              Start-Process -FilePath $DestinationPath -ArgumentList $arguments -Wait
              if ($? -eq $true){
                Write-Host "Installation completed"
              }
          }
          catch {
              $Error[0].Exception; Continue
          }
          $executionFiles+=$executionFile
      }
      
  return $destinationPath, $executionFiles
}

function Remove-Artifacts {

  [CmdletBinding()]
  param (

     [Parameter(Mandatory=$true)]
     [array]$executionFile,
     [Parameter(Mandatory=$true)]
     [string]$destinationPath

  )
    Write-Host "Checking path $destinationPath"
    $files=@()
    foreach ($file in $executionFiles){
        $item = Get-ChildItem -Path $destinationPath | Where-Object -Property FullName -Match $executionFile
        if ($null -ne $item) {
            Write-Host "Found match file $item"
            Write-Host "Removing $item"
            Remove-Item -Path $item
            if ($? -eq $true){
                $files+=$item
            }
        }
        else {
          Write-Host "No matches with $file"
        }
    }
    if ($? -eq $true){
      Write-Host "Files: $files were removed"
    }
}  

$destinationPath, $executionFiles = Install-Program -ProgramName All -DownloadFolder "D:/" -Verbose 

# Remove-Artifacts -executionFiles $executionFiles -destinationPath $destinationPath