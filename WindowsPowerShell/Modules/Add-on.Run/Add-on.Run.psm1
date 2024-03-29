#######################################################################################################################
# File:             Add-on.Run.psm1                                                                                   #
# Author:           Shay Levy                                                                                         #
# Publisher:        ScriptFanatic http://blogs.microsoft.co.il/blogs/ScriptFanatic/                                                                                    #
# Copyright:        © 2010 ScriptFanatic. All rights reserved.                                                        #
# Usage:            To load this module in your Script Editor:                                                        #
#                   1. Open the Script Editor.                                                                        #
#                   2. Select "PowerShell Libraries" from the File menu.                                              #
#                   3. Check the Add-on.Run module.                                                                   #
#                   4. Click on OK to close the "PowerShell Libraries" dialog.                                        #
#                   Alternatively you can load the module from the embedded console by invoking this:                 #
#                       Import-Module -Name Add-on.Run                                                                #
#                   Please provide feedback on the PowerGUI Forums.                                                   #
#######################################################################################################################


Set-StrictMode -Version 2


#region Initialize the Script Editor Add-on.

if ($Host.Name –ne 'PowerGUIScriptEditorHost') { return }
if ($Host.Version -lt '2.1.1.1202') {
	[System.Windows.Forms.MessageBox]::Show("The ""$(Split-Path -Path $PSScriptRoot -Leaf)"" Add-on module requires version 2.1.1.1202 or later of the Script Editor. The current Script Editor version is $($Host.Version).$([System.Environment]::NewLine * 2)Please upgrade to version 2.1.1.1202 and try again.","Version 2.1.1.1202 or later is required",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
	return
}

$se = [Quest.PowerGUI.SDK.ScriptEditorFactory]::CurrentInstance

#endregion

#Create the RunCode command. 
if (!$se.Commands['Tools.RunCode']) 
{
	$ic = New-Object Quest.PowerGUI.SDK.ItemCommand 'ToolsCommand','RunCode'
	$ic.Text = '&Run Code'
	
	if($StartDebuggingCommand = $se.Commands['DebugCommand.StartDebugging'])
	{
		$ic.Image = $StartDebuggingCommand.Image  
	}
	
	$ic.AddShortcut('F5')	
	$ic.ScriptBlock = {

		$doc = $se.CurrentDocumentWindow.Document

		if($doc.SelectedText -eq [string]::Empty)
		{
			$se.Commands['DebugCommand.StartDebugging'].Invoke()	
		}
		else
		{
			$se.Commands['DebugCommand.ExecuteSelection'].Invoke()
		}
	}

	$se.Commands.Add($ic)
}


#Create the RunCode menu item in the Tools menu. 
if (($ToolsMenu = $se.Menus['MenuBar.Tools']) -and !$ToolsMenu.Items['Tools.RunCode'])
{ 
	$ToolsMenu.Items.Add($ic)
} 

if($RunCommand = $se.Menus['MenuBar.Tools'].Items['Tools.RunCode'])
{
	$RunCommand.FirstInGroup = $true 
}



#region Clean-up the Add-on when it is removed.

$ExecutionContext.SessionState.Module.OnRemove = {

	#Remove the RunCode menu item in the Tools menu. 
	if (($ToolsMenu = $se.Menus['MenuBar.Tools']) -and ($RunCodeMenuItem=$ToolsMenu.Items['ToolsCommand.RunCode'])) 
	{ 
		$null = $ToolsMenu.Items.Remove($RunCodeMenuItem)
	} 
 
	#Remove the RunCode command. 
	if ($RunCodeCommand = $se.Commands['ToolsCommand.RunCode']) 
	{ 
		$null = $se.Commands.Remove($RunCodeCommand)
	}
}

#endregion
