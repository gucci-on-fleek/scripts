Miscellaneous Scripts
====================

This repository contains a bunch of small and unrelated scripts that don’t deserve their own repository. Everything here has been useful to me at least once, but it may not have any use for you. 

The scripts here have been tested with recent versions of either Windows 10 or Ubuntu, and many of them will work out-of-the-box. However, many of the scripts have (complex) dependencies which may cause strange errors if not installed.

**Note:** All of these scripts are functional (as in “it works on my computer”), but there are almost certainly bugs. Almost everything here would be unsafe to use with untrusted input, and many of the scripts will fail in very common edge cases. This is not to say that these scripts aren’t useful; they just have exactly enough functionality to serve my personal needs. If there is something that isn’t working as you expect, feel free to submit an issue or a PR.

Scripts
-------

### `remove-white-box.sh`
_Requires: `sh`/`bash`, `qpdf`, `moreutils`, `perl`_

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
_Requires: `sh`/`bash`, `lualatex`/`xelatex`, `html-xml-utils`, `pandoc`, `curl`_

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

### `awake.pyw`
_Requires: `python3`, Windows_

This script allows you to prevent your computer from sleeping. It opens
up a dialog box that allows for you to enter the number of minutes that
you want to keep your computer awake. This script only uses modules from
the Python Standard Library, so it will work on any Windows computer
with a Python installation.

### `keyboard-shortcuts.ahk`
_Requires: `AutoHotKey`_

A script that defines some basic keyboard shortcuts. All of the shortcuts defined here
should be fairly non-intrusive; I personally use this script in addition to some much 
more radical remappings.

<details><summary>Full Shortcut Listing</summary><dl>
    <dt> <code>Win</code> + <code>Z</code> </dt> <dd>Launch Windows Terminal</dd> 
    <dt> <code>Win</code> + <code>Shift</code> + <code>Z</code> </dt> <dd>Launch Windown Terminal as Admin</dd> 
    <dt> <code>Win</code> + <code>Ctrl</code> + <code>Space</code> </dt> <dd>Make the current window s-on-top</dd> 
    <dt> <code>Win</code> + <code>Shift</code> + <code>Space</code> </dt> <dd>Insert narrow no-break space</dd> 
    <dt> <code>Win</code> + <code>Numpad Minus</code> </dt> <dd>Insert En Dash</dd> 
    <dt> <code>Win</code> + <code>Shift</code> + <code>Numpad Minus</code> </dt> <dd>Insert Em Dash</dd> 
    <dt> <code>Win</code> + <code>Numpad Asterisk</code> </dt> <dd>Insert Multiplication Sign</dd> 
    <dt> <code>Win</code> + <code>Numpad Slash</code> </dt> <dd>Insert Division Sign</dd> 
    <dt> <code>Win</code> + <code>Shift</code> + <code>^</code> , Any Digit </dt> <dd>Insert Superscript number</dd> 
    <dt> <code>Win</code> + <code>Shift</code> + <code>_</code> , Any Digit </dt> <dd>Insert Subscript number</dd> 
    <dt> <code>Win</code> + <code>Ctrl</code> + <code>G</code> , Any Letter </dt> <dd>Insert Greek Letter</dd> 
    <dt> <code>Win</code> + <code>Ctrl</code> + <code>.</code> </dt> <dd>Insert Ellipsis </dd> 
    <dt> <code>Win</code> + <code>Ctrl</code> + <code>V</code> </dt> <dd>Paste as Plain Text</dd> 
    <dt> <code>Win</code> + <code>Ctrl</code> + <code>C</code> </dt> <dd>Rapidly left-click until any keyboard key is pressed</dd> 
    <dt> Three Finger Touchpad Tap </dt> <dd>Middle Click</dd>
</dl></details>

### `dolby-surround-encoder.sh`
_Requires: `sh`/`bash`, `ffmpeg`_

An encoder to convert modern 5.1 surround sound files to the ancient
Dolby Surround/Pro Logic matrix-encoded format.

Almost all modern video/audio files that contain surround sound encode
each channel separately. This is great for modern equipment since
discrete channels provide much better channel separation than
matrix-encoded channels. However, some (very old) surround decoders
only support the Dolby Surround or Dolby Pro Logic formats, where 2 
input channels are decoded into 4 distinct output channels. This
script converts any surround sound format supported by ffmpeg into 
the 2-channel Dolby Surround format.

This script follows the "official" implementation fairly closely, but
some changes have been made from the specs so that the resultant files
sound correct on my circa 1991 equipment. I have reduced the centre
channel volume by 6dB (spec=3dB),  raised the LFE/subwoofer by 
3dB (spec=0dB), and increased the surround channel by 3dB (spec=-3dB). 
The exact time delay required for the surround channel has not been 
documented, so I just guessed that it was 50ms. Finally, I did not 
apply Dolby B NR to the surround channel since I have no idea how to do 
so with ffmpeg or any other OSS tool. 

Note: This script uses the `aphaseshift` filter. This requires a *very*
recent build of ffmpeg. Download the "git master" version of ffmpeg from
https://johnvansickle.com/ffmpeg/ or compile from source. (This filter 
will eventually end up in widely-released ffmpeg versions)

This script is based off of the algorithms documented in:
  - https://en.wikipedia.org/wiki/Matrix_decoder#Dolby_Stereo_and_Dolby_Surround_(matrix_4:2:4)
  - https://en.wikipedia.org/wiki/Dolby_Pro_Logic#Dolby_Pro_Logic
  - https://web.archive.org/web/20140326110501/http://www.dolby.com/uploadedFiles/Assets/US/Doc/Professional/208_Dolby_Surround_Pro_Logic_Decoder.pdf
  - http://plugin.org.uk/ladspa-swh/docs/ladspa-swh.html#tth_sEc2.102

Licence
-------

Unless otherwise stated, everything here is licensed under the Mozilla Public Licence, version 2.0 or later.
