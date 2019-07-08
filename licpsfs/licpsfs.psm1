<#
        .SYNOPSIS
            licpsfs.psm1
        .DESCRIPTION
            This module implements all easy to use file system powershell functions.
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
#>

# Filesystem
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
        .NOTES
            Author        : Thomas Krampe | t.krampe@loginconsultants.de
            Version       : 1.0
            Creation date : 26.07.2018 | v0.1 | Initial function
            Last change   : 26.07.2018 | v1.0 | Release
           
            IMPORTANT NOTICE
            ----------------
            THIS FUNCTION IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
            ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR NON- INFRINGEMENT.
            LOGIN CONSULTANTS, SHALL NOT BE LIABLE FOR TECHNICAL OR EDITORIAL ERRORS OR OMISSIONS CONTAINED 
            HEREIN, NOT FOR DIRECT, INCIDENTAL, CONSEQUENTIAL OR ANY OTHER DAMAGES RESULTING FROM FURNISHING,
            PERFORMANCE, OR USE OF THIS SCRIPT, EVEN IF LOGIN CONSULTANTS HAS BEEN ADVISED OF THE POSSIBILITY
            OF SUCH DAMAGES IN ADVANCE.
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
        .NOTES
            Author        : Thomas Krampe | t.krampe@loginconsultants.de
            Version       : 1.0
            Creation date : 26.07.2018 | v0.1 | Initial function
            Last change   : 26.07.2018 | v1.0 | Release
           
            IMPORTANT NOTICE
            ----------------
            THIS FUNCTION IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
            ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR NON- INFRINGEMENT.
            LOGIN CONSULTANTS, SHALL NOT BE LIABLE FOR TECHNICAL OR EDITORIAL ERRORS OR OMISSIONS CONTAINED 
            HEREIN, NOT FOR DIRECT, INCIDENTAL, CONSEQUENTIAL OR ANY OTHER DAMAGES RESULTING FROM FURNISHING,
            PERFORMANCE, OR USE OF THIS SCRIPT, EVEN IF LOGIN CONSULTANTS HAS BEEN ADVISED OF THE POSSIBILITY
            OF SUCH DAMAGES IN ADVANCE.
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
    .NOTES
        Author        : Thomas Krampe | t.krampe@loginconsultants.de
        Version       : 1.0
        Creation date : 15.05.2017 | v0.1 | Initial function
        Last change   : 15.05.2018 | v1.0 | Release
           
        IMPORTANT NOTICE
        ----------------
        THIS FUNCTIONS IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
        ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR NON- INFRINGEMENT.
        LOGIN CONSULTANTS, SHALL NOT BE LIABLE FOR TECHNICAL OR EDITORIAL ERRORS OR OMISSIONS CONTAINED 
        HEREIN, NOT FOR DIRECT, INCIDENTAL, CONSEQUENTIAL OR ANY OTHER DAMAGES RESULTING FROM FURNISHING,
        PERFORMANCE, OR USE OF THIS SCRIPT, EVEN IF LOGIN CONSULTANTS HAS BEEN ADVISED OF THE POSSIBILITY
        OF SUCH DAMAGES IN ADVANCE.
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
        .NOTES
            Author        : Thomas Krampe | t.krampe@loginconsultants.de
            Version       : 1.1
            Creation date : 26.07.2018 | v0.1 | Initial function
            Last change   : 26.07.2018 | v1.1 | Release
           
            IMPORTANT NOTICE
            ----------------
            THIS FUNCTION IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
            ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR NON- INFRINGEMENT.
            LOGIN CONSULTANTS, SHALL NOT BE LIABLE FOR TECHNICAL OR EDITORIAL ERRORS OR OMISSIONS CONTAINED 
            HEREIN, NOT FOR DIRECT, INCIDENTAL, CONSEQUENTIAL OR ANY OTHER DAMAGES RESULTING FROM FURNISHING,
            PERFORMANCE, OR USE OF THIS SCRIPT, EVEN IF LOGIN CONSULTANTS HAS BEEN ADVISED OF THE POSSIBILITY
            OF SUCH DAMAGES IN ADVANCE.
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
