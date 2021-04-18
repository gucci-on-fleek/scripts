#Requires -RunAsAdministrator
#Requires -PSEdition Desktop

# system-cleanup.ps1
# https://github.com/gucci-on-fleek/scripts/
# SPDX-License-Identifier: MPL-2.0+
# SPDX-FileCopyrightText: 2021 gucci-on-fleek
# Requires: Windows 10

<#
.SYNOPSIS
  A general (yet basic) Windows system cleanup script

.DESCRIPTION
  This script runs various "system cleanup" tasks on a Windows computer.
  It is pretty limited in what it runs; it only runs tasks that are fairly
  safe and are almost always desirable. Nevertheless, I am not responsible
  if this script does anything bad to your computer (although I don't
  see how it could).

  Tasks Performed:
    - Windows Defender AV scan
    - CLR/.NET precompiling and caching
    - Windows System files scan and repair
    - Windows Update compaction
    - Defragmenting and TRIMming.

.LINK
  https://github.com/gucci-on-fleek/scripts/
#>


# We're using named script blocks instead of functions so that they can
# be ran asynchronously and in parallel. 

$av_scan = {
  <#
  .SYNOPSIS
    Runs a full Windows Defender scan.
  #>

  $defender = "$env:ProgramFiles\Windows Defender\MpCmdRun.exe"

  & $defender -SignatureUpdate -MMPC # Update the signature database
  & $defender -Scan -ScanType 2 # Run a full system scan
}

$cache_clr = {
  <#
  .SYNOPSIS
    Caches most CLR (.NET) assemblies (.dll's) on the system.

  .DESCRIPTION
    This should reduce or eliminate the dreaded "Loading personal
    and system profiles took 5000ms" message on PowerShell startup.
  #>

  $ngen = "$([Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory())ngen.exe"

  & $ngen update /queue # Add all stale assemblies to the queue

  [AppDomain]::CurrentDomain.GetAssemblies().Location | % {
    & $ngen install $_ /queue # Add any assemblies in the current domain to the queue
  }

  & $ngen eqi # Compile and cache the queue
}

$repair_system_files = {
  <#
  .SYNOPSIS
    Verifies and repairs and Windows system files.
  #>

  sfc /scannow # Repair system files

  # These next two commands are only strictly necessary if the first
  # command fails, but in my experience they are usually needed.
  dism /online /cleanup-image /restorehealth
  sfc /scannow
}

$compact_windows_updates = {
  <#
  .SYNOPSIS
    Reduces the space taken up by Windows Updates.

  .Description
    When Windows updates, it justs adds new files. It doesn't normally 
    remove any of the old files so that you can easily revert any bad
    updates. However, this can take up a lot (10 Gb) of space. These 
    commands consolidate any Windows Updates which can reduce the disk
    space used by Windows, but you will no longer be able to revert any
    previous updates.
  #>

  dism /online /Cleanup-Image /AnalyzeComponentStore
  dism /online /cleanup-image /startcomponentcleanup
}

$defrag_and_trim = {
  <#
  .SYNOPSIS
    Defragments and TRIMs the drives attached.

  .DESCRIPTION
    This is fine to run on an SSD. Windows will intelligently perform the 
    correct optimizations on each type of disk.
  #>
  defrag /c /h /d /l /u
}

Start-Job -ScriptBlock $av_scan
Start-Job -ScriptBlock $cache_clr # We can run these first two asynchronously
& $repair_system_files
& $compact_windows_updates
& $defrag_and_trim

echo "All done!

I also recommend deleting all of the files in:
    $env:temp
    C:\Windows\Temp
    Recycle Bin
"
