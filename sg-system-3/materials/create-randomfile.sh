#!/bin/bash

n=1
while (( $n <= 5 ))
do  
  for i in $(ls)
  do
    #
    for j in $(ls $i)
    do
      #
      for k in $(ls $i/$j)
      do
        #
        #echo $i/$j/$k
        touch $i/$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
        touch $i/$j/$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
        touch $i/$j/$k/$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
      done
    done
  done
  n=$(( n+1 ))
done

