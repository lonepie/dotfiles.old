#$global:SvnPromptSettings.BeforeText = ' [svn: '
#$global:GitPromptSettings.BeforeText = ' [git: '
#$global:HgPromptSettings.BeforeText = ' [hg: '

$wid=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$prp=new-object System.Security.Principal.WindowsPrincipal($wid)
$adm=[System.Security.Principal.WindowsBuiltInRole]::Administrator
$IsAdmin=$prp.IsInRole($adm)

# Window title borrowed from Joel Bennett @ http://poshcode.org/1834
# This should go OUTSIDE the prompt function, it doesn't need re-evaluation
# We're going to calculate a prefix for the window title 
# Our basic title is "PoSh - C:\Your\Path\Here" showing the current path
if(!$global:WindowTitlePrefix) {
   if($IsAdmin) {
      $global:WindowTitlePrefix = "PoSh (ADMIN)"
   } else {
      $global:WindowTitlePrefix = "PoSh"
   }
}


#let g:airline_left_sep = ''
#let g:airline_left_alt_sep = ''
#let g:airline_right_sep = ''
#let g:airline_right_alt_sep = ''
#let g:airline_branch_prefix = ' '
#let g:airline_readonly_symbol = ''
#let g:airline_linecolumn_prefix = ' '

$Global:GitPromptSettings.BeforeText = '  ['

# Set up a simple prompt, adding the git/hg/svn prompt parts inside git/hg/svn repos
function prompt {
    
    #update window title
    $host.ui.rawui.windowtitle = $global:WindowTitlePrefix + " - " + $(get-location);
    
    #support my profile spread across multiple drives
    $profile_path = $env:USERPROFILE.Replace("C:", "")
    $pwd_short = $pwd.path.Replace($profile_path, "~")
    # $pwd_short = $pwd_short.Replace("\", "  ") #"
    $arrPath = $pwd_short.split("\") #"
    Write-Host "  $env:USERNAME@$env:COMPUTERNAME " -n -foregroundcolor White -backgroundcolor DarkMagenta
    Write-Host " " -n  -foregroundcolor DarkMagenta -backgroundcolor DarkGray
    # Write-Host $pwd_short -n -foregroundcolor White -backgroundcolor DarkGreen
    for($i = 0; $i -lt $arrPath.Length; $i++) {
        Write-Host $arrPath[$i] -n -f White -b DarkGray
        if($i -lt $arrPath.Length - 1) {
            Write-Host "  " -n -f Gray -b DarkGray
        } else {
            Write-Host " " -n -b DarkGray
        }
    }
    Write-Host "" -n -foregroundcolor DarkGray
    
    
    #Write-Host $env:USERNAME -n -ForegroundColor Blue
    #Write-Host "@" -n
    #write-host ([net.dns]::GetHostName()) -n -f DarkMagenta
    #Write-Host "[" -NoNewline
    #Write-Host $pwd -NoNewline -ForegroundColor DarkGreen
    #Write-Host "]" -NoNewline

        
    # Git Prompt
    $Global:GitStatus = Get-GitStatus
    #$Global:GitPromptSettings.IndexForegroundColor = [ConsoleColor]::Magenta
    
    # $Global:GitPromptSettings.DelimText = ""
    # $Global:GitPromptSettings.BeforeBackgroundColor = [ConsoleColor]::DarkGray
    # $Global:GitPromptSettings.DelimBackgroundColor = [ConsoleColor]::DarkGray
    # $Global:GitPromptSettings.AfterBackgroundColor = [ConsoleColor]::DarkGray
    # $Global:GitPromptSettings.BranchBackgroundColor = [ConsoleColor]::DarkGray
    # $Global:GitPromptSettings.BranchAheadBackgroundColor = [ConsoleColor]::DarkGray
    # $Global:GitPromptSettings.BranchBehindBackgroundColor = [ConsoleColor]::DarkGray
    # $Global:GitPromptSettings.BranchBehindAndAheadBackgroundColor = [ConsoleColor]::DarkGray
    # $Global:GitPromptSettings.BeforeIndexBackgroundColor = [ConsoleColor]::DarkGray
    # $Global:GitPromptSettings.IndexBackgroundColor = [ConsoleColor]::DarkGray
    # $Global:GitPromptSettings.WorkingBackgroundColor = [ConsoleColor]::DarkGray
    # $Global:GitPromptSettings.UntrackedBackgroundColor = [ConsoleColor]::DarkGray
    
    
    Write-GitStatus $GitStatus
#		
#	# Mercurial Prompt
#	$Global:HgStatus = Get-HgStatus
#	Write-HgStatus $HgStatus
#		
#	# Svn Prompt
#	$Global:SvnStatus = Get-SvnStatus
#	Write-SvnStatus $SvnStatus
    
    Write-Host ""
    #$promptChar = if($IsAdmin) { "#" } else { "$" }
    $promptChar = "$"
    $promptCharBg = "DarkBlue"
    $promptCharFg = "White"
    if($IsAdmin) {
        $promptChar = "#"
        $promptCharBg = "DarkRed"
        $promptCharFg = "White"
    }
    Write-Host " $promptChar " -n -foregroundcolor $promptCharFg -backgroundcolor $promptCharBg
    Write-Host "" -n -foregroundcolor $promptCharBg
    #return "`n> "
    return " "
#$ '
}

# function DevTabExpansion($lastBlock){
    # switch -regex ($lastBlock) {
        # 'dev (\S*)$' {
            # ls $dev | ?{ $_.Name -match "^$($matches[1])" }
        # }
    # }
# }

#if(-not (Test-Path Function:\DefaultTabExpansion)) { # broken
#if((Test-Path Function:\TabExpansion) -and (-not (Test-Path Function:\DefaultTabExpansion))) {
#	Rename-Item Function:\TabExpansion DefaultTabExpansion
#}
#
## Set up tab expansion and include git expansion
#function TabExpansion($line, $lastWord) {
#	$lastBlock = [regex]::Split($line, '[|;]')[-1]
#
#	switch -regex ($lastBlock) {
#		# Execute git tab completion for all git-related commands
#		'git (.*)' { GitTabExpansion $lastBlock }
#		# Execute git tab completion for all git-related commands
##		'svn (.*)' { SvnTabExpansion $lastBlock }
#		# mercurial and tortoisehg tab expansion
##		'(hg|hgtk) (.*)' { HgTabExpansion($lastBlock) }
#		# Development folder tab expansion
#		'dev (.*)' { DevTabExpansion $lastBlock }
#		# Fall back on existing tab expansion
#		default { DefaultTabExpansion $line $lastWord }
#	}
#}
