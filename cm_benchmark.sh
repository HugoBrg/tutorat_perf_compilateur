#!/bin/bash

TIMEFORMAT='%3S';

cd c++/calcul_matriciel_new/
g++ calcul_matriciel.cpp -o calcul_matriciel

for (( var=0; var<=1; var++ ))
do
    time ./calcul_matriciel ../../matrice1.txt ../../matrice2.txt 500
done

cd ../../
cd rust/calcul_matriciel_new/

for (( var=0; var<=1; var++ ))
do
    time cargo run ../../matrice1.txt ../../matrice2.txt 500
done


#usr/bin/time

#g++ calcul_matriciel.cpp -o calcul_matriciel
#./calcul_matriciel ../../matrice1.txt ../../matrice2.txt 500
#cargo run ../../matrice1.txt ../../matrice2.txt 500

#test = `echo "$var + 2.0" | bc` 
#echo "test : $test"
#usr/bin/time -o times
