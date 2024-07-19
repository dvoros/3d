#!/bin/bash

SCAD="stamp.scad"
OUT="stl"
EXE="openscad"

mkdir -p "$OUT"

function letter {
	$EXE --enable textmetrics -o "$OUT/$1.stl" -D "char=\"$1\"" -D "piece=\"letter\"" $SCAD
}

function holder {
	$EXE --enable textmetrics -o "$OUT/_holder$1.stl" -D "size=$1" -D "char=\"a\"" -D "piece=\"holder\"" $SCAD
}

for size in {2..10}; do
  holder $size
done

for ch in é É á Á ő Ő ú Ú ö Ö ü Ü ó Ó í Í {{a..z},{A..Z},{0..9}}; do
  letter $ch
done
