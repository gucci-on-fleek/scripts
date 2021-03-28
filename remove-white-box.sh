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
# regular expression to find and remove any white polygons, then
# recompressing the PDF. This is without a doubt a horrible abuse of
# regex, but it works fairly well.

qpdf --qdf --replace-input $1 # Decompress the PDF into a simple ASCII-ish form that we can operate on with standard text processing utils

perl -pi -e 'BEGIN{undef $/;} s/(\/P <<\/MCID \d+>> BDC)( 1 g)?\s*((((-?[\d.]+ ){2,6}(m|c|l)\s*)+h\s*)|(-?[\d.]+ ){4}re\s*|f\*?\s*)+(\s*EMC)//g;' $1 # Remove the white boxes

fix-qdf $1 | sponge $1 # Fix the object numbering after we've removed objects

qpdf --linearize --compress-streams=y --recompress-flate --replace-input $1 # Recompress the PDF
