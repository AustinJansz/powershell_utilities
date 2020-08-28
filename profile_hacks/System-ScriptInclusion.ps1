# Load  scripts into the running instance of PowerShell for custom functions
$scripts_path = "$HOME\scripts"
$scripts = (Get-ChildItem "$scripts_path").FullName
ForEach ($script in $scripts) {
    try {. ($script);}
    catch {Write-Host "ERROR: Could not load $script" -ForegroundColor Red;};
};