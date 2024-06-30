#! /bin/sh
#
# Copyright (c) Markus Kohm, 2002-2012
#
# This file generates a template for german part of KOMA-Script.
#
# This file is not part of KOMA-Script bundle. You are not allowed
# to redistribute or modify this file!
#

version() {
    echo `basename $0`' v1.0a'
    echo 'Copyright (c) Markus Kohm, 2002'
}

usage() {
    echo 'usage '`basename $0`' [Options] [filename]'
}

error() {
    echo "$2" >&2
    usage >&2
    echo 'try "'`basename $0`' -h" for help' >&2
    exit $1
}

help() {
    version
    echo
    usage
    echo '
Options:
 -d     generates .dtx template file (default)
 -e     generates english template file
 -g     generates german template file (default)
 -h     shows this information and exit
 -i     generates .ins template file
 -s     generate .dtx and .ins template for stand alone package
 -v     shows version information and exit
 -V VERSION
        sets fileversion of the generated file to VERSION (default: '$fileversion')

'`basename $0`' generates a template file, which may be used as KOMA-Script part.
If filename has no extension ".dtx" will be used. If no filename is was given
"template.dtx" will be used.
'
}

generate() {
if ! $insfile; then
    echo '% \CheckSum{0}'
    echo '% \iffalse meta-comment'
fi
cat <<EOF
% ======================================================================
EOF
echo '% '"$1"
echo '% Copyright (c) Markus Kohm, '`date +\%Y`
cat <<EOF
%
% This file is part of the LaTeX2e KOMA-Script bundle.
%
% This work may be distributed and/or modified under the conditions of
% the LaTeX Project Public License, version 1.3c of the license.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3c or later is part of all distributions of LaTeX
% version 2005/12/01 and of this work.
%
% This work has the LPPL maintenance status "author-maintained".
%
% The Current Maintainer and author of this work is Markus Kohm.
%
% This work consists of all files listed in manifest.txt.
% ----------------------------------------------------------------------
EOF
echo '% '"$1"
echo '% Copyright (c) Markus Kohm, '`date +\%Y`
cat <<EOF
%
% Dieses Werk darf nach den Bedingungen der LaTeX Project Public Lizenz,
% Version 1.3c.
% Die neuste Version dieser Lizenz ist
%   http://www.latex-project.org/lppl.txt
% und Version 1.3c ist Teil aller Verteilungen von LaTeX
% Version 2005/12/01 und dieses Werks.
%
% Dieses Werk hat den LPPL-Verwaltungs-Status "author-maintained"
% (allein durch den Autor verwaltet).
%
% Der Aktuelle Verwalter und Autor dieses Werkes ist Markus Kohm.
%
% Dieses Werk besteht aus den in manifest.txt aufgefuehrten Dateien.
% ======================================================================
EOF
if $insfile; then
    cat <<EOF

% ---------- start of docstrip process ---------------------------------
EOF
    echo '\def\batchfile{'$1'}'
    cat <<EOF

% ---------- KOMA-Script default docstrip declarations -----------------

\input docstrip.tex
\@@input scrstrip.inc

% ---------- File generation -------------------------------------------

\generate{\usepreamble\defaultpreamble
EOF

    if $packagefiles; then
	cat <<EOF
  \file{$2.sty}{%
    \ifbeta\from{scrbeta.dtx}{package,$2}\fi
    \from{$2.dtx}{package,$2}%
EOF
    else
	cat <<EOF
  \file{CHANGETHIS.sty}{%
    \ifbeta\from{scrbeta.dtx}{class,package,lcofile,ONLYONEOFTHIS}\fi
    \from{$2.dtx}{options}%
    \from{$2.dtx}{main}%
EOF
    fi
    cat <<EOF
    \from{scrlogo.dtx}{logo}%
  }%
}

% ---------- end of docstrip process -----------------------------------

EOF
    if $packagefiles; then
	cat <<EOF
\ifToplevel{%
  \def\idocfiles{'$2.dtx'}%
}
EOF
    else
	echo '\def\idocfiles{}'
    fi
cat <<EOF
\@@input scrstrop.inc

EOF
else
    cat <<EOF
% \fi
%
% \CharacterTable
%  {Upper-case    \A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\W\X\Y\Z
%   Lower-case    \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z
%   Digits        \0\1\2\3\4\5\6\7\8\9
%   Exclamation   \!     Double quote  \"     Hash (number) \#
%   Dollar        \\$     Percent       \%     Ampersand     \&
%   Acute accent  \'     Left paren    \(     Right paren   \)
%   Asterisk      \*     Plus          \+     Comma         \,
%   Minus         \-     Point         \.     Solidus       \/
%   Colon         \:     Semicolon     \;     Less than     \<
%   Equals        \=     Greater than  \>     Question mark \?
%   Commercial at \@     Left bracket  \[     Backslash     \\\\
%   Right bracket \]     Circumflex    \^     Underscore    \_
%   Grave accent  \\\`     Left brace    \{     Vertical bar  \|
%   Right brace   \}     Tilde         \~}
%
% \iffalse
EOF
    echo '%%% From File: '"$1"
    if $packagefiles; then
	cat <<EOF
%<*dtx>
\ProvidesFile{$1}
%</dtx>
%<package|driver>\NeedsTeXFormat{LaTeX2e}[1995/06/01]
%<package>\ProvidesPackage{$2}
%<driver>\ProvidesFile{$2.drv}
%<*dtx|package|driver>
EOF
	echo '  ['`date +\%Y/\%m/\%d`' v'$fileversion' LaTeX2e KOMA-Script package (TEMPLATE)]'
	echo '%</dtx|package|driver>'
	echo '%<*driver>'
    else
	cat <<EOF
%<*driver>
% \fi
EOF
	echo '\ProvidesFile{'"$1"'}['`date +\%Y/\%m/\%d`' v'$fileversion' KOMA-Script (TEMPLATE)]'
	echo '% \iffalse'
    fi
    cat <<EOF
\documentclass{scrdoc}
EOF
    if $english; then
        echo '\usepackage[ngerman,english]{babel}'
    else
        echo '\usepackage[english,ngerman]{babel}'
        echo '\usepackage[latin1]{inputenc}'
    fi
    if $packagefiles; then
	echo '\usepackage{'"$2"'}'
    fi
    cat <<EOF
\CodelineIndex
\RecordChanges
EOF
    echo '\GetFileInfo{'"$1"'}'
    if $packagefile; then
	if $english; then
	    echo '\title{The \KOMAScript{} package \texttt{'$2'}%'
	else
	    echo '\title{Das \KOMAScript-Paket \texttt{'$2'}%'
	fi
    else
	echo '\title{\KOMAScript{} \partname\ \texttt{\filename}%'
    fi
    if $english; then
cat <<EOF
  \footnote{This is version \fileversion\ of file \texttt{\filename}.}}
EOF
    else
        cat <<EOF
  \footnote{Dies ist Version \fileversion\ von Datei \texttt{\filename}.}}
EOF
    fi
    cat <<EOF
\date{\filedate}
\author{Markus Kohm}

\begin{document}
  \maketitle
EOF
    $packagefiles || echo '  \tableofcontents'
    cat <<EOF
  \DocInput{\filename}
\end{document}
%</driver>
% \fi
%
EOF
    if $english; then
        echo '% \selectlanguage{english}'
    else
        echo '% \selectlanguage{ngerman}'
    fi
    echo '%'
    echo '% \changes{v'$fileversion'}{'`date +\%Y/\%m/\%d`'}{%'
    if $packagefiles; then
	if $english; then
	    echo '%   start of new package}'
	else
	    echo '%   Anfang des neuen Pakets}'
	fi
        cat <<EOF
%
% \begin{abstract}
% ADD ABSTRACT HERE
% \end{abstract}
%
% \tableofcontents
EOF
	if $english; then
	    echo '% \section{How to Use the Package}'
	else
	    echo '% \section{Anwendung des Pakets}'
	fi
    else
	if $english; then
            echo '%   first version after splitting \textsf{scrclass.dtx}}'
	else
            echo '%   erste Version aus der Aufteilung von \textsf{scrclass.dtx}}'
	fi
	cat <<EOF
%
% \section{TEMPLATE}
EOF
    fi
    cat <<EOF
%
% ADD SOME DESCRIPTIONS HERE
%
% \StopEventually{\PrintIndex\PrintChanges}
%
EOF
    if $english; then
	echo '% \section{Implementation}'
    else
	echo '% \section{Implementierung}'
    fi
    echo '%'
    if $packagefiles; then
	cat <<EOF
% \iffalse
%<*package>
% \fi
%
EOF
    else
	cat <<EOF
% \iffalse
%<*option>
% \fi
%
EOF
    fi
    cat <<EOF
% \subsection{Option}
% ADD IMPLEMENTATION HERE
%
%
EOF
    if ! $packagefiles; then
	cat <<EOF
% \iffalse
%</option>
%<*body>
% \fi
%
EOF
    fi
    cat <<EOF
% \subsection{Body}
% ADD IMPLEMENTATION HERE
%
%
EOF
    if $packagefiles; then
	cat <<EOF
% \iffalse
%</package>
% \fi
%
EOF
    else
	cat <<EOF
% \iffalse
%</body>
% \fi
%
EOF
    fi
    cat <<EOF
% \Finale
%
EOF
fi
cat <<EOF
\endinput
%
EOF
echo '% end of file `'"$1'"
echo '%%% Local Variables:'
if $insfile; then
    echo '%%% mode: tex'
else
    echo '%%% mode: doctex'
fi
cat <<EOF
%%% TeX-master: t
%%% End:
EOF
}

english=false
insfile=false
packagefiles=false
fileversion=3.0

while getopts 'deghisvV:' option;do
    case $option in
        \?) error 1 "";;
        d)  insfile=false;;
        e)  english=true;;
        g)  english=false;;
        h)  help; exit 0;;
        i)  insfile=true;;
        s)  packagefiles=true;;
        V)  fileversion=${OPTARG};;
        v)  version; exit 0;;
    esac
