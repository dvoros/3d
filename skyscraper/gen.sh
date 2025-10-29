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

multi_num tile 6
multi_string clue 5
multi_string clue_multi_color_base 5
multi_string clue_multi_color_letter 5
single flag
single park
