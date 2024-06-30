# ======================================================================
# Makefile
# Copyright (c) Markus Kohm, 2022
#
# This file is part of the LaTeX2e KOMA-Script bundle.
#
# This work may be distributed and/or modified under the conditions of
# the LaTeX Project Public License, version 1.3c of the license.
# The latest version of this license is in
#   http://www.latex-project.org/lppl.txt
# and version 1.3c or later is part of all distributions of LaTeX 
# version 2005/12/01 or later and of this work.
#
# This work has the LPPL maintenance status "author-maintained".
#
# The Current Maintainer and author of this work is Markus Kohm.
#
# This work consists of all files listed in manifest.txt.
# ----------------------------------------------------------------------
# This makefile is used to build KOMA-Script using l3build
# ======================================================================
# $Id: Makefile 3907 2022-06-24 10:19:11Z kohm $

all:		ctan-dist

PKGSOURCES      = build.lua *.dtx *.ins

DOCSOURCES      = build.lua doc/*.tex doc/*.dtx README.md

READMESOURCES   = build.lua README.in/README.*

ctan-dist: koma-script-ctan.zip

README.md: $(READMESOURCES) $(PKGSOURCES)
	l3build tag

koma-script-ctan.zip: $(PKGSOURCES) $(DOCSOURCES) README.md
	l3build ctan

clean:
	l3build clean

maintainclean: clean
	rm -f doc/*.pdf doc/*.html

.PHONY:	all clean maintainclean
