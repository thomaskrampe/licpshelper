<#
        .SYNOPSIS
            licpsfs.psm1
        .DESCRIPTION
            This module implements all easy to use powershell functions.
        .NOTES
            Author        : Thomas Krampe | t.krampe@loginconsultants.de
            Version       : 1.0
            Creation date : 07.07.2019 | v0.1 | Initial script
            Last change   : xx.xx.2019 | v1.0 | Release
           
            IMPORTANT NOTICE
            ----------------
            THIS SCRIPT IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
            ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR NON- INFRINGEMENT.
            LOGIN CONSULTANTS, SHALL NOT BE LIABLE FOR TECHNICAL OR EDITORIAL ERRORS OR OMISSIONS CONTAINED 
            HEREIN, NOT FOR DIRECT, INCIDENTAL, CONSEQUENTIAL OR ANY OTHER DAMAGES RESULTING FROM FURNISHING,
            PERFORMANCE, OR USE OF THIS SCRIPT, EVEN IF LOGIN CONSULTANTS HAS BEEN ADVISED OF THE POSSIBILITY
            OF SUCH DAMAGES IN ADVANCE.

            SPECIAL THANKS TO:
            ------------------
            Dennis Span @dennisspan
#>

# define Error handling
$global:ErrorActionPreference = "Stop"
if ($verbose) { $global:VerbosePreference = "Continue" }

#region begin FILES AND FOLDERS
Function LC_DeleteDirectory {
    <#
        .SYNOPSIS
            LC_DeleteDirectory
        .DESCRIPTION
            Delete a directory
        .PARAMETER Directory
            This parameter contains the full path to the directory which needs to be deleted (for example C:\Temp\MyFolder).
        .EXAMPLE
            LC_DeleteDirectory -Directory "C:\Temp\MyFolder"
            Deletes the directory "C:\Temp\MyFolder"
    #>
 
    [CmdletBinding()]
    Param( 
        [Parameter(Mandatory = $true, Position = 0)][String]$Directory
    )
 
    begin {
        [string]$FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose "START FUNCTION - $FunctionName"
    }
  
    process {
        Write-Verbose "Delete directory $Directory"
        if ( Test-Path $Directory ) {
            try {
                Remove-Item $Directory -force -recurse | Out-Null
                Write-Verbose "Successfully deleted the directory $Directory"
            }
            catch {
                Write-Error "An error occurred trying to delete the directory $Directory (exit code: $($Error[0]))!"
                Exit 1
            }
        }
        else {
            Write-Verbose "The directory $Directory does not exist. Nothing to do"
        }
    }
 
    end {
        Write-Verbose "END FUNCTION - $FunctionName"
    }
} #EndFunction LC_DeleteDirectory
Export-ModuleMember -Function 'LC_DeleteDirectory'

Function LC_CleanupDirectory {
    <#
    .SYNOPSIS
        LC_CleanupDirectory
    .DESCRIPTION
        Delete all files and subfolders in one specific directory, but do not delete the main folder itself
    .PARAMETER Directory
        This parameter contains the full path to the directory that needs to cleaned (for example 'C:\Temp')
    .EXAMPLE
        LC_CleanupDirectory -Directory "C:\Temp"
        Deletes all files and subfolders in the directory 'C:\Temp'
    #>
 
    [CmdletBinding()]
    Param( 
        [Parameter(Mandatory = $true, Position = 0)][String]$Directory
    )
 
    begin {
        [string]$FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose "START FUNCTION - $FunctionName"
    }
  
    process {
        if ( Test-Path $Directory ) {
            try {
                Remove-Item "$Directory\*.*" -force -recurse | Out-Null
                Remove-Item "$Directory\*" -force -recurse | Out-Null
                Write-Verbose "Successfully deleted all files and subfolders in the directory $Directory"
            }
            catch {
                Write-Verbose "An error occurred trying to delete files and subfolders in the directory $Directory (exit code: $($Error[0]))!"
                Exit 1
            }
        }
        else {
            Write-Verbose "The directory $Directory does not exist." 
        }
    }
 
    end {
        Write-Verbose "END FUNCTION - $FunctionName"
    }
} #EndFunction LC_CleanupDirectory
Export-ModuleMember -Function 'LC_CleanupDirectory'

