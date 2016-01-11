#!/bin/sh
files=./*.blif
	 for file in $files;
	 do
	 	echo "read_blif $file"
		echo "source script.rugged"
		echo "print_stats"
	done

	echo "quit"

