#!/bin/sh

# dolby-surround-encoder.sh
# https://github.com/gucci-on-fleek/scripts/
# SPDX-License-Identifier: MPL-2.0+
# SPDX-FileCopyrightText: 2021 gucci-on-fleek
# Requires: ffmpeg, sh/bash

# An encoder to convert modern 5.1 surround sound files to the ancient
# Dolby Surround/Pro Logic matrix-encoded format.
# 
# Almost all modern video/audio files that contain surround sound encode
# each channel separately. This is great for modern equipment since
# discrete channels provide much better channel separation than
# matrix-encoded channels. However, some (very old) surround decoders
# only support the Dolby Surround or Dolby Pro Logic formats, where 2 
# input channels are decoded into 4 distinct output channels. This
# script converts any surround sound format supported by ffmpeg into 
# the 2-channel Dolby Surround format.
# 
# This script follows the "official" implementation fairly closely, but
# some changes have been made from the specs so that the resultant files
# sound correct on my circa 1991 equipment. I have reduced the centre
# channel volume by 6dB (spec=3dB),  raised the LFE/subwoofer by 
# 3dB (spec=0dB), and increased the surround channel by 3dB (spec=-3dB). 
# The exact time delay required for the surround channel has not been 
# documented, so I just guessed that it was 50ms. Finally, I did not 
# apply Dolby B NR to the surround channel since I have no idea how to do 
# so with ffmpeg or any other OSS tool. 
#
# Note: This script uses the `aphaseshift` filter. This requires a *very*
# recent build of ffmpeg. Download the "git master" version of ffmpeg from
# https://johnvansickle.com/ffmpeg/ or compile from source. (This filter 
# will eventually end up in widely-released ffmpeg versions)
#
# This script is based off of the algorithms documented in:
#   - https://en.wikipedia.org/wiki/Matrix_decoder#Dolby_Stereo_and_Dolby_Surround_(matrix_4:2:4)
#   - https://en.wikipedia.org/wiki/Dolby_Pro_Logic#Dolby_Pro_Logic
#   - https://web.archive.org/web/20140326110501/http://www.dolby.com/uploadedFiles/Assets/US/Doc/Professional/208_Dolby_Surround_Pro_Logic_Decoder.pdf
#   - http://plugin.org.uk/ladspa-swh/docs/ladspa-swh.html#tth_sEc2.102

if [ -z "$2" ]; then
    echo 'Insufficient arguments.'
    echo 'dolby-surround-encoder.sh infile outfile'
    exit 1
fi

infile="$1"
outfile="$2"

filter=$(sed -zEe 's/[[:space:]]*(#[^\n]*)?\n/;/g' -e 's/;$//' <<-'EOF' # This sed command converts the commented filter to a ffmpeg-friendly form
	channelsplit=channel_layout=5.1(side)[FL][FR][FC][LFE][SL][SR] # Assign the input channel layout (assume that its 5.1)
	[SL][SR] amix [surround] # Combine both left and right surrounds since Dolby Surround only supports a single "surround" channel
	[FC] volume=0.5 [FC] # Reduce the centre volume by 6dB
	[LFE] volume=1.413 [LFE] # Boost subwoofer volume by 3dB
	[surround] volume=1.413 [surround] # Boost surround volume by 3dB
    [surround] adelay=50 [surround] # Add a 50ms delay to the surround channel to harness the Haas effect
    [surround] lowpass=f=7000 [surround] # Remove any audio above 7kHz from the surround channel
    [surround] highpass=f=100 [surround] # Remove any audio below 100Hz from the surround channel
	[surround] asplit [surround_left][surround_right] # We need to apply separate transforms to the surround channel for the left and right mix, so we duplicate it into two channels
	[LFE] asplit [lfe_l][lfe_r] # When we mix an input in, ffmpeg "uses it up", so we need still need to duplicate channels that are mixed equally into left and right
	[FC] asplit [fc_l][fc_r]
	[surround_left] aphaseshift=shift=0.5 [surround_left] # Apply the phase shift. This requires a very recent version of ffmpeg
	[surround_right] aphaseshift=shift=-0.5 [surround_right] # Complementary phase shift
	[FL][fc_l][lfe_l][surround_left] amix=inputs=4 [left] # Mix in all applicable channels into the left output
	[FR][fc_r][lfe_r][surround_right] amix=inputs=4 [right]
	[left] volume=4 [left] # amix decreases the volume by 1/n, so we need to increase it back by n
	[right] volume=4 [right]
	[left][right] join=inputs=2:channel_layout=stereo # Make a stereo track
EOF
)

ffmpeg -i "$infile" -c:v copy -af "$filter" "$outfile" # You can also use ffplay here if you want to simultaneously encode and listen