Function LC_CompactDirectory {
    <#
        .SYNOPSIS
        Execute a process
        .DESCRIPTION
        Execute a process
        .PARAMETER Directory
        This parameter contains the full path to the directory that needs to be compacted (for example C:\Windows\WinSxS)
        .EXAMPLE
        LC_CompactDirectory -Directory "C:\Windows\WinSxS"
        Compacts the directory 'C:\Windows\WinSxS'
    #>
    [CmdletBinding()]
    Param( 
        [Parameter(Mandatory = $true, Position = 0)][String]$Directory
    )

    begin {
        [string]$FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose "START FUNCTION - $FunctionName"
    }
 
    process {
        if ( Test-Path $Directory ) {
            try {
                $params = " /C /S /I /Q /F $($Directory)\*"
                start-process "$WinDir\System32\compact.exe" $params -WindowStyle Hidden -Wait
            }
            catch {
                Exit 1
            }
        }
        else {
            Write-Verbose "The directory $Directory does not exist. Nothing to do" 
        }
    }
 
    end {
        Write-Verbose "END FUNCTION - $FunctionName"
    }
}
Export-ModuleMember -Function 'LC_CompactDirectory'

Function LC_CreateDirectory {
    <#
        .SYNOPSIS
        Create a new directory
        .DESCRIPTION
        Create a new directory
        .PARAMETER Directory
        This parameter contains the name of the new directory including the full path (for example C:\Temp\MyNewFolder).
        .EXAMPLE
        LC_CreateDirectory -Directory "C:\Temp\MyNewFolder"
        Creates the new directory "C:\Temp\MyNewFolder"
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, Position = 0)][String]$Directory
    )

    begin {
        [string]$FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose "START FUNCTION - $FunctionName" 
    }
 
    process {
        if ( Test-Path $Directory ) {
            Write-Verbose "The directory $Directory already exists."
        }
        else {
            try {
                New-Item -ItemType Directory -Path $Directory -force | Out-Null
            }
            catch {
                Exit 1
            }
        }
    }

    end {
        Write-Verbose "END FUNCTION - $FunctionName"
    }
}
Export-ModuleMember -Function 'LC_CreateDirectory'

