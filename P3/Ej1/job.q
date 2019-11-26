#! /bin/bash

#$ -S /bin/bash
#$ -cwd
#$ -o ejecutable.out
#$ -j y

cd /home/arqo47
sh slow_fast_time.sh
