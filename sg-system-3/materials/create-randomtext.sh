#!/bin/bash

for i in $(ls)
do
  #
  for j in $(ls $i)
  do
    #
    for k in $(ls $i/$j)
    do
      #
      #ls $i/$j/$k
      cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 10 | tee $(ls $i/$j/$k/*)
      cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 10 | tee $(ls $i/$j/*)
      cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 10 | tee $(ls $i/*)
    done
  done
done
