set -euo pipefail
# -e exit si algo falla
# -u exit si falla alguna variable
# -o pipefail exit si falla algun comando

# variables
PROG="./Politropa.exe"
DATA_DIR="/home/lucio/Escritorio/numericus/Politropas2/Salida"    
# run
$PROG

# grafico las salidas en gnuplot con script
gnuplot -persist <<EOF
set grid
set key left top
set xlabel "Radio adimensional"
set ylabel "Densidad"
plot '${DATA_DIR}/Politropa_0.dat' u 1:(\$2**0) w l lw 3 lc 1 title 'n=0',\
	 '${DATA_DIR}/Politropa_1.dat' u 1:2   w l lw 3 lc 3 title 'n=1',\
     '${DATA_DIR}/Politropa_2.dat' u 1:(\$2**1.5) w l lw 3 lc 2 title 'n=3/2',\
     '${DATA_DIR}/Politropa_3.dat' u 1:(\$2**3) w l lw 3 lc 5 title 'n=3',\
     '${DATA_DIR}/Politropa_4.dat' u 1:(\$2**4) w l lw 3 lc 4 title 'n=4',\
     '${DATA_DIR}/Politropa_5.dat' u 1:(\$2**5) w l lw 3 lc 7 title 'n=5'
EOF
