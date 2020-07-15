#########################################################################################
# Script to copy extra data from Persona Management to the Local Documents Directory
# Chris Halstead / Josh Spencer - VMware
# There is NO support for this script - it is provided as is
# 
# Version 2.0 - July 14, 2020
##########################################################################################

#Create Log File
$VbCrLf = “`r`n” 
$un = $env:USERNAME #Local Logged in User
$sComputer = $env:COMPUTERNAME #Local Computername
$sLogName = "copy-extras-$un.log" #Log File Name
$sLogPath = $PSScriptRoot #Current Directory
$sLogPath = $sLogPath + "\Logs"
#Create Log Directory if it doesn't exist
if (!(Test-Path $sLogPath)){New-Item -ItemType Directory -Path $sLogPath -Force}
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName
Add-Content $sLogFile -Value $vbcrlf
$sLogTitle = "Starting Script as $un from $scomputer*************************************"
Add-Content $sLogFile -Value $sLogTitle

##########################################################################################
#UPDATE THIS PATH BEFORE SCRIPT EXECUTION
#Get Persona Manager share path
#Assumes all .v6 profiles
$script:PMpath = "\\fs1.betavmweuc.com\PersonaMgmt\$un.v6"
##########################################################################################

Function Write-Log {
  [CmdletBinding()]
  Param(
  
  [Parameter(Mandatory=$True)]
  [System.Object]
  $Message

  )
  $Stamp = (Get-Date).toString("MM/dd/yyyy HH:mm:ss")
  $Line = "$Stamp $Level $Message"

  $isWritten = $false

  do {
      try {
          Add-Content $sLogFile -Value $Line
          $isWritten = $true
          }
      catch {}
  } until ($isWritten)
     
  }

Function Compare-and-Sync {

#Add standard folders to Arraylist which will be copied by Persona
$alstdfolders = New-Object System.Collections.ArrayList
$alstdfolders.add("AppData(Roaming)")
$alstdfolders.add("Desktop")
$alstdfolders.add("Documents")
$alstdfolders.add("Pictures")
$alstdfolders.add("Music")
$alstdfolders.add("Videos")
$alstdfolders.add("Favorites")
$alstdfolders.add("Contacts")
$alstdfolders.add("Downloads")
$alstdfolders.add("Links")
$alstdfolders.add("Searches")
$alstdfolders.add("Saved Games")

#Get remote folders
$arrRemoteFolders = New-Object System.Collections.ArrayList
$arrRemoteFolders = Get-ChildItem $script:PMpath | Where-Object {$_.PSIsContainer} | Foreach-Object {$_.Name}

#Compare lists and get extra folders
$extrafolders = Compare-Object -ReferenceObject $arrRemoteFolders -DifferenceObject $alstdfolders -PassThru

#Show extra remote folders
$extraremotefolders = New-Object System.Collections.ArrayList
$extraremotefolders = $extrafolders | ?{ $_.SideIndicator -eq '<='}

#Set path to copy the extra files to
$CopyPath = [Environment]::GetFolderPath("MyDocuments")+"\ExtrasFromPersona"

#Log Persona paths
Write-Log -Message "Persona Management Path: $script:PMpath"

#Create destination Folder
if (!(Test-Path $CopyPath)){ New-Item -ItemType Directory -Path $copypath}

#Process Persona Folder Root
Get-ChildItem -Path $script:PMpath -File | % {Copy-Item $_.fullname "$copypath" -Recurse -Force } 
write-log -message "Copying Files from Persona Root"

#Process Extra Folders
ForEach ($extrafiles in $extraremotefolders)

{
    
  if (!(Test-Path "$copypath\$extrafiles")) {New-Item -ItemType Directory -Path "$copypath\$extrafiles" -Force}
  $sdestpath = "$copypath\$extrafiles"
  Get-ChildItem -Path $script:PMpath"\"$extrafiles | % {Copy-Item $_.fullname "$sdestpath" -Recurse -Force } 
  write-log -message "Copying Extra Folders / Files to: $sdestpath"

}

#Add Flad to Persona Directory to indiate the directories match  
out-file $script:PMPath"\ce-flag.txt"
write-log -Message "Writing flag file and exiting"
Write-Log -Message "Finishing Script******************************************************"

}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Write-Log -Message "Starting Execution of Script******************************************"

#Check if the flag file on the Persona Management Share - if it does exit
if (Test-Path $script:PMpath"\ce-flag.txt")
{
  
  Write-Log -Message "Flag file foung Finishing Script***********************************************"

}
else {

  if(test-path $script:PMpath)
    {
        Write-Log -Message "Found the Persona Folder - Starting Copy"
        #Copy data
        Compare-and-Sync

    }
  else 
    {
      Write-Log -Message "Persona Folder Not Found - Exiting"
      Write-Log -Message "Finishing Script***********************************************"

    }
  
}



