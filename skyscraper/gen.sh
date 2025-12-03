#!/bin/bash

SCAD="skyscraper.scad"
OUT="stl"
EXE="openscad"

function single {
	$EXE -o "$OUT/with-magnet-3x1.7/$1.stl" -D "piece=\"$1\"" -D "magnet=\"3x1.7\"" $SCAD
	$EXE -o "$OUT/with-magnet-4x2/$1.stl" -D "piece=\"$1\"" -D "magnet=\"4x2\"" $SCAD
}

function multi_string {
	for i in `seq 1 $2`; do
		$EXE -o "$OUT/with-magnet-3x1.7/$1_$i.stl" -D "piece=\"$1\"" -D "string=\"$i\"" -D "magnet=\"3x1.7\"" $SCAD
		$EXE -o "$OUT/with-magnet-4x2/$1_$i.stl" -D "piece=\"$1\"" -D "string=\"$i\"" -D "magnet=\"4x2\"" $SCAD
	done
}

function multi_num {
	for i in `seq 1 $2`; do
		$EXE -o "$OUT/with-magnet-3x1.7/$1_$i.stl" -D "piece=\"$1\"" -D "num=$i" -D "magnet=\"3x1.7\"" $SCAD
		$EXE -o "$OUT/with-magnet-4x2/$1_$i.stl" -D "piece=\"$1\"" -D "num=$i" -D "magnet=\"4x2\"" $SCAD
	done
}

function num12 {
	$EXE -o "$OUT/with-magnet-3x1.7/$1_$2_$3.stl" -D "piece=\"$1\"" -D "num1=\"$2\"" -D "num2=\"$3\"" -D "magnet=\"3x1.7\"" $SCAD
	$EXE -o "$OUT/with-magnet-4x2/$1_$2_$3.stl" -D "piece=\"$1\"" -D "num1=\"$2\"" -D "num2=\"$3\"" -D "magnet=\"4x2\"" $SCAD
}

find stl -name '*.stl' -type f -delete

num12 clue 1 2
num12 clue 1 3
num12 clue 2 3
num12 clue_multi_color_letter 1 2
num12 clue_multi_color_letter 1 3
num12 clue_multi_color_letter 2 3
multi_num tile 6
single flag
single park
