Miscellaneous Scripts
====================

This repository contains a bunch of small and unrelated scripts that don’t deserve their own repository. Everything here has been useful to me at least once, but it may not have any use for you. 

The scripts here have been tested with recent versions of either Windows 10 or Ubuntu, and many of them will work out-of-the-box. However, many of the scripts have (complex) dependencies which may cause strange errors if not installed.

**Note:** All of these scripts are functional (as in “it works on my computer”), but there are almost certainly bugs. Almost everything here would be unsafe to use with untrusted input, and many of the scripts will fail in very common edge cases. This is not to say that these scripts aren’t useful; they just have exactly enough functionality to serve my personal needs. If there is something that isn’t working as you expect, feel free to submit an issue or a PR.

Scripts
-------

### `remove-white-box.sh`
_Requires: `qpdf`, `moreutils`, `perl`_

A simple script to remove any white boxes from a PDF. 

Oftentimes, teachers will distribute a PDF with white boxes covering
up the text in order to make "fill-in-the-blank" notes. However,
sometimes you don't want to handwrite your notes and instead you just
want to have the original notes as a searchable PDF. This script will
remove any white polygons in a PDF so that any content underneath is
easily visible. 

This script works by decompressing a PDF into plain text, using a
regular expression to find and remove any white polygons or curves,
then recompressing the PDF. This is without a doubt a horrible abuse
of regex, but it works fairly well.

### `noba-to-pdf.sh`
_Requires: `lualatex`/`xelatex`, `html-xml-utils`, `pandoc`, `curl`_

Noba (https://nobaproject.com) hosts some free (CC BY-NC-SA 4.0)
textbooks, but they sadly do not offer PDFs or any offline downloads.
This script scapes their website to create a LaTeX file which you can
then compile into a PDF. This script is based off of HTML scraping, so
it is quite fragile and thus may break at any time.

### `system-cleanup.ps1`
_Requires: Windows 10_

A general (yet basic) Windows system cleanup script

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

### PowerShell Profile
_Requires: Windows 10_

A basic PowerShell profile.

I find this PowerShell profile quite useful. It is entirely tailored to
my own personal use, but hopefully you find some use for it too.

### `enbox.py`
_Requires: `python3.6+`_

This script will enclose any text in boxes like these:

<!-- We have to use HTML here because you can't include multiline
code blocks in a table using markdown -->
<table> 
    <thead><tr>
        <th><code>regular</code></th>
        <th><code>double</code></th>
        <th><code>thick</code></th>
        <th><code>curved</code></th>
    </tr></thead>
    <tbody><tr>
        <td><pre>┌───────┐
│  One  │
│  Two  │
│ Three │
└───────┘
</pre></td>
        <td><pre>╔═══════╗
║  One  ║
║  Two  ║
║ Three ║
╚═══════╝</pre></td>
        <td><pre>┏━━━━━━━┓
┃  One  ┃
┃  Two  ┃
┃ Three ┃
┗━━━━━━━┛</pre></td>
        <td><pre>╭───────╮
│  One  │
│  Two  │
│ Three │
╰───────╯</pre></td>
    </tr></tbody>
</table>

Licence
-------

Unless otherwise stated, everything here is licensed under the Mozilla Public Licence, version 2.0 or later.
