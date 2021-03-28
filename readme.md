Miscellaneous Scripts
====================

This repository contains a bunch of small and unrelated scripts that don’t deserve their own repository. Everything here has been useful to me at least once, but it may not have any use for you. 

The scripts here have been tested with recent versions of either Windows 10 or Ubuntu, and many of them will work out-of-the-box. However, many of the scripts have (complex) dependencies which may cause strange errors if not installed.

**Note:** All of these scripts are functional (as in “it works on my computer”), but there are almost certainly bugs. Almost everything here would be unsafe to use with untrusted input, and many of the scripts will fail in very common edge cases. This is not to say that these scripts aren’t useful; they just have exactly enough functionality to serve my personal needs. If there is something that isn’t working as you expect, feel free to submit an issue or a PR.

Scripts
-------

### `remove-white-box.sh`
A simple script to remove any white boxes from a PDF. 

Oftentimes, teachers will distribute a PDF with white boxes covering
up the text in order to make "fill-in-the-blank" notes. However,
sometimes you don't want to handwrite your notes and instead you just
want to have the original notes as a searchable PDF. This script will
remove any white polygons in a PDF so that any content underneath is
easily visible. 

This script works by decompressing a PDF into plain text, using a
regular expression to find and remove any white polygons, then
recompressing the PDF. This is without a doubt a horrible abuse of
regex, but it works fairly well.

Licence
-------

Unless otherwise stated, everything here is licensed under the Mozilla Public Licence version 2.0 or later.
