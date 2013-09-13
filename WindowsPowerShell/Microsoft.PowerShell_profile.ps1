Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "posh-git"
Enable-GitColors

# prompt config
. .\configurePrompt.ps1

$clrDir = [System.Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()
$clrDir = split-path $clrDir
$latestClrDir = ls $clrDir | ?{$_.PSIsContainer} | select -last 1
$clrDir = join-path $clrDir $latestClrDir

$env:path = "$($env:path);$clrDir"
$env:EDITOR = "notepad"

# Define variables
. .\environment.ps1

#. .\util\ls-color.ps1

#. .\util\misc-utils.ps1

#Add-PSSnapin FindChildItemPSSnapIn01

# Define aliases & functions
function which($cmd) {
	get-command $cmd | format-table Path, Name
}

function Test-InPath($fileName){
	$found = $false
	Find-InPath $fileName | %{$found = $true}
	
	return $found
}

function Find-InPath($fileName){
	$env:PATH.Split(';') | ?{!([System.String]::IsNullOrEmpty($_))} | %{
		if(Test-Path $_){
			ls $_ | ?{ $_.Name -like $fileName }
		}
	}
}

function mklink { cmd /c mklink $args }

function Get-Git-Status{
	git status
}
set-alias gs Get-Git-Status

function Start-Explorer{
	if(!$args) { explorer . }
	else { explorer $args }
}
Set-Alias e Start-Explorer

function Start-Notepad{
	notepad $args
}
set-alias n Start-Notepad

function Start-gVim {
& 'C:\Program Files (x86)\Vim\vim73\gvim.exe' $args
}
set-alias v Start-gVim

function Start-VisualStudio{
	param([string]$projFile = "")
	
	if($projFile -eq ""){
		ls *.sln | select -first 1 | %{
			$projFile = $_
		}
	}
	
	if(($projFile -eq "") -and (Test-Path src)){
		ls src\*.sln | select -first 1 | %{
			$projFile = $_
		}
	}
	
	if($projFile -eq ""){
		echo "No project file found"
		return
	}
	
	echo "Starting visual studio with $projFile"
	. $projFile
}
set-alias vs Start-VisualStudio

function Set-Hosts{
	sudo notepad "$($env:SystemRoot)\system32\drivers\etc\hosts"
}
set-alias hosts Set-Hosts

function Kill-All{
	param([string]$name)
	get-process | ?{$_.ProcessName -eq $name -or $_.Id -eq $name} | %{kill $_.Id}
}

#empty recycle bin
function Empty-Trash {
	$Shell = New-Object -ComObject Shell.Application 
	$RecBin = $Shell.Namespace(0xA) 
	$RecBin.Items() | %{Remove-Item $_.Path -Recurse -Force}
}


#sudo
function elevate-process
{
	#$file, [string]$arguments = $args;
	#$psi = new-object System.Diagnostics.ProcessStartInfo $file;
	#$psi.Arguments = $arguments;
	#$psi.Verb = "runas";
	#$psi.WorkingDirectory = get-location;
	#[System.Diagnostics.Process]::Start($psi);
    $file, [string]$arguments = $args;
    if([System.IO.File]::Exists("$(get-location)\$file"))
    {
        $file = "$(Get-Location)\$file";
    }
    $psi = new-object System.Diagnostics.ProcessStartInfo $file;
    $psi.Arguments = $arguments;
    $psi.Verb = "runas";
    [System.Diagnostics.Process]::Start($psi);
}
set-alias sudo elevate-process;

function Reload-Profile {
    @(
        $Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost
    ) | % {
        if(Test-Path $_){
            Write-Host "Running $_"
            . $_
        }
    }    
}

# Configure ssh-agent so git doesn't require a password on every push
#if(Test-InPath ssh-agent.*){
#	. .\util\ssh-agent-utils.ps1
#}else{
#	Write-Error "ssh-agent cannot be found in your PATH, please add it"
#}

# import modules
Import-Module Find-ChildItem
# Import-Module go # conflicts with PowerTab?
Import-Module pscx
Import-Module PoshCode
Import-Module Find-String
Import-Module PsGet
Import-Module PsUrl
# Import-Module VirtualEnvWrapper # conflicts with PowerTab?
Import-Module "TabExpansion++" -ArgumentList "TabExpansion.xml"

Import-Module "PowerTab" -ArgumentList "PowerTabConfig.xml"

Pop-Location