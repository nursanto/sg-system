#!/bin/bash

for i in {1..2}
do
    for j in {1..2}
    do
        for k in {1..2}
        do
            for l in {1..2}
            do
                mkdir -p $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)$i/$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)$j/$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)$k
            done
        done
    done
done
