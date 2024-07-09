#!/usr/bin/env texlua

module          = "scr-tagging-lab"

typesetexe      = "lualatex-dev"

typesetfiles={}

unpackfiles = {"scr-tagging-lab.ins"}
testfiledir = "tagging-lab-testfiles"


checksuppfiles={"*.tex"}
supportdir="tagging-lab-support"
checkruns = 2

demofiles={"tagging-experiments/*.tex"}
typesetdemofiles={"tagging-experiments/*.tex"}

-- The following part of the configuration has been take from the tagpdf project by Ulrike Ficher
-- Copyright (C) 2019-2024 Ulrike Fischer
-- https://github.com/latex3/tagpdf
-- This is required to run the tests engine specific.

-- tests are mostly with dev-format always
specialformats = specialformats or {}
specialformats["latex"] = specialformats["latex"] or
  {
    luatex     = {binary="luahbtex",format = "lualatex-dev"},
    pdftex     = {format = "pdflatex-dev"},
    pdftexmain = {binary="pdftex",format = "pdflatex"},
--    xetex      = {format = "xelatex-dev"},
--    latexdvips = {binary="latex",format = "latex-dev"}
  }
  
checkengines = {"pdftex","luatex","pdftexmain"}


