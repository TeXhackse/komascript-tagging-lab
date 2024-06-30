#!/bin/sh
#
# Copyright (c) Markus Kohm, ${year}
#

if [ $# -lt 2 ]; then
    echo "Usage: addrelease.sh <date> <version> [...]" >&2
    echo "Example: addrelease.sh 2007/05/12 2.97c BETA" >&2
    exit 1
fi

datestr=$1
versionstr=$2
shift 2

if svn status | grep '^M'; then
    echo "There are still modified files!" >&2
    exit 1
fi

head --lines=-1 releaselist.txt >releaselist.tmp
svn log -r HEAD >releaselist.tmp2
revisionstr=`cat releaselist.tmp2 | head -2 | tail -1 | cut -f 1 -d ' '`
revisionstr=${revisionstr#r}
echo -e "${revisionstr}\t  ${datestr} v${versionstr} $*" >>releaselist.tmp
tail -1 releaselist.txt >>releaselist.tmp
mv -f releaselist.tmp releaselist.txt
rm -f releaselist.tmp2

echo "Do next:"
echo "  svn ci releaselist.txt -m 'release ${datestr} v${versionstr} $*'"
echo "ok:"
echo "  rm releaselist.txt;svn up releaselist.txt"
