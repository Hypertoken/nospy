# Once Human Spyware Blocker

This script blocks spyware by AppsFlyer when running the game "Once Human" via steam. It modifies the Windows registry and hosts file to achieve this. It's made to be adaptable to any other steam game with AppsFlyer spyware. Just change the variables; `$gamename`, `$gameUrl`, and `$gameExecutableName`.

## Features

- Blocks AppsFlyer domains by adding entries to the HOSTS file.
- Removes AppsFlyer-related entries from the Windows registry.
- Launches "Once Human" via Steam with lower privileges to avoid further modifications.
- Monitors the game process and keeps the blocks in place until the game exits.

## Prerequisites

- Windows operating system.
- Administrative privileges (the script will prompt for elevation if not run as an administrator).
- Enable PowerShell scripts  
    1.Start Windows PowerShell with the "Run as Administrator" option.  
    2 .Enable running unsigned scripts by entering:  
    ```
    set-executionpolicy remotesigned
    ```
## Usage

For Steam: Everytime you want to start the game, run the script instead of using steam directly.
For Epic: Run one time. On line 2, change the variable $EPIC = 0 to $EPIC = 1

### Copy/Paste method ###
1. Copy the contents of the PS1 file.
2. Paste them into a text file.
3. Rename the text file to your desired name, ensuring you change the file extension from .txt to .ps1
4. Right-click the newly renamed file and select "Run with PowerShell."

### Git method ###
1. **Clone the repository**:
    ```sh
    git clone https://github.com/Hypertoken/nospy.git
    cd nospy
    ```

2. **Run the script**:
    Open PowerShell as an administrator and execute the script:
    ```sh
     & '.\Once Human.ps1'
    ```
   
## Script Details

### Variables

- `$gamename` : The name of the game.
- `$gameUrl` : The Steam game launch URL.
- `$gameExecutableName` : The actual game executable name (without the `.exe` extension).
- `$domainsToBlock` : List of AppsFlyer domains to block.
- `$hostsFilePath` : Path to the HOSTS file.

### Functions

- `Test-GameRunning`: Checks if the game process is running.
- Registry modification: Removes AppsFlyer-related entries from the Windows registry.

### Execution Flow

1. Checks if running with administrative privileges.
2. Modifies the HOSTS file to block specified AppsFlyer domains.
3. Launches the game with lower privileges.
4. Monitors the game process.
5. Removes AppsFlyer entries from the registry.

## Note

Ensure that the HOSTS file isn't open in another process to avoid modification issues. The script will prompt if it cannot modify the file.
