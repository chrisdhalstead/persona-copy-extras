# persona-copy-extras

Chris Halstead / Josh Spencer - VMware <br />
This script is provided as-is and there is no support

Version 2.0 - July 14 2020

------

### Overview

This script is used to copy all data contained in a VMware Horizon Persona Management environment that is stored in non-standard folder.  The folders managed by VMware Horizon Persona Management are detailed here: 

https://docs.vmware.com/en/VMware-Horizon-7/7.12/horizon-architecture-planning/GUID-05B1BE12-8DD2-4EAE-A3E2-B52CDB6DFC32.html

We can copy these standard folders locally using a group policy setting, but any extra folders and files are not copied locally.  The local profile will use either an VMware App Volumes Writable Volume or an FSLogix Profile Container.  This script will copy any non standard folders/files from the VMware Horizon Persona Management to this local profile location.  This will allow migration away from VMware Horizon Persona Management.  

### Usage

1. Move the `copy-persona-extras.ps1` file to the location you want to run the script from.   A log file will be created for each user showing what is happening at each logon.  Make sure the users have the ability to execute PowerShell scripts - [read more here](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7)

2. Edit the script to point to the location of the Persona Management share

   ![configurepm](https://github.com/chrisdhalstead/persona-copy-extras/blob/master/Images/configurepm.png)
   
   Example:  `$PMpath = **"\\\fqdnoffileserver\share\"** + $un + ".v6"``
   
3. Use Dynamic Environment Manager to execute the script

   ![dem](https://github.com/chrisdhalstead/persona-copy-extras/blob/master/Images/dem.png)

   Example:  Command: `powershell.exe \\fs1\horizonscripts\copy-persona-extras.ps1`
   Example:  Check `Run asynchronously`- this will make sure the script runs in the background and does not impact the logon process

   Note:  if the script has already run for the user it will not copy any data if the `ce-flag.txt` file exists on the root of the users Persona Management profile.  Simply delete that flag file to allow the script to copy data again.

4. The script will evaluate the persona profile and copy any folders / files that are not in 

5. When scripts runs, a folder will be created in the users My Documents folder called `"ExtrasFromPersona"`
   ![ExtrasFolder](https://github.com/chrisdhalstead/persona-copy-extras/blob/master/Images/ExtrasFolder.PNG)

6. When the script executes - all folders and files not in the standard folders managed by Persona Management will be copied to the newly created folder
   ![stdfolders](https://github.com/chrisdhalstead/persona-copy-extras/blob/master/Images/stdfolders.png)

7. When the script is done  - all of the extra files will be located in the new folder
   ![extrasfolderdata](https://github.com/chrisdhalstead/persona-copy-extras/blob/master/Images/extrasfolderdata.PNG)

8. The script will then set a flag file `ce-flag.txt` - the script will see this flag file and skip subsequent copy actions
   ![flag](https://github.com/chrisdhalstead/persona-copy-extras/blob/master/Images/flag.PNG)

9. A log file will be created in /logs under the location where the script is executed - one log file will be created for each user and the latest data will be at the bottom of the log file
   ![logs](https://github.com/chrisdhalstead/persona-copy-extras/blob/master/Images/logs.PNG)
   ![Log-Copy](https://github.com/chrisdhalstead/persona-copy-extras/blob/master/Images/Log-Copy.png)

   ![Log-Same](https://github.com/chrisdhalstead/persona-copy-extras/blob/master/Images/Log-Same.png)

   
