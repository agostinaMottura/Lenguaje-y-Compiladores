#!/bin/bash

for archivo in ./tests/*; do
    if [ -f "$archivo" ]; then
        nombre=$(basename "$archivo")
        ./run.sh "$nombre"
    fi
done