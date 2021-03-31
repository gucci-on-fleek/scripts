#!/bin/sh

# noba-to-pdf.sh
# https://github.com/gucci-on-fleek/scripts/
# SPDX-License-Identifier: MPL-2.0+
# SPDX-FileCopyrightText: 2021 gucci-on-fleek
# Requires: lualatex/xelatex, html-xml-utils, pandoc, curl

# Noba (https://nobaproject.com) hosts some free (CC BY-NC-SA 4.0)
# textbooks, but they sadly do not offer PDFs or any offline downloads.
# This script scapes their website to create a LaTeX file which you can
# then compile into a PDF. This script is based off of HTML scraping, so
# it is quite fragile and thus may break at any time.

if [ -z "$2" ]; then
    echo 'Insufficient arguments.'
    echo 'noba-to-pdf.sh url outdir'
    exit 1
fi

url="$1"
outdir="$2"
mkdir -p "$outdir"
cd "$outdir"

downloadfile=$(mktemp)
outfile=$(mktemp)
texfile=$(mktemp)

cat > "$texfile" <<EOF
% A really basic LaTeX template. This is minimal-ish preamble to produce
% a nice pandoc-compatible preamble intended for screen use. I've used as
% few packages as possible while still making attractive (in my opinion)
% documents.

\documentclass[12pt]{article}

\usepackage{fontspec}
\setmainfont[Ligatures={Common, TeX}, StylisticSet=4]{FiraGO} % A high quality screen font
\usepackage{microtype}

\usepackage{booktabs, graphicx}
\def\tightlist{} % For pandoc
\usepackage{setspace}
\setstretch{1.2}
\setkeys{Gin}{width=\textwidth,height=0.45\textheight,keepaspectratio} % Make all pictures take up at most 45% of the page
\pagestyle{empty}

\makeatletter
    \renewcommand*{\fps@figure}{htb!} % Discourage float pages
    \def\@seccntformat#1{\protect\makebox[0pt][r]{\csname the#1\endcsname\quad}} % Hanging section titles
\makeatother

\widowpenalty10000
\clubpenalty10000
\flushbottom
\parskip 0pt plus 1 ex minus 0.25ex\relax

\usepackage[colorlinks=false, hidelinks]{hyperref}

\begin{document}
EOF

curl -sSL "$url" | hxnormalize -xe > "$downloadfile" # We need hxnomralize because hxselect is really picky about well-formed HTML

title=$(hxselect -c '#abstract h1' < "$downloadfile")
author=$(hxselect -c '[property="cc:attributionName"]' < "$downloadfile")

printf '\\author{%s}' "$author" >> "$texfile"
printf '\\title{\\bfseries %s}' "$title" >> "$texfile"
printf '\\date{\\normalsize\\url{%s}}' "$url" >> "$texfile" # An absolute abuse of the data command, but easier than redefining \maketitle
echo '\\maketitle' >> "$texfile"

hxselect -c 'section.content' < "$downloadfile" >> "$outfile"
hxselect 'h2#vocabulary, dl.noba-chapter-vocabulary' < "$downloadfile" >> "$outfile"

baseurl=$(echo "$url" | grep -Po 'https://[\w\d.-]*/')
sed -i 's|src="|src="'"$baseurl"'|' "$outfile" # Rewrite all URLs to absolute so that we can download the images

pandoc --from html --to markdown "$outfile" | pandoc --to latex --extract-media=. >> "$texfile" # A markdown intermediate produces way cleaner LaTeX files

echo '\\end{document}' >> "$texfile"

mv -f "$texfile" "$title".tex
rm "$downloadfile" "$outfile"

printf 'All done! Now run `lualatex "%s/%s.tex"` to get your PDF.\n' "$outdir" "$title"
