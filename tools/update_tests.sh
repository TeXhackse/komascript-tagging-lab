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
	for file in "$testdir"/*.lvt ;
	 do
		file_base=${file##*/}
	 	file_base=${file_base%%.*}
		# testconfig is part after dash, empty if default config

	 	if [ -f "$testdir/$file_base.luatex.tlg" ]; then
			echo "Updating $file_base.luatex.tlg"
	 		l3build save  ${testconfig:+-c "$testconfig"} -e luatex "$file_base" >> /dev/null
	 	fi
		echo "Updating $file_base.tlg"
		l3build save ${testconfig:+-c "$testconfig"} "$file_base" >> /dev/null
	done
	echo "---------------------------------------"
done