done

if [ $OPTIND -lt $# ]; then
    error 1 "too much arguments"
else
    OPTIND=$(( OPTIND - 1 ))
    shift $OPTIND
    filename=${1:-"template.dtx"}
    basefilename=${filename%.*}
    if ! $packagefiles; then
	if $insfile; then
            filename="$basefilename.ins"
	else
            filename="$basefilename.dtx"
	fi
    fi
fi

if $packagefiles; then
    if [ -f "${basefilename}.ins" ]; then
	echo ${basefilename}'.ins already exists. You have to remove it first using e.g.' >&2
	echo '  rm '${basefilename}'.ins' >&2
	exit 1
    fi
    if [ -f "${basefilename}.dtx" ]; then
	echo ${basefilename}'.dtx already exists. You have to remove it first using e.g.' >&2
	echo '  rm '${basefilename}'.dtx' >&2
	exit 1
    fi
    insfile=true
    generate "${basefilename}.ins" "$basefilename" > "${basefilename}.ins"
    insfile=false
    generate "${basefilename}.dtx" "$basefilename" > "${basefilename}.dtx"
else
    if [ -f $filename ]; then
	echo $filename' already exists. You have to remove it first using e.g.' >&2
	echo '  rm '$filename >&2
	exit 1
    else
	generate $filename $basefilename > $filename
    fi
fi
