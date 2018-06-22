#!/usr/bin/bash
# Watermarks the current directory by adding Directory Name-Number in bottom right corner
# and a custom text all over
# Tested with ImageMagick 7 on Windows with Cygwin
COPYRIGHT_TEXT="Gonzoway Photography"
FONT="Segoe-Print"
FILENAME_FONT_SIZE=200

# Get the directory name
DIR_NAME=$(basename $PWD)
echo "Tagging as $DIR_NAME"
i=1

# Iterate over all jpgs
ls *.JPG | while read image
do
  # Get the width of the image for copyright text
  # Add copyright text
  SIZE=$(magick identify $image | cut -d ' ' -f 3)
  echo "Handling $image as $DIR_NAME-$i size $SIZE" 
  # Experimentally found that image size / 10 - 100 was about right
  DYNAMIC_SIZE="${SIZE:0:2}0"
  DYNAMIC_SIZE=$((DYNAMIC_SIZE-100))
  echo "Font size $DYNAMIC_SIZE"
  magick $image -font "$FONT" -pointsize $DYNAMIC_SIZE -draw "gravity center fill #A0A0A0A0 text 0, 0 '$COPYRIGHT_TEXT'" wmark_$image

  # Tag bottom with directory name + number
  magick wmark_$image -font "$FONT" -pointsize $FILENAME_FONT_SIZE -draw "gravity south fill black text 0, 0 '$DIR_NAME-$i'" wmark_$image
  magick wmark_$image -font "$FONT" -pointsize $FILENAME_FONT_SIZE -draw "gravity south fill white text 10, 10 '$DIR_NAME-$i'" wmark_$image
  i=$((i+1))
done
