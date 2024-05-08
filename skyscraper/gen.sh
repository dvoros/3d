#!/bin/bash

SCAD="skyscraper.scad"
OUT="stl"
EXE="openscad"

function single {
	$EXE -o "$OUT/$1.stl" -D "piece=\"$1\"" $SCAD
}

function multi_string {
	for i in `seq 1 $2`; do
		$EXE -o "$OUT/$1_$i.stl" -D "piece=\"$1\"" -D "string=\"$i\"" $SCAD
	done
}

function multi_num {
	for i in `seq 1 $2`; do
		$EXE -o "$OUT/$1_$i.stl" -D "piece=\"$1\"" -D "num=$i" $SCAD
	done
}

multi_num tile 6
multi_string clue 5
multi_string clue_multi_color_base 5
multi_string clue_multi_color_letter 5
single flag
single park
