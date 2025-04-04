#!/usr/bin/env bash

#testdir="tagging-lab-testfiles"
#tagging-lab-testfiles_comparison

#enable extglob
shopt -s extglob

for testdir in "testfiles" "testfiles-compare";
	do
	testconfig=${testdir/!(*-*)?(-)}
	echo "======================================="
	echo "Updating $testdir ${testconfig:+using config $testconfig}"
	echo "---------------------------------------"
	for file in "$testdir"/*.lvt ; do
		file_base=${file##*/}
		file_base=${file_base%%.*}
		echo "Updating $file_base.tlg"
		l3build save ${testconfig:+-c "$testconfig"} "$file_base" >> /dev/null
		# check for specific test configs
		for engine in luatex pdftexmain; do
			file_name="$file_base.$engine.tlg"
			if [ -f "$testdir/$file_name" ]; then
			echo "Updating $file_name"
			l3build save  ${testconfig:+-c "$testconfig"} -e $engine "$file_base" >> /dev/null
		fi
		done
	done
	echo "---------------------------------------"
done
