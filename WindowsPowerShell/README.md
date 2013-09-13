My PowerShell Profile
===========

This is my personal powershell profile that I clone between various Windows machines I work on

The profile also ensures that ssh-agent is running so you avoid having to type in your password every time you push/pull (ssh should be in your PATH for this to work)

I also add a few useful commands:

* gs -> "git status"
* n [path] -> "notepad"
* sudo [name] -> launch process as Administrator (in new window)
* hosts -> edit hosts file in notepad (will prompt for admin approval)
* dev -> jump to "Development" directory where you checkout your projects - tab-completion is provided for the folders under this dir (need to configure this in environment.ps1)
* dropbox -> jump to dropbox (need to configure this in environment.ps1)

Installation (Using git & powershell)
--------

1. cd ~\Documents
1. git clone https://github.com/lonepie/dotfiles.git
1. mklink /J dotfiles\WindowsPowerShell WindowsPowerShell
1. notepad environment.ps1

Edit & save the file & restart the powershell console