#!/bin/bash
#------------------------------------------------------------
#         pic2gif <https://svmgrg.github.io/>
#------------------------------------------------------------
# pic2gif is a toy program that creates a GIF of an input
# image with increasing and descreasing threshold values
# (uses 'convert' function of ImageMagick).
#------------------------------------------------------------
# Running the program:
# $ bash pic2gif.sh <input_image>
#------------------------------------------------------------
# Output is an image of the same name with extension as .gif
#------------------------------------------------------------

# reduce the dimensions of the image to 400x400
WIDTH=$(identify -format '%w' $1)
HEIGHT=$(identify -format '%h' $1)
if [ $WIDTH -gt 400 ] || [ $HEIGHT -gt 400 ]; then
    convert -resize 400x400 $1 .tmp.png
else
    convert $1 .tmp.png
fi

# forward loop thresholding
COUNTER=0
while [ $COUNTER -lt 10 ]; do
    convert -threshold $COUNTER% .tmp.png .temp_00$COUNTER.png
    let COUNTER+=1
done
while [ $COUNTER -lt 100 ]; do
    convert -threshold $COUNTER% .tmp.png .temp_0$COUNTER.png
    let COUNTER+=1
done
convert -threshold $COUNTER% .tmp.png .temp_$COUNTER.png

# backward loop thresholding
THRESHOLD=99
while [ $THRESHOLD -gt 0 ]; do
    convert -threshold $THRESHOLD% .tmp.png .temp_$COUNTER.png
    let THRESHOLD-=1
    let COUNTER+=1
done

# create the gif
OUTPUT=${1%.*}
convert -delay 5 .temp_*.png $OUTPUT.gif

# remove temporary images
rm .temp_*.png
rm .tmp.png
