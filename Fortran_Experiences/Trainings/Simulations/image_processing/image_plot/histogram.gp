# ==============================================================================
# File: histogram.gp
# Description: Plotting script
# ==============================================================================

set terminal pngcairo size 800,600 font "sans,12"
set output outfile
set title "Image Pixel Intensity Distribution" font "sans,16"
set xlabel "Intensity (0-255)"
set ylabel "Pixel Count"
set grid y
set style fill solid 0.6 border -1
set boxwidth 0.8
plot infile using 1:2 with boxes linecolor rgb "#4285F4" title 'Frequency'
