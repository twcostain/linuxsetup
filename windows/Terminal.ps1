Get-Process Xming 2>&1 | Out-Null 
IF ( $false -eq $? ) {
    start C:\Users\$HOME\Terminal\config.xlaunch
}


Get-Process bash 2>&1 | Out-Null 
IF ( $false -eq $? ) {
    Start-Process bash.exe --norc -WindowStyle Hidden
}

bash.exe --norc -c 'NO_AT_BRIDGE=1 DISPLAY=:0 gnome-terminal --working-directory=~'
