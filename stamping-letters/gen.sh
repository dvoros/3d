#!/bin/bash

SCAD="stamp.scad"
OUT="stl"
EXE="openscad"

mkdir -p "$OUT"

function char {
	$EXE -o "$OUT/$1.stl" -D "char=\"$1\"" $SCAD
}

for ch in {{a..z},{A..Z},{0..9}}; do
  char $ch
done

