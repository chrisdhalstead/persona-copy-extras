# persona-copy-extras

Chris Halstead / Josh Spencer - VMware <br />
This script is provided as-is and there is no support

Version 2.0 - July 14 2020

------

### Overview

This script is used to copy all data contained in a VMware Horizon Persona Management environment that is stored in non-standard folder.  The folders managed by VMware Horizon Persona Management are detailed here: 

https://docs.vmware.com/en/VMware-Horizon-7/7.12/horizon-architecture-planning/GUID-05B1BE12-8DD2-4EAE-A3E2-B52CDB6DFC32.html

We can copy these standard folders locally using a group policy setting, but any extra folders and files are not copied locally.  The local profile will use either an VMware App Volumes Writable Volume or an FSLogix Profile Container.  This script will copy any non standard folders/files from the VMware Horizon Persona Management to this local profile location.  This will allow the migration away from VMware Horizon Persona Management.  This script should be run over a period of time to capture the changed then turn off at the cutover period.

### Usage

1. Move the `copyextras.ps1` file to the location you want to run the script from.   A log file will be created at this location for each user showing what is happening at each logon

`$PMpath = "\\fqdnoffileserver\share\" + $un + ".v6"`

<img src="Images/DEM-Logon-Task.png" width="500" />





<img src="Images\Log-Copy.png" width="1500" />



<img src="Images\Log-Same.png" width="1500" />

### Change Log











