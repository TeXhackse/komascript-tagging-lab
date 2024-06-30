#!/usr/bin/env bash
# svnclean.sh
# Copyright Markus Kohm, 2012
#
# Test whether or not all files of the current working directory are part
# of the subversion repositiory.  Optionally remove all files, that are not.
#

testmode=true
svnupdate=true
makeclean=true

while [ $# -gt 0 ]; do
    case $1 in
	-nomakeclean|--nomakeclean)
	    makeclean=false;;
	-noupdate|--noupdate)
	    svnupdate=false;;
	-clean|--clean)
	    testmode=false;;
	*)
	    echo "Error: unknown parameter \`$1'." >&2
	    exit 1
	    ;;
    esac
    shift
done

if $svnupdate && ! svn update .; then
    echo "Error: \`svn update' failed. See previous message." >&2
    exit 1
fi

if $makeclean && ! make maintainclean; then
    echo "Error: \`make maintainclean' failed. See previous messages." >&2
    exit 1
fi

doit() {
    local line status filename
    local -a missing filenotatsvn dirnotatsvn
    while read line; do
	status=$(echo "$line" | cut -c 1)
	filename=$(echo "$line" | cut -c 9-)
        case $status in
	    !)  missing[${#missing[@]}]="$filename";;
	    \?) if [ -d "$filename" ]
		then dirnotatsvn[${#dirnotatsvn[@]}]="$filename"
		else filenotatsvn[${#filenotatsvn[@]}]="$filename"
		fi
		;;
	esac
    done
    if [ ${#missing[@]} -gt 0 ]; then
	echo "Following files or directories are missing:"
	for f in "${missing[@]}"; do
	    echo "  $f"
	done
	echo "You may use"
	echo "  svn update"
	echo "to fix this."
	echo
    fi
    if [ ${#filenotatsvn[@]} -gt 0 ]; then
	echo "Following files are not in the svn:"
	for f in "${filenotatsvn[@]}"; do
	    echo "  $f"
	done
    fi
    if [ ${#dirnotatsvn[@]} -gt 0 ]; then
	echo "Following directories are not in the svn:"
	for f in "${dirnotatsvn[@]}"; do
	    echo "  $f"
	done
    fi
    if $testmode; then
	if [ ${#filenotatsvn[@]} -gt 0 -o ${#dirnotatsvn[@]} -gt 0 ]; then
	    echo "You may use"
	    echo "  svn add"
	    echo "for each of them to add all files to the svn."
	    [ ${#dirnotatsvn[@]} -gt 0 ] \
		&& echo "But for the directories you should test whether or not their complete content   should be added."
	    echo "Or you may use"
	    echo "  svnclean.sh --clean"
	    echo "to remove all of them, that are not part of directory developer."
	fi
    elif [ ${#filenotatsvn[@]} -gt 0 -o ${#dirnotatsvn[@]} -gt 0 ]; then
	echo "Now, I'll remove all of them (without developer files)."
	for f in "${filenotatsvn[@]}"; do
	    [ "${f%%/*}" = "developer" ] || rm -f "$f"
	done
	[ ${#dirnotatsvn[@]} -gt 0 ] && rm -r "${dirnotatsvn[@]}"
    fi
}

svn status | doit || exit 1
