#!/bin/bash
#
# First parameter is the file to convert, second optional parameter is the bitrate (default=2000k).
#
# This is the HTML 5 code for including the videos:
# <video width="450" controls>
#  <source src="example.ogv" type="video/ogg; codecs=theora,vorbis">
#  <source src="example.webm" type="video/webm">
#  <source src="example.mp4" type="video/mp4">
# </video>
#               
 
die () {
    echo >&2 "$@"
    exit 1
}

[ $# -ge 1 ] || die "File to convert required as argument for this script."
[ -f $1 ] || die "Argument $1 is not a regular file."

if [ $# -ge 2 ]; then
    bitrate=$2
else
    bitrate=2000k
fi

if [ $# -ge 3 ]; then
    aspect=$3
else
    aspect=16:9
fi

file=`basename $1`
file="${file%.*}"

# Ogg/Theora
ffmpeg -i $1 \
  -acodec libvorbis -ar 44100 -vb $bitrate\
  -aspect $aspect -y $file.ogv
  
# WebM/vp8
ffmpeg -i $1 -map 0:0 -map 0:1 \
  -acodec libvorbis -ar 44100 \
  -pass 1 -passlogfile $file.dv -vb $bitrate\
  -aspect $aspect -y $file.webm

ffmpeg -i $1 -map 0:0 -map 0:1 \
  -acodec libvorbis -ar 44100 \
  -pass 2 -passlogfile $file.dv -vb $bitrate\
  -aspect $aspect -y $file.webm
 
# MP4/h264
ffmpeg -i $1 \
  -acodec libfaac \
  -vcodec libx264 -vb $bitrate\
  -aspect $aspect -y $file.mp4
