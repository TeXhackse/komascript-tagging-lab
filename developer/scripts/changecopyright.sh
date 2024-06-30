#!/bin/sh
#
# Copyright (c) Markus Kohm, 2008-2012
#
# This file prepares the copyright date of KOMA-Script for release.
#
# This file is not part of KOMA-Script bundle. You are not allowed
# to redistribute or modify this file!
#

while [ $# -gt 0 ]; do
    case $1 in
	*)
	    echo "Usage: $0"
	    ;;
    esac
    shift
done

processfiles() {
    rm -f file.list
    echo "Input
  \`l' for every file that should be listed at file.list
  \`n' (or every other character) for every file that should not be ignored
  nothing but Enter/Return for every file that should be processed"

    while read file; do
	case $file in
	    *~) continue;;
	    \#*) continue;;
	    *.orig) continue;;
	    */.svn/*) continue;;
	    .svn/*) continue;;
	    *svn-base) continue;;
	esac
	if ! sed -i~ \
	    -r \
	    -e 's/(Copyright.*Markus Kohm.*[ |-])'${lastyear}'($|[^-])/\1'${year}'\2/g' \
	    -e 's/(Copyright.*[ |-])'${lastyear}'([^-].*Markus Kohm)/\1'${year}'\2/g' \
	    "$file"; then
	    echo "Error preprocessing \"$file\"!" >2
	    exit 1
	fi
	if diff -u "$file~" "$file"; then
	    mv -f "$file~" "$file"
	    continue
	fi
	read $yesno </dev/tty
	case $yesno in
	    '') echo "Neue Version verwenden!"
		;;
	    l)  echo "Datei listen!"
		echo "$file" >> file.list
		;;
	    n)  echo "Alte Version verwenden!"
		mv -f "$file~" "$file"
		;;
	esac
    done
}

year=`date +%Y`
lastyear=$((year-1))

grep -Rl 'Copyright.*\(Markus Kohm.*'"${lastyear}"'\|'"${lastyear}"'.*Markus Kohm\)' \
    * \
    | processfiles
