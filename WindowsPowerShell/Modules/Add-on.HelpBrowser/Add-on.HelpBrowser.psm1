#######################################################################################################################
# File:             Add-on.HelpBrowser.psm1                                                                           #
# Author:           Gyorgy Nemesmagasi                                                                                #
# Publisher:                                                                                                          #
# Copyright:        © 2010 . All rights reserved.                                                                     #
# Usage:            To load this module in your Script Editor:                                                        #
#                   1. Open the Script Editor.                                                                        #
#                   2. Select "PowerShell Libraries" from the File menu.                                              #
#                   3. Check the Add-on.HelpBrowser module.                                                           #
#                   4. Click on OK to close the "PowerShell Libraries" dialog.                                        #
#                   Alternatively you can load the module from the embedded console by invoking this:                 #
#                       Import-Module -Name Add-on.HelpBrowser
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

$HelpBrowserIconLibrary = @{
	# TODO: Load icons into this table.
	#       eg. HelpBrowserIcon16 = New-Object System.Drawing.Icon -ArgumentList "$PSScriptRoot\Resources\HelpBrowser.ico",16,16
	#           HelpBrowserIcon32 = New-Object System.Drawing.Icon -ArgumentList "$PSScriptRoot\Resources\HelpBrowser.ico",32,32	
}

$HelpBrowserImageLibrary = @{
	# TODO: Load images into this table.
	#       eg. HelpBrowserImage16 = $iconLibrary['HelpBrowserIcon16'].ToBitmap()
	#           HelpBrowserImage32 = $iconLibrary['HelpBrowserIcon32'].ToBitmap()
}

#Load the treenodes' icons
$HelpIcon = New-Object System.Drawing.Icon -ArgumentList "$PSScriptRoot\Resources\Help.ico",16,16
$AliasIcon = New-Object System.Drawing.Icon -ArgumentList "$PSScriptRoot\Resources\Alias.ico",16,16
$CmdletIcon = New-Object System.Drawing.Icon -ArgumentList "$PSScriptRoot\Resources\Cmdlet.ico",16,16

#Construct the treeview's image list
$HelpBrowserImageList = New-Object -TypeName System.Windows.Forms.ImageList
$HelpBrowserImageList.Images.Add('HelpIcon', $HelpIcon.ToBitmap())
$HelpBrowserImageList.Images.Add('AliasIcon', $AliasIcon.ToBitmap())
$HelpBrowserImageList.Images.Add('CmdletIcon', $CmdletIcon.ToBitmap())

#endregion


#Set to $true if you like to obtain all the help text during load the module
$PreLoadHelpText = $false
#Size of the floatin Help Panel
$HelpPanelHeigh = 500
$HelpPanelWidth = 430
$HelpTextWidth = 80

#region Create Help Browser Panel

#region Define functions for TreeView control

	function AddNode {
		param(
			$Parent,
			$NodeName,
			$NodeText,
			$NodeImageIndex
		)
		$script:node = New-Object -TypeName System.Windows.Forms.TreeNode
		$node.Name = $NodeName
		$node.Text = $NodeText
		$node.ImageIndex = $NodeImageIndex
		$node.SelectedImageIndex = $NodeImageIndex
		$Parent.Nodes.Add($node)
	}
	
#endregion

#region Create the control that will appear in the dockable window.

#region Build the help tree
# TODO: Replace this with a definition for the control that you want to appear in the dockable window
$helpBrowser = New-Object System.Windows.Forms.TreeView
$helpBrowser.ImageList = $HelpBrowserImageList

#Construct the help about nodes
AddNode $helpBrowser 'About' 'About' 0
Get-Help about | ForEach-Object { AddNode $helpBrowser.Nodes[0] $_.Name $_.Name 0 }

#Construct the help Alias nodes
AddNode $helpBrowser 'Alias' 'Alias' 1
Get-Alias | ForEach-Object {
  AddNode $helpBrowser.Nodes[1] $_.Name ($_.Name + '  ('  + $_.ResolvedCommandName + ')')  1
}