Function LC_DeleteFile {
    <#
        .SYNOPSIS
            LC_DeleteFile
        .DESCRIPTION
            Delete files
        .PARAMETER File
            This parameter contains the full path to the file that needs to be deleted (for example C:\Temp\MyFile.txt).
        .EXAMPLE
            LC_DeleteFile -File "C:\Temp\*.txt"
            Deletes all files in the directory "C:\Temp" that have the file extension *.txt. *.txt. Files stored within subfolders of 'C:\Temp' are NOT deleted
    #>
     
    [CmdletBinding()]
    Param( 
        [Parameter(Mandatory = $true, Position = 0)][String]$File
    )
  
    begin {
        [string]$FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose "START FUNCTION - $FunctionName"
    }
  
    process {
        Write-Verbose "Delete the file '$File'"
        if ( Test-Path $File ) {
            try {
                Remove-Item "$File" | Out-Null
                Write-Verbose "Successfully deleted the file '$File'"
            }
            catch {
                Write-Error "An error occurred trying to delete the file '$File' (exit code: $($Error[0]))!"
                Exit 1
            }
        }
        else {
            Write-Verbose "The file '$File' does not exist. Nothing to do"
        }
    }
  
    end {
        Write-Verbose "END FUNCTION - $FunctionName"
    }
} #EndFunction LC_DeleteFile
Export-ModuleMember -Function 'LC_DeleteFile'
Function LC_CopyFile {
    <#
        .SYNOPSIS
        Copy one or more files
        .DESCRIPTION
        Copy one or more files
        .PARAMETER SourceFiles
        This parameter can contain multiple file and folder combinations including wildcards. UNC paths can be used as well. 
        .PARAMETER Destination
        This parameter contains the destination path (for example 'C:\Temp2' or 'C:\MyPath\MyApp'). This path may also include a file name.
        This situation occurs when a single file is copied to another directory and renamed in the process (for example '$Destination = C:\Temp2\MyNewFile.txt').
        UNC paths can be used as well. The destination directory is automatically created if it does not exist (in this case the function 'LC_CreateDirectory' is called). 
        This works both with local and network (UNC) directories. In case the variable $Destination contains a path and a file name, the parent folder is 
        automatically extracted, checked and created if needed. 
        Please see the examples for more information.To see the examples, please enter the following PowerShell command: Get-Help DS_CopyFile -examples
        .EXAMPLE
        LC_CopyFile -SourceFiles "C:\Temp\MyFile.txt" -Destination "C:\Temp2"
        Copies the file 'C:\Temp\MyFile.txt' to the directory 'C:\Temp2'
        .EXAMPLE
        LC_CopyFile -SourceFiles "C:\Temp\MyFile.txt" -Destination "C:\Temp2\MyNewFileName.txt"
        Copies the file 'C:\Temp\MyFile.txt' to the directory 'C:\Temp2' and renames the file to 'MyNewFileName.txt'
        .EXAMPLE
        LC_CopyFile -SourceFiles "C:\Temp\*.txt" -Destination "C:\Temp2"
        Copies all files with the file extension '*.txt' in the directory 'C:\Temp' to the destination directory 'C:\Temp2'
        .EXAMPLE
        LC_CopyFile -SourceFiles "C:\Temp\*.*" -Destination "C:\Temp2"
        Copies all files within the root directory 'C:\Temp' to the destination directory 'C:\Temp2'. Subfolders (including files within these subfolders) are NOT copied.
        .EXAMPLE
        LC_CopyFile -SourceFiles "C:\Temp\*" -Destination "C:\Temp2"
        Copies all files in the directory 'C:\Temp' to the destination directory 'C:\Temp2'. Subfolders as well as files within these subfolders are also copied.
        .EXAMPLE
        LC_CopyFile -SourceFiles "C:\Temp\*.txt" -Destination "\\localhost\Temp2"
        Copies all files with the file extension '*.txt' in the directory 'C:\Temp' to the destination directory '\\localhost\Temp2'. The directory in this example is a network directory (UNC path).
    #>
    [CmdletBinding()]
    Param( 
        [Parameter(Mandatory = $true, Position = 0)][String]$SourceFiles,
        [Parameter(Mandatory = $true, Position = 1)][String]$Destination
    )

    begin {
        [string]$FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose "START FUNCTION - $FunctionName"
    }
 
    process {
        # Retrieve the parent folder of the destination path
        if ( $Destination.Contains(".") ) {
            # In case the variable $Destination contains a dot ("."), return the parent folder of the path
            $TempFolder = split-path -path $Destination
        }
        else {
            $TempFolder = $Destination
        }

        # Check if the destination path exists. If not, create it.
        if ( Test-Path $TempFolder) {
            Write-Verbose "The destination path '$TempFolder' already exists." 
        }
        else {
            Write-Verbose "The destination path '$TempFolder' does not exist" 
            LC_CreateDirectory -Directory $TempFolder
        }

        # Copy the source files
        try {
            Copy-Item $SourceFiles -Destination $Destination -Force -Recurse
        }
        catch {
            Exit 1
        }
    }

    end {
        Write-Verbose "END FUNCTION - $FunctionName"
    }
}
Export-ModuleMember -Function 'LC_CopyFile'

Function LC_RenameItem {
    <#
        .SYNOPSIS
        Rename files and folders
        .DESCRIPTION
        Rename files and folders
        .PARAMETER ItemPath
        This parameter contains the full path to the file or folder that needs to be renamed (for example 'C:\Temp\MyOldFileName.txt' or 'C:\Temp\MyOldFolderName')
        .PARAMETER NewName
        This parameter contains the new name of the file or folder (for example 'MyNewFileName.txt' or 'MyNewFolderName')
        .EXAMPLE
        LC_RenameItem -ItemPath "C:\Temp\MyOldFileName.txt" -NewName "MyNewFileName.txt"
        Renames the file "C:\Temp\MyOldFileName.txt" to "MyNewFileName.txt". The parameter 'NewName' only requires the new file name without specifying the path to the file
        .EXAMPLE
        LC_RenameItem -ItemPath "C:\Temp\MyOldFileName.txt" -NewName "MyNewFileName.rtf"
        Renames the file "C:\Temp\MyOldFileName.txt" to "MyNewFileName.rtf". Besides changing the name of the file, the file extension is modified as well. Please make sure that the new file format is compatible with the original file format and can actually be opened after being renamed! The parameter 'NewName' only requires the new file name without specifying the path to the file
        .EXAMPLE
        LC_RenameItem -ItemPath "C:\Temp\MyOldFolderName" -NewName "MyNewFolderName"
        Renames the folder "C:\Temp\MyOldFolderName" to "C:\Temp\MyNewFolderName". The parameter 'NewName' only requires the new folder name without specifying the path to the folder
    #>
    [CmdletBinding()]
    Param( 
        [Parameter(Mandatory = $true, Position = 0)][String]$ItemPath,
        [Parameter(Mandatory = $true, Position = 1)][String]$NewName
    )

    begin {
        [string]$FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose "START FUNCTION - $FunctionName"
    }
 
    process {
        # Rename the item (if exist)
        if ( Test-Path $ItemPath ) {
            try {
                Rename-Item -path $ItemPath -NewName $NewName | Out-Null
            }
            catch {
                Exit 1
            }
        }
        else {
            Write-Verbose "The item '$ItemPath' does not exist."
        }
    }
 
    end {
        Write-Verbose "END FUNCTION - $FunctionName" 
    }
}
Export-ModuleMember -Function 'LC_RenameItem'
#endregion

