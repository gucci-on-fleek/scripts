#Requires -PSEdition Desktop

# PowerShell Profile
# https://github.com/gucci-on-fleek/scripts/
# SPDX-License-Identifier: MPL-2.0+
# SPDX-FileCopyrightText: 2021 gucci-on-fleek
# Requires: Windows 10

<#
.SYNOPSIS
  A basic PowerShell profile. 

.DESCRIPTION
  I find this PowerShell profile quite useful. It is entirely tailored to
  my own personal use, but hopefully you find some use for it too.

.LINK
  https://github.com/gucci-on-fleek/scripts/
#>

chcp 65001 | out-null # Use a Unicode console code page

new-item alias:np -value "C:\Program Files (x86)\Notepad++\notepad++.exe" | out-null
new-item alias:u -value "$env:LOCALAPPDATA\Microsoft\WindowsApps\ubuntu.exe" | out-null
rm alias:\curl # Make 'curl' use the curl executable and not the fake PowerShell default alias

Set-PSReadlineOption -BellStyle Audible -DingTone 400 -DingDuration 40
Set-PSReadlineOption -Colors @{
    "Variable"  = [ConsoleColor]::DarkRed;
    "Parameter" = [ConsoleColor]::DarkBlue;
    "Operator"  = [ConsoleColor]::DarkMagenta;
    "String"    = [ConsoleColor]::Green;
    "Number"    = [ConsoleColor]::Magenta
} # Change the default colours

function Prompt {
    $current_path = " $($executionContext.SessionState.Path.CurrentLocation)>"
    $shell_name = "Pwsh" # Write "Pwsh" instead of "PS"

    if ($Host.UI.RawUI.WindowTitle -like "*administrator*") {
        Write-Host $shell_name -NoNewline -ForegroundColor White -BackgroundColor Red; # If we're in an admin shell, write "Pwsh" in red/white
        Write-Host $current_path -NoNewline -ForegroundColor Blue;
    } else {
        Write-Host $shell_name -NoNewline -ForegroundColor Green;
        Write-Host $current_path -NoNewline -ForegroundColor Blue;
    }

    return " "
}

function touch {
    <#
    .SYNOPSIS
        A PowerShell equivalent of the UNIX 'touch' command.
    #>

    $file = $args[0]

    if (Test-Path $file) {
        (ls $file).LastWriteTime = Get-Date
    } else {
        echo $null > $file
    }
}

function activate-vs {
    <#
    .SYNOPSIS
        A PowerShell equivalent of 'vcvarsall.bat'.
    #>

    Install-Module VSSetup -Scope CurrentUser
    pushd (Get-VSSetupInstance)[0].InstallationPath 
    $cmd_args = '/c .\VC\Auxiliary\Build\vcvars32.bat'
    $cmd_args += ' & set "'# 'set "' (with the trailing quotation mark) also shows the hidden variables

    $cmd_out = & 'cmd' $cmd_args
    popd

    $env_vars = @{}
    $cmd_out | % {
        if ($_ -match '=') {
            $key, $value = $_ -split '='
            $env_vars[$key] = $value
        }
    }
    $env_vars.Keys | % {
        if ($_ -and $env_vars[$_]) {
            set-item -force -path "env:\$($_)"  -value "$($env_vars[$_])"
        }
    }
}