#Construct the help Cmdlet nodes
AddNode $helpBrowser  'Cmdlet' 'Cmdlet' 2
Get-Command -CommandType Cmdlet | ForEach-Object {
	$CmdNodeText = $_.Name
	#Add the refered cmdlets to the text
	if (get-alias -Definition $_.Name -ErrorAction SilentlyContinue) {
		$CmdNodeText  +=  "  ("+ [string]::join(" ,", (get-alias -Definition $_.Name -ErrorAction SilentlyContinue | ForEach-Object {$_.Name}) ) + ")"	
	}	
	AddNode $helpBrowser.Nodes[2] $_.Name $CmdNodeText 2
}
#endregion

#region Add NodeMouseClick event
#Add the node click event. It updates the help panel with the help text based on the selected node
$helpBrowser.Add_NodeMouseClick( [System.Windows.Forms.TreeNodeMouseClickEventHandler] { param($sender, $e)
	#Do nothing if it is a left click or the refered node is top level one
	if (($e.Button -ne [System.Windows.Forms.MouseButtons]::Left) -or
		 ($e.Node.Level -ne 1)) {
		return
	}	
	
	#Check the help text is already obtained
	if ($e.Node.Tag -eq $null) {
		#Obtain the help about text
		if ($e.Node.Parent.Name -eq 'About') {
			$e.Node.Tag = Get-Help $e.Node.Name  | Out-String -Width $HelpTextWidth
		}
		#Obtain the help text of the alias or the cmdlet 
		else {
			#$e.Node.Tag = Get-Help $e.Node.Name  | Out-String -Width 200
			#Here the Get-Help doesn't work. One workaround is call an external powershell process and save the output to a file
			powershell.exe -OutputFormat Text -command "Get-Help -Name $($e.Node.Name) -Full | Out-File -Width $($HelpTextWidth) $Env:temp\HelpText.txt"
			$e.Node.Tag = [System.String]::Join("`n", (Get-Content -ReadCount 0 "$Env:TEMP\HelpText.txt"))				
		}
	}
	#Update the Help panel
	$HelpWindow.Control.Text = $e.Node.Tag

})
#endregion

#region Add NodeMouseDoubleClick event
#Add the node doubleclick event to the treeview. Double click on the a non about node insert the alias or the cmdlet to the current editor documant
$helpBrowser.add_NodeMouseDoubleClick( [System.Windows.Forms.TreeNodeMouseClickEventHandler] { param($sender, $e)
	#Do nothing if it is a left click or the refered node is top level one or it's chiled of about node
	#or the active tab editor tab document window
	if (($e.Button -ne [System.Windows.Forms.MouseButtons]::Left) -or 
		($e.Node.Level -ne 1) -or ($e.Node.Parent.Name -eq 'About')  -or ($pgSE.CurrentDocumentWindow -eq $null)) {
		return
	}
	
	#Check the current document window contains the SyntaxEditor control
	if (($originalWindowProperty = $pgSE.CurrentDocumentWindow.GetType().GetProperty('OriginalWindow',[System.Reflection.BindingFlags]'NonPublic,Instance')) -and
	    ($originalWindow = $originalWindowProperty.GetValue($pgSE.CurrentDocumentWindow,$null)) -and
	    ($originalWindow | Get-Member -MemberType Property -Name PSControl -ErrorAction SilentlyContinue) -and
	    ($scriptEditorControl = $originalWindow.PSControl) -and 
		($scriptEditorControl.GetType().BaseType.FullName -eq 'ActiproSoftware.SyntaxEditor.SyntaxEditor')) {
			#Insert the selected node's text
			$scriptEditorControl.Document.InsertText([ActiproSoftware.SyntaxEditor.DocumentModificationType]::Typing,$scriptEditorControl.Caret.Offset, $e.Node.Name)
	}
	
})
#endregion

