#!/usr/bin/env bash
# cleanuptosvn.sh
# Copyright Markus Kohm, 2012
#
# If the current directory is a workspace directory, link all files from trunk
# into this workspace directory.
#

makeclean=true
svnupdate=true

while [ $# -gt 0 ]; do
    case $1 in
	-nomakeclean|--nomakeclean)
	    makeclean=false;;
	-noupdate|--noupdate)
	    svnupdate=false;;
    esac
    shift
done

n=${#PWD}
pushd . >/dev/null
startdir=$(popd)
while [ "${PWD##*/}" != "workspace" ]; do
    cd ..
    if [ $n -eq ${#PWD} ]; then
	echo "Error: You can only cleanup from within workspace, but" >&2
	echo "        \"${startdir}\"" >&2
	echo "       is not within workspace." >&2
	exit 1
    fi
    n=${#PWD}
done

if $makeclean && ! make maintainclean; then
    echo "Error: \`make maintainclean' failed. See previous messages." >&2
    exit 1
fi

if [ $makeclean ]; then
    rm test*.aux test*.log test*.toc* test*.lof test*.lot test*.dvi test*.pdf \
	test*.ind test*.idx test*.lor test*.TOC test*.wrt test*.los \
	test*.mtc* \
	2>/dev/null
    find ./ -name \*~ -exec rm "{}" \;
fi

if ! pushd ../trunk; then
    echo "Error: There's no valid trunk. Please use" >&2
    echo "        pushd ${PWD}/.." >&2
    echo "        svn co svn+ssh://${USER}@svn.berlios.de/svnroot/repos/koma-script3/trunk" >&2
    echo "        popd" >&2
    echo "       first." >&2
    exit 1
fi

if $svnupdate && ! svn update .; then
    echo "Error: \`svn update' failed. See previous message." >&2
    exit 1
fi

for f in `find ./ -type f ! -path '*.svn*'`; do
    f="${f#./}"
    src="$f"
    dst=""
    while [ "$src" != "${src#*/}" ]; do
	dst="../$dst"
	src="${src#*/}"
    done
    if ! ln -sf "${dst}../trunk/$f" "../workspace/$f"; then
	echo "Error: Cannot create symbolic link for" >&2
	echo "        $f" >&2
	echo "       See previous message." >&2
	exit 1
    fi
done
