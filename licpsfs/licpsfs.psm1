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

# FILES AND FOLDERS
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

## File functions
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

# INSTALLATIONS AND EXECUTABLES


# Other helpful functions
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

