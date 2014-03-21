set xlabel "time elapsed"
set ylabel "bytes received"
plot "out.tr" using 1:2 title 'n3' with linespoints, "out.tr" using 1:3 title 'n5' with linespoints, "out.tr" using 1:4 title 'n7' with linespoints 
set terminal postscript
set output '| ps2pdf - output.pdf'