#region Pre-load the help text
#The other work around of the Get-Help problem to enumerate the help text during module loading
#It's very time consuming so disabled by default
if ($PreLoadHelpText) {
	$helpBrowser.Nodes[0].Nodes | ForEach-Object {$_.Tag = Get-Help $_.Name -Full | Out-String -Width $HelpTextWidth }
	$helpBrowser.Nodes[1].Nodes | ForEach-Object {$_.Tag = Get-Help $_.Name -Full | Out-String -Width $HelpTextWidth }
	$helpBrowser.Nodes[2].Nodes | ForEach-Object {$_.Tag = Get-Help $_.Name -Full | Out-String -Width $HelpTextWidth }
}
#endregion

#endregion

#region Create and/or initialize the HelpBrowser dockable window.

if (-not ($HelpBrowserWindow = $pgse.ToolWindows['HelpBrowser'])) {
	$HelpBrowserWindow = $pgse.ToolWindows.Add('HelpBrowser')
	$HelpBrowserWindow.Title = '&Help Browser' -replace '&'
	$HelpBrowserWindow.Control = $helpBrowser
	$HelpBrowserWindow.Control.Parent.CanBecomeDocument = [ActiproSoftware.ComponentModel.DefaultableBoolean]::False
	$HelpBrowserWindow.Control.Parent.Image = $HelpIcon.ToBitmap()	
	$HelpBrowserWindow.Visible = $true
} 
else {
		$HelpBrowserWindow.Control = $helpBrowser
}

#endregion

#region Create a Go menu command to activate the HelpBrowser window.

if (-not ($goToHelpBrowserCommand = $pgse.Commands['GoCommand.HelpBrowser'])) {
	$goToHelpBrowserCommand = New-Object -TypeName Quest.PowerGUI.SDK.ItemCommand -ArgumentList 'GoCommand', 'HelpBrowser'
	$goToHelpBrowserCommand.Text = '&Help Browser'
	$goToHelpBrowserCommand.Image = $HelpIcon.ToBitmap()
	if ($goMenu = $pgse.Menus['MenuBar.Go']) {
		$index = $goMenu.Items.Count + 1
		if ($index -lt 10) {
			$goToHelpBrowserCommand.AddShortcut("Ctrl+${index}")
		}
	}
	$goToHelpBrowserCommand.ScriptBlock = {
		$pgse = [Quest.PowerGUI.SDK.ScriptEditorFactory]::CurrentInstance
		if ($HelpBrowserWindow = $pgse.ToolWindows['HelpBrowser']) {
			$HelpBrowserWindow.Visible = $true
			$HelpBrowserWindow.Control.Invoke([EventHandler]{$HelpBrowserWindow.Control.Parent.Activate($true)})
		}
	}

	$pgse.Commands.Add($goToHelpBrowserCommand)
}

#endregion

#region Add the Go to HelpBrowser command to the Go menu.

if ($goMenu = $pgse.Menus['MenuBar.Go']) {
	$goMenu.Items.Add($goToHelpBrowserCommand)
}

#endregion

#endregion

#region Create Help Panel

	#region Create the control that will appear in the dockable window.

	$HelpControl = New-Object System.Windows.Forms.RichTextBox
	$HelpControl.Text = @"
Help browser

