$home2 = 'E:\Users\Jon\'
$dev = Join-Path $home2 'Dev'
$downloads = Join-Path $home2 'Downloads'
$android = Join-Path $downloads 'android'

function Set-Location-AltProfile($folder){
	Push-Location
	
	if($folder -ne ""){
		$path = Join-Path -Path $home2 -ChildPath $folder
        cd $path
		return
	}
	
	cd $home2
}
set-alias home2 Set-Location-AltProfile

# Enable Dropbox integration - uncomment below line (and fix path)
$dropbox = Join-Path $home2 'Dropbox'
if($dropbox -ne $null -and (Test-Path $dropbox)){
	. .\Util\Dropbox.ps1
}

function Set-Location-Dev($folder){
	Push-Location
	
	if($folder -ne ""){
		cd "$dev\$folder"
		return
	}
	
	cd $dev
}
set-alias dev Set-Location-Dev

function Set-Location-Android($folder){
	Push-Location
	
	if($folder -ne ""){
		cd "$android\$folder"
		return
	}
	
	cd $android
}
Set-Alias android Set-Location-Android

function Set-Location-Downloads($folder) {
    Push-Location
    if($folder -ne ""){
        cd "$downloads\$folder"
        return
    }
	cd $downloads
}
Set-Alias downloads Set-Location-Downloads

function Set-Location-PsProfile{
	Push-Location
	#cd ~\Documents\WindowsPowerShell
    cd $home2 + "Documents\WindowsPowerShell"
}
set-alias psprofile Set-Location-PsProfile