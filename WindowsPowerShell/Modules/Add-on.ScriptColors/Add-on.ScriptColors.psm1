#######################################################################################################################
# File:             Add-on.ScriptColors.psm1                                                                          #
# Author:           Denniver Reining                                                                                  #
# Publisher:        www.bitspace.de                                                                                   #
# Copyright:        © 2010 www.bitspace.de. All rights reserved.                                                      #
# Usage:            To load this module in your Script Editor:                                                        #
#                   1. Open the Script Editor.                                                                        #
#                   2. Select "PowerShell Libraries" from the File menu.                                              #
#                   3. Check the Add-on.ScriptColors module.                                                          #
#                   4. Click on OK to close the "PowerShell Libraries" dialog.                                        #
#                   Alternatively you can load the module from the embedded console by invoking this:                 #
#                       Import-Module -Name Add-on.ScriptColors                                                       #
#                   Please provide feedback on the PowerGUI Forums.                                                   #
#######################################################################################################################

Set-StrictMode -Version 2

#region Initialize the Script Editor Add-on.

if ($Host.Name –ne 'PowerGUIScriptEditorHost') { return }
if ($Host.Version -lt '2.2.0.1358') {
	[System.Windows.Forms.MessageBox]::Show("The ""$(Split-Path -Path $PSScriptRoot -Leaf)"" Add-on module requires version 2.2.0.1358 or later of the Script Editor. The current Script Editor version is $($Host.Version).$([System.Environment]::NewLine * 2)Please upgrade to version 2.2.0.1358 and try again.","Version 2.2.0.1358 or later is required",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
	return
}

$pgse = [Quest.PowerGUI.SDK.ScriptEditorFactory]::CurrentInstance

#endregion

#region Load resources from disk.

$iconLibrary = @{
	# TODO: Load icons into this table.
	ScriptColorsIcon16 = New-Object System.Drawing.Icon -ArgumentList "$PSScriptRoot\Resources\Scriptcolors.ico",16,16
	ScriptColorsIcon32 = New-Object System.Drawing.Icon -ArgumentList "$PSScriptRoot\Resources\Scriptcolors.ico",32,32
}

$imageLibrary = @{
	# TODO: Load images into this table.
	ScriptColorsImage16 = $iconLibrary['ScriptColorsIcon16'].ToBitmap()
	ScriptColorsImage32 = $iconLibrary['ScriptColorsIcon32'].ToBitmap()
}

#endregion



#region Variables
  $scriptpath = "`""+(Split-Path -parent $MyInvocation.MyCommand.Definition)+"\colman.ps1"+"`""
#endregion


#region Create the SnipMan Console command. 

 function elevateprocess {
                $file, [string]$arguments = $args;
                $psi = new-object System.Diagnostics.ProcessStartInfo $file;
                $psi.Arguments = $arguments;
				if ([System.Environment]::OSVersion.Version.Major -gt 5) {
                $psi.Verb = "runas";}	
                $psi.WorkingDirectory = get-location;
                [void][System.Diagnostics.Process]::Start($psi);
}
 
if (-not ($ScriptColorsCommand = 
$pgse.Commands['ViewCommand.ScriptColors'])) { 
  $ScriptColorsCommand = New-Object -TypeName Quest.PowerGUI.SDK.ItemCommand -ArgumentList 'ViewCommand','ScriptColors' 
  $ScriptColorsCommand.Text = 'E&dit Script Colors' 
  $ScriptColorsCommand.Image = $imageLibrary['ScriptColorsImage16'] 
  $ScriptColorsCommand.ScriptBlock = { 
	
  	#Region - SnipMan Scriptblock-
    elevateprocess "$env:windir\system32\WindowsPowerShell\v1.0\powershell.exe" '-noprofile' '-windowstyle hidden' '-STA' '-File' $scriptpath
  	#endregion 

  } 
 
  $pgse.Commands.Add($ScriptColorsCommand) 
} 
 
#endregion 

#region Create the ScriptColors Console menu item in the View menu. 
 
if (($viewMenu = $pgse.Menus['MenuBar.View']) -and  (-not ($ScriptColorsMenuItem = $viewMenu.Items['ViewCommand.ScriptColors']))) { 
  $viewMenu.Items.Add($ScriptColorsCommand) 
  if ($ScriptColorsMenuItem = $viewMenu.Items['ViewCommand.ScriptColors']) { 
  $ScriptColorsMenuItem.FirstInGroup = $true 
  } 
} 
 
#endregion 
 
#region Clean-up the Add-on when it is removed. 
 
$ExecutionContext.SessionState.Module.OnRemove = { 
		$pgse = [Quest.PowerGUI.SDK.ScriptEditorFactory]::CurrentInstance 

		#region Remove the ScriptColors Console menu item from the View menu. 

		if (($viewMenu = $pgse.Menus['MenuBar.View']) -and  ($ScriptColorsMenuItem = $viewMenu.Items['ViewCommand.ScriptColors'])) { 
			$viewMenu.Items.Remove($ScriptColorsMenuItem) | Out-Null 
		} 

		#endregion 

		#region Remove the ScriptColors Console command. 

		if ($ScriptColorsCommand = $pgse.Commands['ViewCommand.ScriptColors']) { 
			$pgse.Commands.Remove($ScriptColorsCommand) | Out-Null 
		} 

		#endregion 
} 
 
#endregion 
