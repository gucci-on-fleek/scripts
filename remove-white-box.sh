#!/bin/sh

# remove-white-box.sh
# https://github.com/gucci-on-fleek/scripts/
# SPDX-License-Identifier: MPL-2.0+
# SPDX-FileCopyrightText: 2021 gucci-on-fleek
# Requires: qpdf, moreutils, perl

# A simple script to remove any white boxes from a PDF. 
#
# Oftentimes, teachers will distribute a PDF with white boxes covering
# up the text in order to make "fill-in-the-blank" notes. However,
# sometimes you don't want to handwrite your notes and instead you just
# want to have the original notes as a searchable PDF. This script will
# remove any white polygons in a PDF so that any content underneath is
# easily visible. 
#
# This script works by decompressing a PDF into plain text, using a
# regular expression to find and remove any white polygons or curves,
# then recompressing the PDF. This is without a doubt a horrible abuse
# of regex, but it works fairly well.

qpdf --qdf --replace-input $1 # Decompress the PDF into a simple ASCII-ish form that we can operate on with standard text processing utils

perl -pi -e '
    # This is where the white boxes are actually removed. Debugging this
    # is not fun, but it is the simplest way that I could find to match
    # any white objects. It works pretty fast, even on 1000 page PDFs.

    BEGIN{undef $/;} # Enter "slurp mode", which allows for multiple lines to be matched at once

    s/ # Start regex
    (\/P\ <<\/MCID\ \d+>>\ BDC) # Begin "marked content" (a group of drawing elements)
    (\ 1\ g)? # Filled with the colour white or undefined fill colour

    \s*(
        (( # White Paths
            (-? [\d.]+ \ ){2,6} # Dimension length
            (m | c | l) # Move, Curve, or Line
            \s*)+
            h \s* # Close path
            
        )| # White Rectangles
            (-? [\d.]+ \ ){4} # Dimension length
            re # Rectangle
        \s*
        | f \*? # Fill area
    \s*)+ 
    
    (\s* EMC) # End group
    //gx; # Remove any matches' $1

fix-qdf $1 | sponge $1 # Fix the object numbering after we've removed PDF objects

qpdf --linearize --compress-streams=y --recompress-flate --replace-input $1 # Recompress the PDF
