#!/bin/sh

DOT_DIR=dots

DOTS=$DOT_DIR/*.dot


for DOT in $DOTS; do

        if [ -f "$DOT" ];
        then
                dot -Tpng "$DOT" > "$DOT.png";
        fi
done