created by Gyorgy Nemesmagasi
© 2010 . All rights reserved.
"@
	
	#endregion

	#region Create and/or initialize the Help dockable window.

	if (-not ($HelpWindow = $pgse.ToolWindows['Help'])) {
		$HelpWindow = $pgse.ToolWindows.Add('Help')
		$HelpWindow.Title = '&Help' -replace '&'
		$HelpWindow.Control = $HelpControl
		$HelpWindow.Visible = $true
		$HelpWindow.Control.Parent.Image = $HelpIcon.ToBitmap()
		#Set the window state, size and reposition
		$HelpWindow.Control.Invoke([EventHandler]{$HelpWindow.Control.Parent.State = 'Floating'})
		$HelpWindow.Control.Invoke([EventHandler]{$HelpWindow.Control.Parent.FloatingSize = New-Object system.Drawing.Size($HelpPanelWidth,$HelpPanelHeigh)})
		$moveHeigh = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Height - $HelpPanelHeigh
		$moveWidth = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width - $HelpPanelWidth
		$HelpWindow.Control.Invoke([EventHandler]{$HelpWindow.Control.Parent.FloatingLocation = New-Object system.Drawing.Size($moveWidth,$moveHeigh)})
		$HelpWindow.Control.Invoke([EventHandler]{$HelpWindow.Control.Parent.Activate($true)})
	} else {
		$HelpWindow.Control = $HelpControl
	}

	#endregion

	#region Create a Go menu command to activate the Help window.

	if (-not ($goToHelpCommand = $pgse.Commands['GoCommand.Help'])) {
		$goToHelpCommand = New-Object -TypeName Quest.PowerGUI.SDK.ItemCommand -ArgumentList 'GoCommand', 'Help'
		$goToHelpCommand.Text = '&Help'
		$goToHelpCommand.Image = $HelpIcon.ToBitmap()
		if ($goMenu = $pgse.Menus['MenuBar.Go']) {
			$index = $goMenu.Items.Count + 1
			if ($index -lt 10) {
				$goToHelpCommand.AddShortcut("Ctrl+${index}")
			}
		}
		$goToHelpCommand.ScriptBlock = {
			$pgse = [Quest.PowerGUI.SDK.ScriptEditorFactory]::CurrentInstance
			if ($HelpWindow = $pgse.ToolWindows['Help']) {
				$HelpWindow.Visible = $true
				$HelpWindow.Control.Invoke([EventHandler]{$HelpWindow.Control.Parent.Activate($true)})
			}
		}

		$pgse.Commands.Add($goToHelpCommand)
	}

	#endregion

	#region Add the Go to Help command to the Go menu.

	if ($goMenu = $pgse.Menus['MenuBar.Go']) {
		$goMenu.Items.Add($goToHelpCommand)
	}

	#endregion

#endregion



#region Clean-up the Add-on when it is removed.

$ExecutionContext.SessionState.Module.OnRemove = {
	$pgse = [Quest.PowerGUI.SDK.ScriptEditorFactory]::CurrentInstance
	
	#region Clean-up the HelpBrowser Panel
	
	#Remove the menu
	if (($goMenu = $pgse.Menus['MenuBar.Go']) -and
	    ($scriptExplorerCmdItem = $goMenu.Items['GoCommand.HelpBrowser'])) {
		$goMenu.Items.Remove($scriptExplorerCmdItem) | Out-Null
	}
	#Remove the commmand
	if ($scriptExplorerCmdItem = $pgse.Commands['GoCommand.HelpBrowser']) {
		$pgse.Commands.Remove($scriptExplorerCmdItem) | Out-Null
	}
	#Remove the toolwindow
	if ($PGScriptExplorer = $pgse.ToolWindows['HelpBrowser']) {
		$pgse.ToolWindows.Remove($PGScriptExplorer) | Out-Null
	}
	#endregion
	
	#region Clean-up the Help Panel
	
	#Remove the menu
	if (($goMenu = $pgse.Menus['MenuBar.Go']) -and
	    ($scriptExplorerCmdItem = $goMenu.Items['GoCommand.Help'])) {
		$goMenu.Items.Remove($scriptExplorerCmdItem) | Out-Null
	}
	#Remove the commmand
	if ($scriptExplorerCmdItem = $pgse.Commands['GoCommand.Help']) {
		$pgse.Commands.Remove($scriptExplorerCmdItem) | Out-Null
	}
	#Remove the toolwindow
	if ($PGScriptExplorer = $pgse.ToolWindows['Help']) {
		$pgse.ToolWindows.Remove($PGScriptExplorer) | Out-Null
	}
	#endregion
}

#endregion
