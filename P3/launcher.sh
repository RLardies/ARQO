#! /bin/bash

TamInicio=1024
TamFinal=8192

for (( i=$TamInicio; i<=$TamFinal; i=$i*2 )); do
    qsub -v tam=$i job2.q
done
