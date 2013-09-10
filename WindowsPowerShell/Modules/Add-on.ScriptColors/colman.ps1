# ========================================================
#
#	Title:				ScriptColors
#	Author:			(C) 2010 by Denniver Reining / www.bitspace.de
	 $version = 1.1
#	
# ========================================================

#region Hide Console
$script:showWindowAsync = Add-Type –memberDefinition @”
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
“@ -name “Win32ShowWindowAsync” -namespace Win32Functions –passThru
 $null = $showWindowAsync::ShowWindowAsync((Get-Process –id $pid).MainWindowHandle, 2)
#endregion

#region Variables
$installpath = Get-Process -Id $PID | Select-Object -ExpandProperty Path | Split-Path -Parent
if (!($installpath -match "GUI")){ 
	if (Test-Path "HKLM:\SOFTWARE\Microsoft\PowerShell\1\PowerShellSnapIns\PowerGUI\") {
		$installpath = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\PowerShell\1\PowerShellSnapIns\PowerGUI\").ApplicationBase  
	}
	else { $installpath = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\PowerShell\1\PowerShellSnapIns\PowerGUI_Pro\").ApplicationBase }
}
$syntaxXmlfile  = "PowerShellSyntax.xml"
$initialbackupfile = "PowerShellSyntax_BackupBeforeFirstRunAddOnScriptColors.xml"
$standardbackupfile = "PowerShellSyntax_Lastbackup.xml"
$scriptpath = Split-Path -parent $MyInvocation.MyCommand.Definition
$icofile = "$scriptpath\Resources\ScriptColors.ico"
$script:cancel = 0 
$script:changed = 0 
$script:saved = 0
$script:noadminrights = 0
#endregion

#region ScriptForm Designer

#region Constructor

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

#endregion

#region Post-Constructor Custom Code

#endregion

#region Form Creation
#Warning: It is recommended that changes inside this region be handled using the ScriptForm Designer.
#When working with the ScriptForm designer this region and any changes within may be overwritten.
#~~< Form1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Form1 = New-Object System.Windows.Forms.Form
$Form1.ClientSize = New-Object System.Drawing.Size(397, 487)
$Form1.MaximizeBox = $false
$Form1.MaximumSize = New-Object System.Drawing.Size(413, 525)
$Form1.MinimizeBox = $false
$Form1.MinimumSize = New-Object System.Drawing.Size(413, 525)
$Form1.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$Form1.Text = "PowerGUI ScriptColors (c)by Denniver Reining 2010"
$Form1.TopMost = $true
$Form1.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Label0 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label0 = New-Object System.Windows.Forms.Label
$Label0.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label0.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label0.Location = New-Object System.Drawing.Point(80, 18)
$Label0.Size = New-Object System.Drawing.Size(190, 19)
$Label0.TabIndex = 0
$Label0.Text = "Click on a colored text to adjust it:"
$Label0.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label0.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< LabelEX3 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LabelEX3 = New-Object System.Windows.Forms.Label
$LabelEX3.AccessibleName = "OperatorWordStyle"
$LabelEX3.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$LabelEX3.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LabelEX3.Location = New-Object System.Drawing.Point(208, 96)
$LabelEX3.Size = New-Object System.Drawing.Size(94, 24)
$LabelEX3.TabIndex = 1
$LabelEX3.Text = "Example Text"
$LabelEX3.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelEX3.BackColor = [System.Drawing.Color]::White
$LabelEX3.add_Click({FNedit($LabelEX3)})
#~~< LabelEX4 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LabelEX4 = New-Object System.Windows.Forms.Label
$LabelEX4.AccessibleName = "VariableStyle"
$LabelEX4.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$LabelEX4.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LabelEX4.Location = New-Object System.Drawing.Point(208, 120)
$LabelEX4.Size = New-Object System.Drawing.Size(94, 24)
$LabelEX4.TabIndex = 2
$LabelEX4.Text = "Example Text"
$LabelEX4.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelEX4.BackColor = [System.Drawing.Color]::White
$LabelEX4.add_Click({FNedit($LabelEX4)})
#~~< LabelEX5 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LabelEX5 = New-Object System.Windows.Forms.Label
$LabelEX5.AccessibleName = "CmdletStyle"
$LabelEX5.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$LabelEX5.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LabelEX5.Location = New-Object System.Drawing.Point(208, 144)
$LabelEX5.Size = New-Object System.Drawing.Size(94, 24)
$LabelEX5.TabIndex = 3
$LabelEX5.Text = "Example Text"
$LabelEX5.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelEX5.BackColor = [System.Drawing.Color]::White
$LabelEX5.add_Click({FNedit($LabelEX5)})
#~~< LabelEX6 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LabelEX6 = New-Object System.Windows.Forms.Label
$LabelEX6.AccessibleName = "NetClassStaticStyle"
$LabelEX6.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$LabelEX6.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LabelEX6.Location = New-Object System.Drawing.Point(208, 168)
$LabelEX6.Size = New-Object System.Drawing.Size(94, 24)
$LabelEX6.TabIndex = 4
$LabelEX6.Text = "Example Text"
$LabelEX6.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelEX6.BackColor = [System.Drawing.Color]::White
$LabelEX6.add_Click({FNedit($LabelEX6)})
#~~< LabelEX7 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LabelEX7 = New-Object System.Windows.Forms.Label
$LabelEX7.AccessibleName = "NetClassStaticMethodStyle"
$LabelEX7.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$LabelEX7.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LabelEX7.Location = New-Object System.Drawing.Point(208, 192)
$LabelEX7.Size = New-Object System.Drawing.Size(94, 24)
$LabelEX7.TabIndex = 5
$LabelEX7.Text = "Example Text"
$LabelEX7.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelEX7.BackColor = [System.Drawing.Color]::White
$LabelEX7.add_Click({FNedit($LabelEX7)})
#~~< LabelEX8 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LabelEX8 = New-Object System.Windows.Forms.Label
$LabelEX8.AccessibleName = "CmdletParamStyle"
$LabelEX8.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$LabelEX8.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LabelEX8.Location = New-Object System.Drawing.Point(208, 216)
$LabelEX8.Size = New-Object System.Drawing.Size(94, 24)
$LabelEX8.TabIndex = 6
$LabelEX8.Text = "Example Text"
$LabelEX8.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelEX8.BackColor = [System.Drawing.Color]::White
$LabelEX8.add_Click({FNedit($LabelEX8)})
#~~< LabelEX9 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LabelEX9 = New-Object System.Windows.Forms.Label
$LabelEX9.AccessibleName = "NumberStyle"
$LabelEX9.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$LabelEX9.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LabelEX9.Location = New-Object System.Drawing.Point(208, 240)
$LabelEX9.Size = New-Object System.Drawing.Size(94, 24)
$LabelEX9.TabIndex = 7
$LabelEX9.Text = "Example Text"
$LabelEX9.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelEX9.BackColor = [System.Drawing.Color]::White
$LabelEX9.add_Click({FNedit($LabelEX9)})
#~~< LabelEX10 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LabelEX10 = New-Object System.Windows.Forms.Label
$LabelEX10.AccessibleName = "StringDelimiterStyle"
$LabelEX10.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$LabelEX10.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LabelEX10.Location = New-Object System.Drawing.Point(208, 264)
$LabelEX10.Size = New-Object System.Drawing.Size(94, 24)
$LabelEX10.TabIndex = 8
$LabelEX10.Text = "Example Text"
$LabelEX10.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelEX10.BackColor = [System.Drawing.Color]::White
$LabelEX10.add_Click({FNedit($LabelEX10)})
#~~< LabelEX11 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LabelEX11 = New-Object System.Windows.Forms.Label
$LabelEX11.AccessibleName = "StringDefaultStyle"
$LabelEX11.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$LabelEX11.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LabelEX11.Location = New-Object System.Drawing.Point(208, 288)
$LabelEX11.Size = New-Object System.Drawing.Size(94, 24)
$LabelEX11.TabIndex = 9
$LabelEX11.Text = "Example Text"
$LabelEX11.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelEX11.BackColor = [System.Drawing.Color]::White
$LabelEX11.add_Click({FNedit($LabelEX11)})
#~~< LabelEX12 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LabelEX12 = New-Object System.Windows.Forms.Label
$LabelEX12.AccessibleName = "CommentDelimiterStyle"
$LabelEX12.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$LabelEX12.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LabelEX12.Location = New-Object System.Drawing.Point(208, 312)
$LabelEX12.Size = New-Object System.Drawing.Size(94, 24)
$LabelEX12.TabIndex = 10
$LabelEX12.Text = "Example Text"
$LabelEX12.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelEX12.BackColor = [System.Drawing.Color]::White
$LabelEX12.add_Click({FNedit($LabelEX12)})
#~~< LabelEX13 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LabelEX13 = New-Object System.Windows.Forms.Label
$LabelEX13.AccessibleName = "CommentDefaultStyle"
$LabelEX13.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$LabelEX13.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LabelEX13.Location = New-Object System.Drawing.Point(208, 336)
$LabelEX13.Size = New-Object System.Drawing.Size(94, 24)
$LabelEX13.TabIndex = 11
$LabelEX13.Text = "Example Text"
$LabelEX13.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelEX13.BackColor = [System.Drawing.Color]::White
$LabelEX13.add_Click({FNedit($LabelEX13)})
#~~< LabelEX14 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LabelEX14 = New-Object System.Windows.Forms.Label
$LabelEX14.AccessibleName = "AutoVars"
$LabelEX14.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$LabelEX14.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LabelEX14.Location = New-Object System.Drawing.Point(208, 360)
$LabelEX14.Size = New-Object System.Drawing.Size(94, 24)
$LabelEX14.TabIndex = 12
$LabelEX14.Text = "Example Text"
$LabelEX14.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelEX14.BackColor = [System.Drawing.Color]::White
$LabelEX14.add_Click({FNedit($LabelEX14)})
#~~< LabelEX15 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LabelEX15 = New-Object System.Windows.Forms.Label
$LabelEX15.AccessibleName = "FunctionStyle"
$LabelEX15.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$LabelEX15.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LabelEX15.Location = New-Object System.Drawing.Point(208, 384)
$LabelEX15.Size = New-Object System.Drawing.Size(94, 18)
$LabelEX15.TabIndex = 13
$LabelEX15.Text = "Example Text"
$LabelEX15.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelEX15.BackColor = [System.Drawing.Color]::White
$LabelEX15.add_Click({FNedit($LabelEX15)})
#~~< LabelEX2 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LabelEX2 = New-Object System.Windows.Forms.Label
$LabelEX2.AccessibleName = "OperatorStyle"
$LabelEX2.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$LabelEX2.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LabelEX2.Location = New-Object System.Drawing.Point(208, 72)
$LabelEX2.Size = New-Object System.Drawing.Size(94, 24)
$LabelEX2.TabIndex = 14
$LabelEX2.Text = "Example Text"
$LabelEX2.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelEX2.BackColor = [System.Drawing.Color]::White
$LabelEX2.add_Click({FNedit($LabelEX2)})
#~~< LabelEX1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LabelEX1 = New-Object System.Windows.Forms.Label
$LabelEX1.AccessibleName = "ReservedWordStyle"
$LabelEX1.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$LabelEX1.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LabelEX1.Location = New-Object System.Drawing.Point(208, 48)
$LabelEX1.Size = New-Object System.Drawing.Size(94, 24)
$LabelEX1.TabIndex = 15
$LabelEX1.Text = "Example Text"
$LabelEX1.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelEX1.BackColor = [System.Drawing.Color]::White
$LabelEX1.add_Click({FNedit($LabelEX1)})
#~~< Button2 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button2 = New-Object System.Windows.Forms.Button
$Button2.Location = New-Object System.Drawing.Point(302, 442)
$Button2.Size = New-Object System.Drawing.Size(70, 23)
$Button2.TabIndex = 2
$Button2.Text = "Cancel"
$Button2.UseVisualStyleBackColor = $true
#~~< Button1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button1 = New-Object System.Windows.Forms.Button
$Button1.Location = New-Object System.Drawing.Point(226, 442)
$Button1.Size = New-Object System.Drawing.Size(70, 23)
$Button1.TabIndex = 1
$Button1.Text = "Save"
$Button1.UseVisualStyleBackColor = $true
#~~< BNrestore >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNrestore = New-Object System.Windows.Forms.Button
$BNrestore.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 6.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNrestore.Location = New-Object System.Drawing.Point(25, 442)
$BNrestore.Size = New-Object System.Drawing.Size(70, 23)
$BNrestore.TabIndex = 33
$BNrestore.Text = "Restore Last"
$BNrestore.UseVisualStyleBackColor = $true

#~~< Label3 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label3 = New-Object System.Windows.Forms.Label
$Label3.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label3.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label3.Location = New-Object System.Drawing.Point(48, 96)
$Label3.Size = New-Object System.Drawing.Size(142, 19)
$Label3.TabIndex = 34
$Label3.Text = "Operator Words:"
$Label3.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label3.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Label4 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label4 = New-Object System.Windows.Forms.Label
$Label4.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label4.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label4.Location = New-Object System.Drawing.Point(48, 120)
$Label4.Size = New-Object System.Drawing.Size(142, 19)
$Label4.TabIndex = 35
$Label4.Text = "Variables:"
$Label4.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label4.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Label5 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label5 = New-Object System.Windows.Forms.Label
$Label5.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label5.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label5.Location = New-Object System.Drawing.Point(48, 144)
$Label5.Size = New-Object System.Drawing.Size(142, 19)
$Label5.TabIndex = 36
$Label5.Text = "Cmdlets:"
$Label5.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label5.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Label6 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label6 = New-Object System.Windows.Forms.Label
$Label6.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label6.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label6.Location = New-Object System.Drawing.Point(48, 168)
$Label6.Size = New-Object System.Drawing.Size(142, 19)
$Label6.TabIndex = 37
$Label6.Text = ".Net Classes:"
$Label6.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label6.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Label7 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label7 = New-Object System.Windows.Forms.Label
$Label7.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label7.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label7.Location = New-Object System.Drawing.Point(48, 192)
$Label7.Size = New-Object System.Drawing.Size(142, 19)
$Label7.TabIndex = 38
$Label7.Text = ".Net Class Methods:"
$Label7.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label7.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Label8 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label8 = New-Object System.Windows.Forms.Label
$Label8.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label8.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label8.Location = New-Object System.Drawing.Point(48, 216)
$Label8.Size = New-Object System.Drawing.Size(142, 19)
$Label8.TabIndex = 39
$Label8.Text = "Cmdlet Parameters:"
$Label8.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label8.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Label9 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label9 = New-Object System.Windows.Forms.Label
$Label9.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label9.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label9.Location = New-Object System.Drawing.Point(48, 240)
$Label9.Size = New-Object System.Drawing.Size(142, 19)
$Label9.TabIndex = 40
$Label9.Text = "Numbers:"
$Label9.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label9.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Label10 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label10 = New-Object System.Windows.Forms.Label
$Label10.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label10.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label10.Location = New-Object System.Drawing.Point(48, 264)
$Label10.Size = New-Object System.Drawing.Size(142, 19)
$Label10.TabIndex = 41
$Label10.Text = "String Delimiters:"
$Label10.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label10.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Label11 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label11 = New-Object System.Windows.Forms.Label
$Label11.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label11.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label11.Location = New-Object System.Drawing.Point(48, 288)
$Label11.Size = New-Object System.Drawing.Size(142, 19)
$Label11.TabIndex = 42
$Label11.Text = "Strings:"
$Label11.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label11.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Label12 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label12 = New-Object System.Windows.Forms.Label
$Label12.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label12.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label12.Location = New-Object System.Drawing.Point(48, 312)
$Label12.Size = New-Object System.Drawing.Size(142, 19)
$Label12.TabIndex = 43
$Label12.Text = "Comment Delimiter:"
$Label12.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label12.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Label13 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label13 = New-Object System.Windows.Forms.Label
$Label13.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label13.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label13.Location = New-Object System.Drawing.Point(48, 336)
$Label13.Size = New-Object System.Drawing.Size(142, 19)
$Label13.TabIndex = 44
$Label13.Text = "Comment Text:"
$Label13.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label13.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Label14 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label14 = New-Object System.Windows.Forms.Label
$Label14.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label14.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label14.Location = New-Object System.Drawing.Point(48, 360)
$Label14.Size = New-Object System.Drawing.Size(142, 19)
$Label14.TabIndex = 45
$Label14.Text = "AutoVars:"
$Label14.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label14.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Label15 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label15 = New-Object System.Windows.Forms.Label
$Label15.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label15.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label15.Location = New-Object System.Drawing.Point(48, 384)
$Label15.Size = New-Object System.Drawing.Size(142, 19)
$Label15.TabIndex = 46
$Label15.Text = "Function Names:"
$Label15.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label15.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Label2 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label2 = New-Object System.Windows.Forms.Label
$Label2.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label2.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label2.Location = New-Object System.Drawing.Point(48, 72)
$Label2.Size = New-Object System.Drawing.Size(142, 19)
$Label2.TabIndex = 47
$Label2.Text = "Operators:"
$Label2.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label2.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Label1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label1 = New-Object System.Windows.Forms.Label
$Label1.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Label1.Font = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Label1.Location = New-Object System.Drawing.Point(48, 48)
$Label1.Size = New-Object System.Drawing.Size(145, 19)
$Label1.TabIndex = 48
$Label1.Text = "Function,Loops,Conditions:"
$Label1.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label1.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Panel1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Panel1 = New-Object System.Windows.Forms.Panel
$Panel1.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$Panel1.Location = New-Object System.Drawing.Point(24, 24)
$Panel1.Size = New-Object System.Drawing.Size(347, 400)
$Panel1.TabIndex = 32
$Panel1.Text = ""
$Panel1.BackColor = [System.Drawing.Color]::WhiteSmoke
#~~< Button3 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button3 = New-Object System.Windows.Forms.Button
$Button3.AccessibleName = "FunctionStyle"
$Button3.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Button3.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Button3.Location = New-Object System.Drawing.Point(313, 358)
$Button3.Size = New-Object System.Drawing.Size(20, 19)
$Button3.TabIndex = 29
$Button3.TabStop = $false
$Button3.Text = "B"
$Button3.UseVisualStyleBackColor = $false
$Button3.BackColor = [System.Drawing.Color]::White
$Button3.add_Click({FNbold($Button3)})
#~~< Button4 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button4 = New-Object System.Windows.Forms.Button
$Button4.AccessibleName = "AutoVars"
$Button4.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Button4.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Button4.Location = New-Object System.Drawing.Point(313, 335)
$Button4.Size = New-Object System.Drawing.Size(20, 19)
$Button4.TabIndex = 28
$Button4.TabStop = $false
$Button4.Text = "B"
$Button4.UseVisualStyleBackColor = $false
$Button4.BackColor = [System.Drawing.Color]::White
$Button4.add_Click({FNbold($Button4)})
#~~< Button5 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button5 = New-Object System.Windows.Forms.Button
$Button5.AccessibleName = "CommentDefaultStyle"
$Button5.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Button5.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Button5.Location = New-Object System.Drawing.Point(313, 311)
$Button5.Size = New-Object System.Drawing.Size(20, 19)
$Button5.TabIndex = 27
$Button5.TabStop = $false
$Button5.Text = "B"
$Button5.UseVisualStyleBackColor = $false
$Button5.BackColor = [System.Drawing.Color]::White
$Button5.add_Click({FNbold($Button5)})
#~~< Button6 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button6 = New-Object System.Windows.Forms.Button
$Button6.AccessibleName = "CommentDelimiterStyle"
$Button6.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Button6.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Button6.Location = New-Object System.Drawing.Point(313, 286)
$Button6.Size = New-Object System.Drawing.Size(20, 19)
$Button6.TabIndex = 26
$Button6.TabStop = $false
$Button6.Text = "B"
$Button6.UseVisualStyleBackColor = $false
$Button6.BackColor = [System.Drawing.Color]::White
$Button6.add_Click({FNbold($Button6)})
#~~< Button7 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button7 = New-Object System.Windows.Forms.Button
$Button7.AccessibleName = "StringDefaultStyle"
$Button7.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Button7.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Button7.Location = New-Object System.Drawing.Point(313, 262)
$Button7.Size = New-Object System.Drawing.Size(20, 19)
$Button7.TabIndex = 25
$Button7.TabStop = $false
$Button7.Text = "B"
$Button7.UseVisualStyleBackColor = $false
$Button7.BackColor = [System.Drawing.Color]::White
$Button7.add_Click({FNbold($Button7)})
#~~< Button8 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button8 = New-Object System.Windows.Forms.Button
$Button8.AccessibleName = "StringDelimiterStyle"
$Button8.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Button8.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Button8.Location = New-Object System.Drawing.Point(313, 240)
$Button8.Size = New-Object System.Drawing.Size(20, 19)
$Button8.TabIndex = 24
$Button8.TabStop = $false
$Button8.Text = "B"
$Button8.UseVisualStyleBackColor = $false
$Button8.BackColor = [System.Drawing.Color]::White
$Button8.add_Click({FNbold($Button8)})
#~~< Button9 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button9 = New-Object System.Windows.Forms.Button
$Button9.AccessibleName = "NumberStyle"
$Button9.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Button9.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Button9.Location = New-Object System.Drawing.Point(313, 216)
$Button9.Size = New-Object System.Drawing.Size(20, 19)
$Button9.TabIndex = 23
$Button9.TabStop = $false
$Button9.Text = "B"
$Button9.UseVisualStyleBackColor = $false
$Button9.BackColor = [System.Drawing.Color]::White
$Button9.add_Click({FNbold($Button9)})
#~~< Button10 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button10 = New-Object System.Windows.Forms.Button
$Button10.AccessibleName = "CmdletParamStyle"
$Button10.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Button10.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Button10.Location = New-Object System.Drawing.Point(313, 192)
$Button10.Size = New-Object System.Drawing.Size(20, 19)
$Button10.TabIndex = 22
$Button10.TabStop = $false
$Button10.Text = "B"
$Button10.UseVisualStyleBackColor = $false
$Button10.BackColor = [System.Drawing.Color]::White
$Button10.add_Click({FNbold($Button10)})
#~~< Button11 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button11 = New-Object System.Windows.Forms.Button
$Button11.AccessibleName = "NetClassStaticMethodStyle"
$Button11.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Button11.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Button11.Location = New-Object System.Drawing.Point(313, 167)
$Button11.Size = New-Object System.Drawing.Size(20, 19)
$Button11.TabIndex = 21
$Button11.TabStop = $false
$Button11.Text = "B"
$Button11.UseVisualStyleBackColor = $false
$Button11.BackColor = [System.Drawing.Color]::White
$Button11.add_Click({FNbold($Button11)})
#~~< Button12 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button12 = New-Object System.Windows.Forms.Button
$Button12.AccessibleName = "NetClassStaticStyle"
$Button12.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Button12.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Button12.Location = New-Object System.Drawing.Point(313, 143)
$Button12.Size = New-Object System.Drawing.Size(20, 19)
$Button12.TabIndex = 20
$Button12.TabStop = $false
$Button12.Text = "B"
$Button12.UseVisualStyleBackColor = $false
$Button12.BackColor = [System.Drawing.Color]::White
$Button12.add_Click({FNbold($Button12)})
#~~< Button13 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button13 = New-Object System.Windows.Forms.Button
$Button13.AccessibleName = "CmdletStyle"
$Button13.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Button13.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Button13.Location = New-Object System.Drawing.Point(313, 118)
$Button13.Size = New-Object System.Drawing.Size(20, 19)
$Button13.TabIndex = 19
$Button13.TabStop = $false
$Button13.Text = "B"
$Button13.UseVisualStyleBackColor = $false
$Button13.BackColor = [System.Drawing.Color]::White
$Button13.add_Click({FNbold($Button13)})
#~~< Button14 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button14 = New-Object System.Windows.Forms.Button
$Button14.AccessibleName = "VariableStyle"
$Button14.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Button14.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Button14.Location = New-Object System.Drawing.Point(313, 95)
$Button14.Size = New-Object System.Drawing.Size(20, 19)
$Button14.TabIndex = 18
$Button14.TabStop = $false
$Button14.Text = "B"
$Button14.UseVisualStyleBackColor = $false
$Button14.BackColor = [System.Drawing.Color]::White
$Button14.add_Click({FNbold($Button14)})
#~~< Button15 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button15 = New-Object System.Windows.Forms.Button
$Button15.AccessibleName = "OperatorWordStyle"
$Button15.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Button15.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Button15.Location = New-Object System.Drawing.Point(313, 70)
$Button15.Size = New-Object System.Drawing.Size(20, 19)
$Button15.TabIndex = 17
$Button15.TabStop = $false
$Button15.Text = "B"
$Button15.UseVisualStyleBackColor = $false
$Button15.BackColor = [System.Drawing.Color]::White
$Button15.add_Click({FNbold($Button15)})
#~~< Button16 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Button16 = New-Object System.Windows.Forms.Button
$Button16.AccessibleName = "OperatorStyle"
$Button16.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$Button16.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Button16.Location = New-Object System.Drawing.Point(313, 46)
$Button16.Size = New-Object System.Drawing.Size(20, 19)
$Button16.TabIndex = 16
$Button16.TabStop = $false
$Button16.Text = "B"
$Button16.UseVisualStyleBackColor = $false
$Button16.BackColor = [System.Drawing.Color]::White
$Button16.add_Click({FNbold($Button16)})
#~~< BNbold1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNbold1 = New-Object System.Windows.Forms.Button
$BNbold1.AccessibleName = "ReservedWordStyle"
$BNbold1.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNbold1.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNbold1.Location = New-Object System.Drawing.Point(313, 21)
$BNbold1.Size = New-Object System.Drawing.Size(20, 19)
$BNbold1.TabIndex = 15
$BNbold1.TabStop = $false
$BNbold1.Text = "B"
$BNbold1.UseVisualStyleBackColor = $false
$BNbold1.BackColor = [System.Drawing.Color]::White
$BNbold1.add_Click({FNbold($BNbold1)})
#~~< BNita10 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNita10 = New-Object System.Windows.Forms.Button
$BNita10.AccessibleName = "FunctionStyle"
$BNita10.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNita10.Font = New-Object System.Drawing.Font("Times New Roman", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNita10.Location = New-Object System.Drawing.Point(286, 358)
$BNita10.Size = New-Object System.Drawing.Size(20, 19)
$BNita10.TabIndex = 14
$BNita10.TabStop = $false
$BNita10.Text = "I"
$BNita10.UseVisualStyleBackColor = $false
$BNita10.BackColor = [System.Drawing.Color]::White
$BNita10.add_Click({FNitalic($BNita10)})
#~~< BNita11 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNita11 = New-Object System.Windows.Forms.Button
$BNita11.AccessibleName = "AutoVars"
$BNita11.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNita11.Font = New-Object System.Drawing.Font("Times New Roman", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNita11.Location = New-Object System.Drawing.Point(286, 335)
$BNita11.Size = New-Object System.Drawing.Size(20, 19)
$BNita11.TabIndex = 13
$BNita11.TabStop = $false
$BNita11.Text = "I"
$BNita11.UseVisualStyleBackColor = $false
$BNita11.BackColor = [System.Drawing.Color]::White
$BNita11.add_Click({FNitalic($BNita11)})
#~~< BNita12 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNita12 = New-Object System.Windows.Forms.Button
$BNita12.AccessibleName = "CommentDefaultStyle"
$BNita12.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNita12.Font = New-Object System.Drawing.Font("Times New Roman", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNita12.Location = New-Object System.Drawing.Point(286, 311)
$BNita12.Size = New-Object System.Drawing.Size(20, 19)
$BNita12.TabIndex = 12
$BNita12.TabStop = $false
$BNita12.Text = "I"
$BNita12.UseVisualStyleBackColor = $false
$BNita12.BackColor = [System.Drawing.Color]::White
$BNita12.add_Click({FNitalic($BNita12)})
#~~< BNita13 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNita13 = New-Object System.Windows.Forms.Button
$BNita13.AccessibleName = "CommentDelimiterStyle"
$BNita13.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNita13.Font = New-Object System.Drawing.Font("Times New Roman", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNita13.Location = New-Object System.Drawing.Point(286, 286)
$BNita13.Size = New-Object System.Drawing.Size(20, 19)
$BNita13.TabIndex = 11
$BNita13.TabStop = $false
$BNita13.Text = "I"
$BNita13.UseVisualStyleBackColor = $false
$BNita13.BackColor = [System.Drawing.Color]::White
$BNita13.add_Click({FNitalic($BNita13)})
#~~< BNita14 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNita14 = New-Object System.Windows.Forms.Button
$BNita14.AccessibleName = "StringDefaultStyle"
$BNita14.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNita14.Font = New-Object System.Drawing.Font("Times New Roman", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNita14.Location = New-Object System.Drawing.Point(286, 262)
$BNita14.Size = New-Object System.Drawing.Size(20, 19)
$BNita14.TabIndex = 10
$BNita14.TabStop = $false
$BNita14.Text = "I"
$BNita14.UseVisualStyleBackColor = $false
$BNita14.BackColor = [System.Drawing.Color]::White
$BNita14.add_Click({FNitalic($BNita14)})
#~~< BNita15 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNita15 = New-Object System.Windows.Forms.Button
$BNita15.AccessibleName = "StringDelimiterStyle"
$BNita15.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNita15.Font = New-Object System.Drawing.Font("Times New Roman", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNita15.Location = New-Object System.Drawing.Point(286, 240)
$BNita15.Size = New-Object System.Drawing.Size(20, 19)
$BNita15.TabIndex = 9
$BNita15.TabStop = $false
$BNita15.Text = "I"
$BNita15.UseVisualStyleBackColor = $false
$BNita15.BackColor = [System.Drawing.Color]::White
$BNita15.add_Click({FNitalic($BNita15)})
#~~< BNita16 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNita16 = New-Object System.Windows.Forms.Button
$BNita16.AccessibleName = "NumberStyle"
$BNita16.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNita16.Font = New-Object System.Drawing.Font("Times New Roman", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNita16.Location = New-Object System.Drawing.Point(286, 216)
$BNita16.Size = New-Object System.Drawing.Size(20, 19)
$BNita16.TabIndex = 8
$BNita16.TabStop = $false
$BNita16.Text = "I"
$BNita16.UseVisualStyleBackColor = $false
$BNita16.BackColor = [System.Drawing.Color]::White
$BNita16.add_Click({FNitalic($BNita16)})
#~~< BNita6 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNita6 = New-Object System.Windows.Forms.Button
$BNita6.AccessibleName = "CmdletParamStyle"
$BNita6.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNita6.Font = New-Object System.Drawing.Font("Times New Roman", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNita6.Location = New-Object System.Drawing.Point(286, 192)
$BNita6.Size = New-Object System.Drawing.Size(20, 19)
$BNita6.TabIndex = 7
$BNita6.TabStop = $false
$BNita6.Text = "I"
$BNita6.UseVisualStyleBackColor = $false
$BNita6.BackColor = [System.Drawing.Color]::White
$BNita6.add_Click({FNitalic($BNita6)})
#~~< BNita7 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNita7 = New-Object System.Windows.Forms.Button
$BNita7.AccessibleName = "NetClassStaticMethodStyle"
$BNita7.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNita7.Font = New-Object System.Drawing.Font("Times New Roman", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNita7.Location = New-Object System.Drawing.Point(286, 167)
$BNita7.Size = New-Object System.Drawing.Size(20, 19)
$BNita7.TabIndex = 6
$BNita7.TabStop = $false
$BNita7.Text = "I"
$BNita7.UseVisualStyleBackColor = $false
$BNita7.BackColor = [System.Drawing.Color]::White
$BNita7.add_Click({FNitalic($BNita7)})
#~~< BNita8 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNita8 = New-Object System.Windows.Forms.Button
$BNita8.AccessibleName = "NetClassStaticStyle"
$BNita8.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNita8.Font = New-Object System.Drawing.Font("Times New Roman", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNita8.Location = New-Object System.Drawing.Point(286, 143)
$BNita8.Size = New-Object System.Drawing.Size(20, 19)
$BNita8.TabIndex = 5
$BNita8.TabStop = $false
$BNita8.Text = "I"
$BNita8.UseVisualStyleBackColor = $false
$BNita8.BackColor = [System.Drawing.Color]::White
$BNita8.add_Click({FNitalic($BNita8)})
#~~< BNita9 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNita9 = New-Object System.Windows.Forms.Button
$BNita9.AccessibleName = "CmdletStyle"
$BNita9.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNita9.Font = New-Object System.Drawing.Font("Times New Roman", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNita9.Location = New-Object System.Drawing.Point(286, 118)
$BNita9.Size = New-Object System.Drawing.Size(20, 19)
$BNita9.TabIndex = 4
$BNita9.TabStop = $false
$BNita9.Text = "I"
$BNita9.UseVisualStyleBackColor = $false
$BNita9.BackColor = [System.Drawing.Color]::White
$BNita9.add_Click({FNitalic($BNita9)})
#~~< BNita4 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNita4 = New-Object System.Windows.Forms.Button
$BNita4.AccessibleName = "VariableStyle"
$BNita4.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNita4.Font = New-Object System.Drawing.Font("Times New Roman", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNita4.Location = New-Object System.Drawing.Point(286, 95)
$BNita4.Size = New-Object System.Drawing.Size(20, 19)
$BNita4.TabIndex = 3
$BNita4.TabStop = $false
$BNita4.Text = "I"
$BNita4.UseVisualStyleBackColor = $false
$BNita4.BackColor = [System.Drawing.Color]::White
$BNita4.add_Click({FNitalic($BNita4)})
#~~< BNita5 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNita5 = New-Object System.Windows.Forms.Button
$BNita5.AccessibleName = "OperatorWordStyle"
$BNita5.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNita5.Font = New-Object System.Drawing.Font("Times New Roman", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNita5.Location = New-Object System.Drawing.Point(286, 70)
$BNita5.Size = New-Object System.Drawing.Size(20, 19)
$BNita5.TabIndex = 2
$BNita5.TabStop = $false
$BNita5.Text = "I"
$BNita5.UseVisualStyleBackColor = $false
$BNita5.BackColor = [System.Drawing.Color]::White
$BNita5.add_Click({FNitalic($BNita5)})
#~~< BNita3 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNita3 = New-Object System.Windows.Forms.Button
$BNita3.AccessibleName = "OperatorStyle"
$BNita3.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNita3.Font = New-Object System.Drawing.Font("Times New Roman", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNita3.Location = New-Object System.Drawing.Point(286, 46)
$BNita3.Size = New-Object System.Drawing.Size(20, 19)
$BNita3.TabIndex = 1
$BNita3.TabStop = $false
$BNita3.Text = "I"
$BNita3.UseVisualStyleBackColor = $false
$BNita3.BackColor = [System.Drawing.Color]::White
$BNita3.add_Click({FNitalic($BNita3)})
#~~< BNita1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$BNita1 = New-Object System.Windows.Forms.Button
$BNita1.AccessibleName = "ReservedWordStyle"
$BNita1.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$BNita1.Font = New-Object System.Drawing.Font("Times New Roman", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$BNita1.Location = New-Object System.Drawing.Point(286, 21)
$BNita1.Size = New-Object System.Drawing.Size(20, 19)
$BNita1.TabIndex = 0
$BNita1.TabStop = $false
$BNita1.Text = "I"
$BNita1.UseVisualStyleBackColor = $false
$BNita1.BackColor = [System.Drawing.Color]::White
$BNita1.add_Click({FNitalic($BNita1)})
$Panel1.Controls.Add($Button3)
$Panel1.Controls.Add($Button4)
$Panel1.Controls.Add($Button5)
$Panel1.Controls.Add($Button6)
$Panel1.Controls.Add($Button7)
$Panel1.Controls.Add($Button8)
$Panel1.Controls.Add($Button9)
$Panel1.Controls.Add($Button10)
$Panel1.Controls.Add($Button11)
$Panel1.Controls.Add($Button12)
$Panel1.Controls.Add($Button13)
$Panel1.Controls.Add($Button14)
$Panel1.Controls.Add($Button15)
$Panel1.Controls.Add($Button16)
$Panel1.Controls.Add($BNbold1)
$Panel1.Controls.Add($BNita10)
$Panel1.Controls.Add($BNita11)
$Panel1.Controls.Add($BNita12)
$Panel1.Controls.Add($BNita13)
$Panel1.Controls.Add($BNita14)
$Panel1.Controls.Add($BNita15)
$Panel1.Controls.Add($BNita16)
$Panel1.Controls.Add($BNita6)
$Panel1.Controls.Add($BNita7)
$Panel1.Controls.Add($BNita8)
$Panel1.Controls.Add($BNita9)
$Panel1.Controls.Add($BNita4)
$Panel1.Controls.Add($BNita5)
$Panel1.Controls.Add($BNita3)
$Panel1.Controls.Add($BNita1)
$Form1.Controls.Add($Label0)
$Form1.Controls.Add($LabelEX3)
$Form1.Controls.Add($LabelEX4)
$Form1.Controls.Add($LabelEX5)
$Form1.Controls.Add($LabelEX6)
$Form1.Controls.Add($LabelEX7)
$Form1.Controls.Add($LabelEX8)
$Form1.Controls.Add($LabelEX9)
$Form1.Controls.Add($LabelEX10)
$Form1.Controls.Add($LabelEX11)
$Form1.Controls.Add($LabelEX12)
$Form1.Controls.Add($LabelEX13)
$Form1.Controls.Add($LabelEX14)
$Form1.Controls.Add($LabelEX15)
$Form1.Controls.Add($LabelEX2)
$Form1.Controls.Add($LabelEX1)
$Form1.Controls.Add($Button2)
$Form1.Controls.Add($Button1)
$Form1.Controls.Add($BNrestore)
$Form1.Controls.Add($Label3)
$Form1.Controls.Add($Label4)
$Form1.Controls.Add($Label5)
$Form1.Controls.Add($Label6)
$Form1.Controls.Add($Label7)
$Form1.Controls.Add($Label8)
$Form1.Controls.Add($Label9)
$Form1.Controls.Add($Label10)
$Form1.Controls.Add($Label11)
$Form1.Controls.Add($Label12)
$Form1.Controls.Add($Label13)
$Form1.Controls.Add($Label14)
$Form1.Controls.Add($Label15)
$Form1.Controls.Add($Label2)
$Form1.Controls.Add($Label1)
$Form1.Controls.Add($Panel1)

#endregion

#region Custom Code

$Form1.add_closing({ FNcloseForm })  
$Form1.Icon = New-Object System.Drawing.Icon("$icofile")
$Button2.add_Click({ $script:cancel = 1 ; $form1.close()  })
$Button1.add_Click({ FNwritexml })
$BNrestore.add_Click({FNRestoreBackup })
$script:fontstyleItalic = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$script:fontstyleRegular = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$script:fontstyleboldANDitalic = New-Object System.Drawing.Font("Segoe UI", 8.25, ([System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold -bor [System.Drawing.FontStyle]::Italic)), [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$script:fontstyleBold = New-Object System.Drawing.Font("Segoe UI", 8.25, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
#endregion

#region Event Loop

function Main{
	[System.Windows.Forms.Application]::EnableVisualStyles()
	[System.Windows.Forms.Application]::Run($Form1)
}

#endregion

#endregion

#region Event Handlers

function FNMain {
	[System.Windows.Forms.Application]::EnableVisualStyles()
	#[System.Windows.Forms.Application]::Show($Form1)
	[void]$Form1.ShowDialog()
}

function FNcloseForm {
	if (($cancel -ne 1) -and ($changed -eq 1) -and ($saved -ne 1) -and ($noadminrights -ne 1) ) { 
	FNasktosave
	}
}

function FNAdminTestAndBackup {
  	if ( New-Item "$installpath\testfile.txt" -Type File -erroraction silentlycontinue) { 
			Remove-Item "$installpath\testfile.txt"
			if ( [system.io.file]::exists("$installpath\$initialbackupfile") ){} 
			 else {   # make Initial Backup
			 	Copy-Item "$installpath\$syntaxXmlfile" "$installpath\$initialbackupfile"
				(Get-Content "$installpath\$syntaxXmlfile") -replace '^<\?xml version=\"1\.0\"\?>$','<?xml version="1.0" encoding="utf-8"?>' | Out-File "$installpath\$syntaxXmlfile"  # Write missing encoding value to XML file
			}
  	}
	else {
		FNermes "SciptColors was started without admin privileges.`nYou may continue, but you won't be able to save changes.`n`n"
 		$script:noadminrights = 1	
	}
}

function FNermes ($message)  {  
		[void] [Windows.Forms.MessageBox]::Show("$message", "ScriptColors Addon - Error", [Windows.Forms.MessageBoxButtons]::ok, [Windows.Forms.MessageBoxIcon]::Warning)
}

##trap  {
##    FNermes ($_.Exception.Message)
##}

function FNdisplaycolors { 
	$script:syntaxXmlData = [xml](Get-Content "$installpath\$syntaxXmlfile" )
	$script:xmlnode = $syntaxXmlData.SyntaxLanguages.Syntaxlanguage.Styles.Style
foreach ($DefStyle in $xmlnode) { 
		if ( $DefStyle.key -eq "ReservedWordStyle"   ) { $LabelEX1.ForeColor = $DefStyle.ForeColor
			$Attrib = $DefStyle.getAttribute("Italic") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Italic" }	
			$Attrib = $DefStyle.getAttribute("Bold") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Bold" }
			if (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX1.Font = $fontstyleboldANDitalic }  
			elseif (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "False" )) { $LabelEX1.Font = $fontstyleitalic } 
			elseif (($DefStyle.Italic -eq "False" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX1.Font = $fontstyleBold } 
			else { $LabelEX1.Font = $fontstyleregular }}
		if ( $DefStyle.key -eq "OperatorStyle"   ) { $LabelEX2.ForeColor = $DefStyle.ForeColor 
			$Attrib = $DefStyle.getAttribute("Italic") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Italic" }	
			$Attrib = $DefStyle.getAttribute("Bold") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Bold" }
			if (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX2.Font = $fontstyleboldANDitalic }  
			elseif (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "False" )) { $LabelEX2.Font = $fontstyleitalic } 
			elseif (($DefStyle.Italic -eq "False" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX2.Font = $fontstyleBold } 
			else { $LabelEX2.Font = $fontstyleregular }}
		if ( $DefStyle.key -eq "OperatorWordStyle"   ) { $LabelEX3.ForeColor = $DefStyle.ForeColor
			$Attrib = $DefStyle.getAttribute("Italic") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Italic" }
			$Attrib = $DefStyle.getAttribute("Bold") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Bold" }
			if (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX3.Font = $fontstyleboldANDitalic }  
			elseif (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "False" )) { $LabelEX3.Font = $fontstyleitalic } 
			elseif (($DefStyle.Italic -eq "False" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX3.Font = $fontstyleBold } 
			else { $LabelEX3.Font = $fontstyleregular }}
		if ( $DefStyle.key -eq "VariableStyle"   ) { $LabelEX4.ForeColor = $DefStyle.ForeColor 
			$Attrib = $DefStyle.getAttribute("Italic") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Italic" }
			$Attrib = $DefStyle.getAttribute("Bold") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Bold" }
			if (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX4.Font = $fontstyleboldANDitalic }  
			elseif (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "False" )) { $LabelEX4.Font = $fontstyleitalic } 
			elseif (($DefStyle.Italic -eq "False" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX4.Font = $fontstyleBold } 
			else { $LabelEX4.Font = $fontstyleregular }}
		if ( $DefStyle.key -eq "CmdletStyle"   ) { $LabelEX5.ForeColor = $DefStyle.ForeColor 
			$Attrib = $DefStyle.getAttribute("Italic") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Italic" }
			$Attrib = $DefStyle.getAttribute("Bold") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Bold" }
			if (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX5.Font = $fontstyleboldANDitalic }  
			elseif (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "False" )) { $LabelEX5.Font = $fontstyleitalic } 
			elseif (($DefStyle.Italic -eq "False" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX5.Font = $fontstyleBold } 
			else { $LabelEX5.Font = $fontstyleregular }}
		if ( $DefStyle.key -eq "NetClassStaticStyle"   ) { $LabelEX6.ForeColor = $DefStyle.ForeColor 
			$Attrib = $DefStyle.getAttribute("Italic") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Italic" }
			$Attrib = $DefStyle.getAttribute("Bold") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Bold" }
			if (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX6.Font = $fontstyleboldANDitalic }  
			elseif (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "False" )) { $LabelEX6.Font = $fontstyleitalic } 
			elseif (($DefStyle.Italic -eq "False" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX6.Font = $fontstyleBold } 
			else { $LabelEX6.Font = $fontstyleregular }}
		if ( $DefStyle.key -eq "NetClassStaticMethodStyle"   ) { $LabelEX7.ForeColor = $DefStyle.ForeColor 
			$Attrib = $DefStyle.getAttribute("Italic") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Italic" }
			$Attrib = $DefStyle.getAttribute("Bold") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Bold" }
			if (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX7.Font = $fontstyleboldANDitalic }  
			elseif (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "False" )) { $LabelEX7.Font = $fontstyleitalic } 
			elseif (($DefStyle.Italic -eq "False" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX7.Font = $fontstyleBold } 
			else { $LabelEX7.Font = $fontstyleregular }}
		if ( $DefStyle.key -eq "CmdletParamStyle"   ) { $LabelEX8.ForeColor = $DefStyle.ForeColor 
			$Attrib = $DefStyle.getAttribute("Italic") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Italic" }
			$Attrib = $DefStyle.getAttribute("Bold") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Bold" }
			if (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX8.Font = $fontstyleboldANDitalic }  
			elseif (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "False" )) { $LabelEX8.Font = $fontstyleitalic } 
			elseif (($DefStyle.Italic -eq "False" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX8.Font = $fontstyleBold } 
			else { $LabelEX8.Font = $fontstyleregular }}
		if ( $DefStyle.key -eq "NumberStyle"   ) { $LabelEX9.ForeColor = $DefStyle.ForeColor 
			$Attrib = $DefStyle.getAttribute("Italic") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Italic" }
			$Attrib = $DefStyle.getAttribute("Bold") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Bold" }
			if (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX9.Font = $fontstyleboldANDitalic }  
			elseif (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "False" )) { $LabelEX9.Font = $fontstyleitalic } 
			elseif (($DefStyle.Italic -eq "False" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX9.Font = $fontstyleBold } 
			else { $LabelEX9.Font = $fontstyleregular }}
		if ( $DefStyle.key -eq "StringDelimiterStyle"   ) { $LabelEX10.ForeColor = $DefStyle.ForeColor 
			$Attrib = $DefStyle.getAttribute("Italic") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Italic" }
			$Attrib = $DefStyle.getAttribute("Bold") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Bold" }
			if (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX10.Font = $fontstyleboldANDitalic }  
			elseif (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "False" )) { $LabelEX10.Font = $fontstyleitalic } 
			elseif (($DefStyle.Italic -eq "False" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX10.Font = $fontstyleBold } 
			else { $LabelEX10.Font = $fontstyleregular }}
		if ( $DefStyle.key -eq "StringDefaultStyle"   ) { $LabelEX11.ForeColor = $DefStyle.ForeColor 
			$Attrib = $DefStyle.getAttribute("Italic") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Italic" }
			$Attrib = $DefStyle.getAttribute("Bold") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Bold" }
			if (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX11.Font = $fontstyleboldANDitalic }  
			elseif (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "False" )) { $LabelEX11.Font = $fontstyleitalic } 
			elseif (($DefStyle.Italic -eq "False" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX11.Font = $fontstyleBold } 
			else { $LabelEX11.Font = $fontstyleregular }}
		if ( $DefStyle.key -eq "CommentDelimiterStyle"   ) { $LabelEX12.ForeColor = $DefStyle.ForeColor 
			$Attrib = $DefStyle.getAttribute("Italic") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Italic" }
			$Attrib = $DefStyle.getAttribute("Bold") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Bold" }
			if (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX12.Font = $fontstyleboldANDitalic }  
			elseif (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "False" )) { $LabelEX12.Font = $fontstyleitalic } 
			elseif (($DefStyle.Italic -eq "False" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX12.Font = $fontstyleBold } 
			else { $LabelEX12.Font = $fontstyleregular }}
		if ( $DefStyle.key -eq "CommentDefaultStyle"   ) { $LabelEX13.ForeColor = $DefStyle.ForeColor 
			$Attrib = $DefStyle.getAttribute("Italic") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Italic" }
			$Attrib = $DefStyle.getAttribute("Bold") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Bold" }
			if (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX13.Font = $fontstyleboldANDitalic }  
			elseif (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "False" )) { $LabelEX13.Font = $fontstyleitalic } 
			elseif (($DefStyle.Italic -eq "False" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX13.Font = $fontstyleBold } 
			else { $LabelEX13.Font = $fontstyleregular }}
		if ( $DefStyle.key -eq "AutoVars"   ) { $LabelEX14.ForeColor = $DefStyle.ForeColor 
			$Attrib = $DefStyle.getAttribute("Italic") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Italic" }
			$Attrib = $DefStyle.getAttribute("Bold") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Bold" }
			if (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX14.Font = $fontstyleboldANDitalic }  
			elseif (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "False" )) { $LabelEX14.Font = $fontstyleitalic } 
			elseif (($DefStyle.Italic -eq "False" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX14.Font = $fontstyleBold } 
			else { $LabelEX14.Font = $fontstyleregular }}
		if ( $DefStyle.key -eq "FunctionStyle"   ) { $LabelEX15.ForeColor = $DefStyle.ForeColor
			$Attrib = $DefStyle.getAttribute("Italic") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Italic" }
			$Attrib = $DefStyle.getAttribute("Bold") ; if ( $Attrib  -eq "" ) { FNCreateAttribute $DefStyle "Bold" }
			if (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX15.Font = $fontstyleboldANDitalic }  
			elseif (($DefStyle.Italic -eq "True" )-and ($DefStyle.Bold -eq "False" )) { $LabelEX15.Font = $fontstyleitalic } 
			elseif (($DefStyle.Italic -eq "False" )-and ($DefStyle.Bold -eq "True" )) { $LabelEX15.Font = $fontstyleBold } 
			else { $LabelEX15.Font = $fontstyleregular }}
	 }
}

function FNedit ($labelobj) {
    # Display Colordialog
	$colorDialog = New-Object System.Windows.Forms.ColorDialog
	$colorDialog.AllowFullOpen = $true
	$colorDialog.FullOpen = $true
	$colorDialog.AnyColor = $true
	foreach ($DefStyle in $xmlnode) {  
		if ( $DefStyle.key -eq $labelobj.AccessibleName  ) { $colorDialog.Color = $DefStyle.ForeColor }}  #show current color
	$result = $colorDialog.ShowDialog()
   
	 if ($result  -eq "OK"  ) {  	 		
    	if ( $colorDialog.Color.Name -like "ff??????"   ) { $newcol = "#"+($colorDialog.Color.Name).remove(0,2) }
	       else {$newcol = $colorDialog.Color.Name}
		$labelobj.ForeColor = $newcol
		foreach ($DefStyle in $xmlnode) { 
			if ( $DefStyle.key -eq $labelobj.AccessibleName  ) {
			$DefStyle.ForeColor = $newcol 
			}
		}
		$script:changed = 1
		$script:saved = 0
	}
 }
  
    function FNCreateAttribute ($DefStyle,$text) {
		$newattr = $syntaxXmlData.CreateAttribute("$text")
		$newattr.Value = "False"
		$DefStyle.Attributes.Append($newattr)
  }
  
function FNitalic ($bnobj){    
	  	foreach ($DefStyle in $xmlnode) {
			if ( $DefStyle.key -eq $bnobj.AccessibleName  ) {
				if ($DefStyle.Bold -eq "True") {
							if ($DefStyle.Italic -eq "True") {
							$DefStyle.Italic = "False"
							$fontstyle=  $fontstyleBold
					}
					elseif ($DefStyle.Italic -eq "False") { 
							$DefStyle.Italic = "True" 
							$fontstyle= $fontstyleboldANDitalic
						}
				}
				else {
					if ($DefStyle.Italic -eq "True") {
							$DefStyle.Italic = "False"
							$fontstyle=  $fontstyleRegular
					}
					elseif ($DefStyle.Italic -eq "False") { 
							$DefStyle.Italic = "True" 
							$fontstyle= $fontstyleItalic
						}
				}
			 }
		}
		if ( $bnobj.AccessibleName -eq "ReservedWordStyle"   ) { $LabelEX1.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "OperatorStyle"   ) { $LabelEX2.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "OperatorWordStyle"   ) { $LabelEX3.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "VariableStyle"   ) { $LabelEX4.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "CmdletStyle"   ) { $LabelEX5.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "NetClassStaticStyle"   ) { $LabelEX6.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "NetClassStaticMethodStyle"   ) { $LabelEX7.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "CmdletParamStyle"   ) { $LabelEX8.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "NumberStyle"   ) { $LabelEX9.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "StringDelimiterStyle"   ) { $LabelEX10.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "StringDefaultStyle"   ) { $LabelEX11.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "CommentDelimiterStyle"   ) { $LabelEX12.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "CommentDefaultStyle"   ) { $LabelEX13.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "AutoVars"   ) { $LabelEX14.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "FunctionStyle"   ) { $LabelEX15.Font = $fontstyle  }
		$script:changed = 1
		$script:saved = 0
}

function FNbold ($bnobj){    
	  	foreach ($DefStyle in $xmlnode) {
			if ( $DefStyle.key -eq $bnobj.AccessibleName  ) {
				if ($DefStyle.Italic -eq "True") {
							if ($DefStyle.Bold -eq "True") {
							$DefStyle.Bold = "False"
							$fontstyle=  $fontstyleItalic
					}
					elseif ($DefStyle.Bold -eq "False") { 
							$DefStyle.Bold = "True" 
							$fontstyle= $fontstyleboldANDitalic
						}
				}
				else {
					if ($DefStyle.Bold -eq "True") {
							$DefStyle.Bold = "False"
							$fontstyle=  $fontstyleRegular
					}
					elseif ($DefStyle.Bold -eq "False") { 
							$DefStyle.Bold = "True" 
							$fontstyle= $fontstylebold
						}
				}
			 }
		}
		if ( $bnobj.AccessibleName -eq "ReservedWordStyle"   ) { $LabelEX1.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "OperatorStyle"   ) { $LabelEX2.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "OperatorWordStyle"   ) { $LabelEX3.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "VariableStyle"   ) { $LabelEX4.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "CmdletStyle"   ) { $LabelEX5.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "NetClassStaticStyle"   ) { $LabelEX6.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "NetClassStaticMethodStyle"   ) { $LabelEX7.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "CmdletParamStyle"   ) { $LabelEX8.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "NumberStyle"   ) { $LabelEX9.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "StringDelimiterStyle"   ) { $LabelEX10.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "StringDefaultStyle"   ) { $LabelEX11.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "CommentDelimiterStyle"   ) { $LabelEX12.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "CommentDefaultStyle"   ) { $LabelEX13.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "AutoVars"   ) { $LabelEX14.Font = $fontstyle  }
		if ( $bnobj.AccessibleName -eq "FunctionStyle"   ) { $LabelEX15.Font = $fontstyle  }
		$script:changed = 1
		$script:saved = 0
}

function FNRestoreBackup {
		if ($noadminrights -eq 1) { 
			[Windows.Forms.MessageBox]::Show("In order to use the restore function,`nyou must start SciptColors with Administrator privileges.", "PowerGUI ScriptColors", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information)
		return
		}
	if ( [system.io.file]::exists("$installpath\$standardbackupfile") ){ 
		$askrestore = [Windows.Forms.MessageBox]::Show("Do you want to restore the values from before the last time you saved?", "PowerGUI ScriptColors", [Windows.Forms.MessageBoxButtons]::yesno, [Windows.Forms.MessageBoxIcon]::Question)
		if( $askrestore -eq [System.Windows.Forms.DialogResult]::YES ) { 
			Remove-Item "$installpath\$syntaxXmlfile"
			Rename-Item "$installpath\$standardbackupfile" "$installpath\$syntaxXmlfile"
			FNdisplaycolors
			[Windows.Forms.MessageBox]::Show("Your changes will apply after you have restarted PowerGUI.", "PowerGUI ScriptColors", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information)
			$Form1.Close()
		}
	}
     else { [Windows.Forms.MessageBox]::Show("There is no backup file.`n If you didn't save any changes before, this is to be expected.`n If you did however save some changes this might indicate a problem.", "PowerGUI ScriptColors", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information) }
}

function FNasktosave {     
$asksave = [Windows.Forms.MessageBox]::Show("Do you want to save the changes you made?", "PowerGUI ScriptColors", [Windows.Forms.MessageBoxButtons]::yesno, [Windows.Forms.MessageBoxIcon]::Question)
 if( $asksave -eq [System.Windows.Forms.DialogResult]::YES ) { FNwritexml }
}

function FNwritexml {  
	if ($noadminrights -eq 1) { 
		[Windows.Forms.MessageBox]::Show("In order to be able to save changes,`nyou must start PowerGUI with Administrator privileges.", "PowerGUI ScriptColors", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information)
		return
		}
   if (($changed -eq 1) -and ($noadminrights -ne 1)) {
	    if ( [system.io.file]::exists("$installpath\$standardbackupfile") ){ Remove-Item "$installpath\$standardbackupfile" }
		Copy-Item "$installpath\$syntaxXmlfile" "$installpath\$standardbackupfile"  # Make Backup of current config
	    $syntaxXmlData.save("$installpath\$syntaxXmlfile")   # Save chages
	    $script:saved = 1
		$script:changed = 0
		[Windows.Forms.MessageBox]::Show("Your changes will apply after you have restarted PowerGUI.", "PowerGUI ScriptColors", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information)
	}
	$Form1.Close()
 }

 
 
FNAdminTestAndBackup
FNdisplaycolors
Main # This call must remain below all other event functions

#endregion