#region begin INSTALLATIONS AND EXECUTABLES
Function LC_ExecuteProcess {
    <#
        .SYNOPSIS
        Execute a process
        .DESCRIPTION
        Execute a process
        .PARAMETER FileName
        This parameter contains the full path including the file name and file extension of the executable (for example C:\Temp\MyApp.exe).
        .PARAMETER Arguments
        This parameter contains the list of arguments to be executed together with the executable
        .EXAMPLE
        LC_ExecuteProcess -FileName "C:\Temp\MyApp.exe" -Arguments "-silent"
        Executes the file 'MyApp.exe' with arguments '-silent'
    #>
    [CmdletBinding()]
    Param( 
        [Parameter(Mandatory = $true, Position = 0)][String]$FileName,
        [Parameter(Mandatory = $true, Position = 1)][String]$Arguments
    )

    begin {
        [string]$FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose "START FUNCTION - $FunctionName" 
    }
 
    process {
        $Process = Start-Process $FileName -ArgumentList $Arguments -wait -NoNewWindow -PassThru
        $Process.HasExited
        $ProcessExitCode = $Process.ExitCode
        if ( $ProcessExitCode -eq 0 ) {
            Write-Verbose "The process '$Filename' with arguments '$Arguments' ended successfully" $LogFile
        }
        else {
            Write-Error "An error occurred trying to execute the process '$Filename' with arguments '$Arguments' (exit code: $ProcessExitCode)!" 
            Exit 1
        }
    }
 
    end {
        Write-Verbose "END FUNCTION - $FunctionName" $LogFile
    }
}
Export-ModuleMember -Function 'LC_ExecuteProcess'

