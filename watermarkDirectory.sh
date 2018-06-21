#!/usr/bin/bash
# Watermarks the current directory by adding Directory Name-Number in bottom right corner
# and a custom text all over
# Tested with ImageMagick 7 on Windows with Cygwin
COPYRIGHT_TEXT="Gonzoway Photography"
FONT="Arial"
FILENAME_FONT_SIZE=400
COPYRIGHT_FONT_SIZE=72

COPYRIGHT_INTERMEDIATE_FILE=copyright_tile.png

# Build the copyright file
magick -font $FONT -pointsize $COPYRIGHT_FONT_SIZE -size 900x400 xc:none -fill grey -gravity Center -draw "text 0,0 '$COPYRIGHT_TEXT'" $COPYRIGHT_INTERMEDIATE_FILE

# Get the directory name
DIR_NAME=$(basename $PWD)
echo "Tagging as $DIR_NAME"
i=1

# Iterate over all jpgs
ls *.JPG | while read image
do
  echo "Handling $image as $DIR_NAME-$i"
  # Tile copyright
  magick composite -tile $COPYRIGHT_INTERMEDIATE_FILE $image wmark_$image
  # Tag corner
  magick wmark_$image -font $FONT -pointsize $FILENAME_FONT_SIZE -draw "gravity southeast fill black text 0, 0 '$DIR_NAME-$i'" wmark_$image
  i=$((i+1))
done
