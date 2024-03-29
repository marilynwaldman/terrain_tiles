#!/bin/bash

INPUT_DIR=./N035W110_N040W105
OUTPUT_DIR=./output
vrtfile=${OUTPUT_DIR}/jaxa_tilergb0-12.vrt
mbtiles=${OUTPUT_DIR}/N035W110_N040W105.mbtiles
vrtfile2=${OUTPUT_DIR}/jaxa_tilergb0-12_warp.vrt

[ -d "$OUTPUT_DIR" ] || mkdir -p $OUTPUT_DIR || { echo "error: $OUTPUT_DIR " 1>&2; exit 1; }

#rm rio/*
gdalbuildvrt -overwrite -srcnodata -9999 -vrtnodata -9999 ${vrtfile} ${INPUT_DIR}/*_DSM.tif
gdalwarp -r cubicspline -t_srs EPSG:3857 -dstnodata 0 -co COMPRESS=DEFLATE ${vrtfile} ${vrtfile2}
rio rgbify -b -10000 -i 0.1 --min-z 0 --max-z 12 -j 24 --format png ${vrtfile2} ${mbtiles}