Function LC_InstallOrUninstallSoftware {
    <#
        .SYNOPSIS
        Install or uninstall software (MSI or SETUP.exe)
        .DESCRIPTION
        Install or uninstall software (MSI or SETUP.exe)
        .PARAMETER File
        This parameter contains the file name including the path and file extension, for example 'C:\Temp\MyApp\Files\MyApp.msi' or 'C:\Temp\MyApp\Files\MyApp.exe'.
        .PARAMETER Installationtype
        This parameter contains the installation type, which is either 'Install' or 'Uninstall'.
        .PARAMETER Arguments
        This parameter contains the command line arguments. The arguments list can remain empty.
        In case of an MSI, the following parameters are automatically included in the function and do not have
        to be specified in the 'Arguments' parameter: /i (or /x) /qn /norestart /l*v "c:\Logs\MyLogFile.log"
        .EXAMPLE
        LC_InstallOrUninstallSoftware -File "C:\Temp\MyApp\Files\MyApp.msi" -InstallationType "Install" -Arguments ""
        Installs the MSI package 'MyApp.msi' with no arguments (the function already includes the following default arguments: /i /qn /norestart /l*v $LogFile)
        .Example
        LC_InstallOrUninstallSoftware -File "C:\Temp\MyApp\Files\MyApp.msi" -InstallationType "Uninstall" -Arguments ""
        Uninstalls the MSI package 'MyApp.msi' (the function already includes the following default arguments: /x /qn /norestart /l*v $LogFile)
        .Example
        LC_InstallOrUninstallSoftware -File "C:\Temp\MyApp\Files\MyApp.exe" -InstallationType "Install" -Arguments "/silent /logfile:C:\Logs\MyApp\log.log"
        Installs the SETUP file 'MyApp.exe'
    #>
    [CmdletBinding()]
    Param( 
        [Parameter(Mandatory = $true, Position = 0)][String]$File,
        [Parameter(Mandatory = $true, Position = 1)][AllowEmptyString()][String]$Installationtype,
        [Parameter(Mandatory = $true, Position = 2)][AllowEmptyString()][String]$Arguments
    )
    
    begin {
        [string]$FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose "START FUNCTION - $FunctionName"
    }
    
    process {
        $FileName = ($File.Split("\"))[-1]
        $FileExt = $FileName.SubString(($FileName.Length) - 3, 3)
 
        # Prepare variables
        if ( !( $FileExt -eq "MSI") ) { $FileExt = "SETUP" }
        if ( $Installationtype -eq "Uninstall" ) {
            $Result1 = "uninstalled"
            $Result2 = "uninstallation"
        }
        else {
            $Result1 = "installed"
            $Result2 = "installation"
        }
        $LogFileAPP = Join-path $LogDir ( "$($Installationtype)_$($FileName.Substring(0,($FileName.Length)-4))_$($FileExt).log" )
     
        # Check if the installation file exists
        if (! (Test-Path $File) ) {    
            Write-Host "The file '$File' does not exist!" 
            Exit 1
        }
    
        # Check if custom arguments were defined
        if ([string]::IsNullOrEmpty($Arguments)) {
            Write-Verbose "File arguments: <no arguments defined>"
        }
        Else {
            Write-Verbose "File arguments: $Arguments"
        }
 
        # Install the MSI or SETUP.exe
        if ( $FileExt -eq "MSI" ) {
            if ( $Installationtype -eq "Uninstall" ) {
                $FixedArguments = "/x ""$File"" /qn /norestart /l*v ""$LogFileAPP"""
            }
            else {
                $FixedArguments = "/i ""$File"" /qn /norestart /l*v ""$LogFileAPP"""
            }
            if ([string]::IsNullOrEmpty($Arguments)) {
                # check if custom arguments were defined
                $arguments = $FixedArguments
                Write-Verbose "Command line: Start-Process -FilePath 'msiexec.exe' -ArgumentList $arguments -Wait -PassThru"
                $process = Start-Process -FilePath 'msiexec.exe' -ArgumentList $arguments -Wait -PassThru
            }
            Else {
                $arguments = $FixedArguments + " " + $arguments
                Write-Verbose "Command line: Start-Process -FilePath 'msiexec.exe' -ArgumentList $arguments -Wait -PassThru"
                $process = Start-Process -FilePath 'msiexec.exe' -ArgumentList $arguments -Wait -PassThru
            }
        }
        Else {
            if ([string]::IsNullOrEmpty($Arguments)) {
                # check if custom arguments were defined
                Write-Verbose "Command line: Start-Process -FilePath ""$File"" -Wait -PassThru" 
                $process = Start-Process -FilePath "$File" -Wait -PassThru
            }
            Else {
                Write-Verbose "Command line: Start-Process -FilePath ""$File"" -ArgumentList $arguments -Wait -PassThru"
                $process = Start-Process -FilePath "$File" -ArgumentList $arguments -Wait -PassThru
            }
        }
 
        # Check the result (the exit code) of the installation
        switch ($Process.ExitCode) {        
            0 { Write-Host "The software was $Result1 successfully (exit code: 0)" }
            3 { Write-Host "The software was $Result1 successfully (exit code: 3)" } # Some Citrix products exit with 3 instead of 0
            1603 { Write-Host "A fatal error occurred (exit code: 1603). Some applications throw this error when the software is already (correctly) installed! Please check." }
            1605 { Write-Host "The software is not currently installed on this machine (exit code: 1605)" }
            1619 { 
                Write-Host "The installation files cannot be found. The PS1 script should be in the root directory and all source files in the subdirectory 'Files' (exit code: 1619)"
                Exit 1
            }
            3010 { Write-Host "A reboot is required (exit code: 3010)!" }
            default { 
                [string]$ExitCode = $Process.ExitCode
                Write-Host "The $Result2 ended in an error (exit code: $ExitCode)!" 
                Exit 1
            }
        }
    }
 
    end {
        Write-Verbose "I" "END FUNCTION - $FunctionName"
    }
}
Export-ModuleMember -Function 'LC_InstallOrUninstallSoftware'
#endregion

#region begin LOGFILES
Function LC_ClearEventLogs() {
    <#
        .SYNOPSIS
        Clear all event logs
        .DESCRIPTION
        Clear all event logs
        .EXAMPLE
        LC_ClearEventLogs
        Loops through all event logs on the local system and clears (deletes) all entries in each of the logs founds
    #>
    [CmdletBinding()]
    Param( 
    )

    begin {
        [string]$FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose "START FUNCTION - $FunctionName"
    }
 
    process {
        # Retrieve all event logs on the current system
        $EventlogList = Get-EventLog -List

        Foreach ($EventLog in $EventlogList) {
            $EventLogName = $EventLog.Log
            try {
                Clear-EventLog -LogName $EventLogName | Out-Null
            }
            catch {
                Write-Host "An error occurred trying to clear the event log $EventLogName (error: $($Error[0]))!"
                Exit 1
            }
        }
    }
 
    end {
        Write-Verbose "END FUNCTION - $FunctionName"
    }
}

Function LC_WriteToEventLog {
    <#
        .SYNOPSIS
        Write an entry into the Windows event log. New event logs as well as new event sources are automatically created.
        .DESCRIPTION
        Write an entry into the Windows event log. New event logs as well as new event sources are automatically created.
        .PARAMETER EventLog
        This parameter contains the name of the event log the entry should be written to (e.g. Application, Security, System or a custom one)
        .PARAMETER Source
        This parameter contains the source (e.g. 'MyScript')
        .PARAMETER EventID
        This parameter contains the event ID number (e.g. 3000)
        .PARAMETER Type
        This parameter contains the type of message. Possible values are: Information | Warning | Error
        .PARAMETER Message
        This parameter contains the event log description explaining the issue
        .Example
        LC_WriteToEventLog -EventLog "System" -Source "MyScript" -EventID "3000" -Type "Error" -Message "An error occurred"
        Write an error message to the System event log with the source 'MyScript' and event ID 3000. The unknown source 'MyScript' is automatically created
        .Example
        LC_WriteToEventLog -EventLog "Application" -Source "Something" -EventID "250" -Type "Information" -Message "Information: action completed successfully"
        Write an information message to the Application event log with the source 'Something' and event ID 250. The unknown source 'Something'�is automatically created
        .Example
        LC_WriteToEventLog -EventLog "MyNewEventLog" -Source "MyScript" -EventID "1000" -Type "Warning" -Message "Warning. There seems to be an issue"
        Write an warning message to the event log called 'MyNewEventLog' with the source 'MyScript' and event ID 1000. The unknown event log�'MyNewEventLog' and�source 'MyScript'�are automatically created
    #>
    [CmdletBinding()]
    Param( 
        [parameter(mandatory = $True)]  
        [ValidateNotNullorEmpty()]
        [String]$EventLog,
        [parameter(mandatory = $True)]  
        [ValidateNotNullorEmpty()]
        [String]$Source,
        [parameter(mandatory = $True)]
        [Int]$EventID,
        [parameter(mandatory = $True)]
        [ValidateNotNullorEmpty()]
        [String]$Type,
        [parameter(mandatory = $True)]
        [ValidateNotNullorEmpty()]
        [String]$Message
    )
 
    begin {
        [string]$FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose "START FUNCTION - $FunctionName" $LogFile
    }
 
    process {
        # Check if the event log exist. If not, create it.
        if ( !( [System.Diagnostics.EventLog]::Exists( $EventLog ) ) ) {
            try {
                New-EventLog -LogName $EventLog -Source $EventLog
            }
            catch {
                Write-Host "An error occurred trying to create the event log '$EventLog' (error: $($Error[0]))!"
            }
        }
        else {
            Write-Verbose "The event log '$EventLog' already exists."
        }

        # Check if the event source exist. If not, create it.
        if ( !( [System.Diagnostics.EventLog]::SourceExists( $Source ) ) ) {
            try {
                [System.Diagnostics.EventLog]::CreateEventSource( $Source, $EventLog )	
            }
            catch {
                Write-Host "An error occurred trying to create the event source '$Source' (error: $($Error[0]))!"
            }
        }
        else {
            Write-Verbose "The event source '$Source' already exists."
        }
        		
        # Write the event log entry
        try {
            Write-EventLog -LogName $EventLog -Source $Source -eventID $EventID -EntryType $Type -message $Message
        }
        catch {
            Write-Host "An error occurred trying to write the event log entry (error: $($Error[0]))!"
        }
    }
 
    end {
        Write-Verbose "END FUNCTION - $FunctionName"
    }
}


#endregion

#region OTHER FUNCTIONS
Function LC_IsAdmin {
    <#
        .SYNOPSIS
            LC_IsAdmin
        .DESCRIPTION
            Check if the user running this script has admin permissions
        .EXAMPLE
            LC_IsAdmin
        .OUTPUTS
            Boolean
    #>
     
    begin {
    }
 
    process {
        ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    }
     
    end {
    }
     
} #Endfunction LC_IsAdmin
Export-ModuleMember -Function 'LC_IsAdmin'

Function LC_SignScript {
    <#
        .SYNOPSIS
        Digitally signs a PowerShell script using a code signing certificate.
        .DESCRIPTION
        Digitally signs a PowerShell script using a code signing certificate installed on the local machine.
        .EXAMPLE
        LC_SignScript .\MyScript.ps1

        Description
        -----------
        Runs script with default values. If there is a single code signing certificate, it will be used. If there is more than one valid code signing certificate, a popup will display the certificates and allow one to be chosen.
        .EXAMPLE
        LC_SignScript .\MyScript.ps1 -CodeSigningCert 0

        Description
        -----------
        Signs the specified script, MyScript.ps1, with the first code signing certificate found.
        .INPUTS
        None. You cannot pipe objects to this script.
    #>
    [CmdletBinding()]
    param (
        # Path (including file name) of script to sign
        [parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Mandatory, HelpMessage = 'No filename specified')]
        [ValidatePattern('.ps1$|.psm1$')]
        [ValidateNotNullOrEmpty()]
        [string] $FileName,
		
        # Index number of code signing certificate to use
        [parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $CodeSigningCerificate
    ) 
    BEGIN	{
        [string]$FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose "START FUNCTION - $FunctionName"
        Write-Verbose -Message 'Getting certificate available for codesigning'
        # [int] $totalvalidcerts = (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert | Where-Object {$_.NotAfter -gt (Get-Date)}).length
        [int] $totalvalidcerts = (Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert | Where-Object { $_.Verify() }).length
        if ($totalvalidcerts -eq 1) {
            # [Security.Cryptography.X509Certificates.X509Certificate2] $cert = (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert | Where-Object {$_.NotAfter -ge (Get-Date)})[0]
            [Security.Cryptography.X509Certificates.X509Certificate2] $cert = (Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert | Where-Object { $_.Verify() })[0]
        }
        elseif (($CodeSigningCerificate) -and ($totalvalidcerts -gt 1)) {
            # [Security.Cryptography.X509Certificates.X509Certificate2] $cert = (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert | Where-Object {$_.NotAfter -ge (Get-Date)})[$CodeSigningCerificate]
            [Security.Cryptography.X509Certificates.X509Certificate2] $cert = (Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert | Where-Object { $_.Verify() })[$CodeSigningCerificate]
        }
        else {
            # [Security.Cryptography.X509Certificates.X509Certificate2] $cert = (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert | Where-Object {$_.NotAfter -ge (Get-Date)} | Out-GridView -Title "Valid certificates" -OutputMode Single)[0]
            [Security.Cryptography.X509Certificates.X509Certificate2] $cert = (Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert | Where-Object { $_.Verify() } | Out-GridView -Title 'Valid certificates' -OutputMode Single)[0]
        }
    }
    PROCESS	{
        if ($cert) {
            Write-Verbose -Message ('{0} valid certificate(s) found' -f $totalvalidcerts)
            Write-Verbose -Message ('Signing "{0}" with {1}' -f $FileName, $cert)
            $null = Set-AuthenticodeSignature -FilePath $FileName -Certificate $cert -TimestampServer 'http://timestamp.digicert.com'
            Write-Verbose -Message 'Checking validity'
            $valid = ((Get-AuthenticodeSignature -FilePath $FileName).status -Match 'Valid')
            if ($valid) {
                Write-Verbose -Message ('Signing {0} succeeded' -f $FileName)
            }
            else {
                Write-Error -Message ('Signing {0} failed' -f $FileName)
            }
        }
        else {
            Write-Error -Message 'No valid codesigning certificate found'
        }		
    } # end process block
    END	{
        Remove-Variable -Name Valid
        Remove-Variable -Name FileName
        Remove-Variable -Name Cert
        Write-Verbose "END FUNCTION - $FunctionName"
    }
}
Export-ModuleMember -Function 'LC_SignScript'
#endregion
