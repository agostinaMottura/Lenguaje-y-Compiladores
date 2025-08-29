#!/bin/bash

for archivo in ./tests/*; do
    if [ -f "$archivo" ]; then
        nombre=$(basename "$archivo")
        echo "Running test: $nombre"
        echo ""
        ./run.sh "$nombre"
        echo ""
        echo "   -----------------------------------   "
    fi
done