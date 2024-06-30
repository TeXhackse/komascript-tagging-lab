#!/bin/sh
#
# Copyright (c) Markus Kohm, 2008-2022
#

datestr=`date +%Y/%m/%d`
versionstr=`grep '\\\@CheckKOMAScriptVersion{' scrkernel-version.dtx | sed s/.*{// | cut -d' ' -f 2- | sed 's/ *KOMA-Script.*//; s/^v//'`

force=false
if [ "$1" == "--force" ]; then
    shift
    force=true
fi

if [ $# -lt 2 ]; then
    echo "Usage: ${0##*/} [--force] <date> <version> [...]" >&2
    echo "Example: ${0##*/} $datestr $versionstr" >&2
    exit 1
fi

datestr=$1
versionstr=$2
shift 2
additional="$*"
while [ "$additional" != "${additional% }" ]; do
    additional=${additional% }
done
while [ "$additional" != "${additional# }" ]; do
    additional=${additional# }
done
[ -z "$additional" ] || additional=" $additional"

if svn status | grep '^M'; then
    if [ "$force" != "true" ]; then
	echo "There are still modified files!" >&2
	exit 1
    fi
fi

if ! grep 'scr@v@'"${versionstr}" scrkernel-compatibility.dtx; then
    cp -f scrkernel-compatibility.dtx scrkernel-compatibility.dtx~
    sed 's!\(\\begin{macro}{\\scr@v@last}\)!\\begin{macro}{\\scr@v@'"${versionstr}"'}\n% \\changes{v'"${versionstr}"'}{'"${datestr}"'}{added}\n% \1!' scrkernel-compatibility.dtx > scrkernel-compatibility.dtx.tmp
    sed '/^\\@namedef{scr@v@last}{[0-9]*} *$/{N;s!^\\@namedef{scr@v@last}{\([0-9]*\)} *\n%    \\end{macrocode}!\\@namedef{scr@v@'"${versionstr}"'}{\1}\n\0\n% \\end{macro}!}' scrkernel-compatibility.dtx.tmp > scrkernel-compatibility.dtx
    curr_checksum=`head -1 scrkernel-compatibility.dtx | grep -o '[0-9]\+'`
    new_checksum=$(( ${curr_checksum} + 1 ))
    sed 's/^\(% *\\CheckSum{\).*\(}.*\)$/\1'${new_checksum}'\2/' scrkernel-compatibility.dtx > scrkernel-compatibility.dtx.tmp
    mv scrkernel-compatibility.dtx.tmp scrkernel-compatibility.dtx
    if lualatex-dev -interaction=batchmode scrkernel-compatibility.dtx; then
	rm scrkernel-compatibility.dtx~
    else
	mv -f scrkernel-compatibility.dtx scrkernel-compatibility.dtx.tmp
	mv -f scrkernel-compatibility.dtx~ scrkernel-compatibility.dtx
	echo "Error changing scrkernel-compatibility.dtx (see scrkernel-compatibility.dtx.tmp)." >&2
	exit 1
    fi
fi

sed 's!\(\\@CheckKOMAScriptVersion{\)[^}]*!\1'"${datestr} v${versionstr}${additional} KOMA-Script!" scrkernel-version.dtx > scrkernel-version.dtx.new
mv -f scrkernel-version.dtx.new scrkernel-version.dtx

echo "Do next:"
echo "  make"
echo "  svn ci scrkernel-version.dtx scrkernel-compatibility.dtx -m 'prepared for ${versionstr}${additional}'"
echo "  developer/scripts/addrelease.sh '${datestr}' '${versionstr}' \"$@\""
echo "(NOTE: Don't execute addrelease.sh on BETA versions.)"
echo "or:"
echo "  rm scrkernel-version.dtx scrkernel-compatibility.dtx;svn up scrkernel-version.dtx scrkernel-compatibility.dtx"
