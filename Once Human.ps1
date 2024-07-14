# Define if running for Epic Games
$EPIC = 1
# Title of the game
$gamename = "Once Human"
# Define the Steam game launch URL
$gameUrl = "steam://rungameid/2139460"
# This should match the actual game's executable name (without the .exe extension)
$gameExecutableName = "ONCE_HUMAN"
# Define the domains to block
$domainsToBlock = "t.appsflyer.com", "events.appsflyer.com", "register.appsflyer.com", "conversion.appsflyer.com", "sdk.appsflyer.com"
# Get the path to the HOSTS file
$hostsFilePath = "$env:windir\System32\drivers\etc\hosts"
# Function to check if the game process is running
function Test-GameRunning {
    param (
        [string]$processName
    )
    $process = Get-Process -Name $processName -ErrorAction SilentlyContinue
    return $null -ne $process
}
if ($gameUrl -eq "steam://rungameid/2139460") {
    Write-Output @"                                                               
    ###          ##              #                  # #                
    # # ###     #   ### # #     # # ##  ### ###     # # # # ###  ## ##  
    # # # #      #  # # ###     # # # # #   ##      ### # # ### # # # # 
    # # ###       # ###   #     # # # # ### ###     # # ### # # ### # # 
    # #         ##  #   ###      #                  # #                `n
"@
} else {
    Write-Output @"                                                               
    ###          ##                 
    # # ###     #   ### # #     
    # # # #      #  # # ###     
    # # ###       # ###   #  
    # #         ##  #   ### `n
"@
}
# Check if the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")){
    Write-Output "This script requires elevated privileges to execute."
    if ($EPIC -ne 1) {
        Write-Output "Administrative rights are necessary to modify the Windows registry and the host file."
    } else {
        Write-Output "Administrative rights are necessary to modify the Windows host file."
    }
    Write-Output "These modifications are needed to block the spyware associated with $gamename."
    Write-Output "Press any key to continue or ESC to cancel and exit..."
    # Wait for user input to continue or cancel
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    if ($key.VirtualKeyCode -eq 27) {
        Write-Output "Script cancelled by user."
        Start-Sleep -Seconds 1
        exit
    }
    # Start the new process and wait for it to exit
    $newProcess = Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File', "`"$PSCommandPath`"" -Verb RunAs -PassThru
    # Close the original window
    $ps = Get-Process -Id $PID
    $ps.Close() | Out-Null
    exit
}
Write-Output "Blocking AppsFlyer in the HOSTS file"
# Check if the HOSTS file is writable
if (-not (Test-Path -Path $hostsFilePath -PathType Leaf) -or (-not (Test-Path -Path $hostsFilePath -PathType Leaf) -and (-not ((Get-Item $hostsFilePath).IsReadOnly)))) {
    Write-Output "Unable to modify the HOSTS file. Please ensure that the file isn't open in another process."
    exit
}
# Check if the domains are already blocked in the HOSTS file
$hostsContent = Get-Content -Path $hostsFilePath
foreach ($domain in $domainsToBlock) {
    if ($hostsContent -contains "127.0.0.1 $domain") {
        Write-Output "The domain '$domain' is already blocked in the HOSTS file."
    } else {
        # Add the domain to the HOSTS file
        Add-Content -Path $hostsFilePath -Value "127.0.0.1 $domain"
        Start-Sleep -Seconds 1
        Write-Output "Successfully blocked the domain '$domain' in the HOSTS file."
    }
}

if ($EPIC -ne 1) {
    # Set the __COMPAT_LAYER environment variable before launching the game executable (lower privileges)
    $env:__COMPAT_LAYER = "RunAsInvoker"
    Start-Process -FilePath $gameUrl
    Write-Output "Starting $gamename..."
    do {
        Start-Sleep -Seconds 2
        $isRunning = Test-GameRunning -processName $gameExecutableName
    } while (-not $isRunning)
    Write-Output "$gamename process has started. Monitoring until it exits..."
    while (Test-GameRunning -processName $gameExecutableName) {
        Start-Sleep -Seconds 2
    }
    Write-Output "$gamename process has exited."
    # Define the registry modification script
    $regScript = {
        # Define the path to the registry key
        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
        # Get all registry values under the specified key
        $values = Get-ItemProperty -Path $regPath
        # Loop through each value and remove all AppsFlyer entries
        foreach ($value in $values.PSObject.Properties) {
            # Check if the value name starts with "AF_"
            if ($value.Name -like "AF_*") {
                # Remove the registry value
                Remove-ItemProperty -Path $regPath -Name $value.Name
                Write-Output "Removed AppsFlyer entry: $($value.Name) : $($value.value)"
            }
        }
    }
    # Execute the registry modification script
    & $regScript
    Write-Output "Registry modification script executed successfully."
}

Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
