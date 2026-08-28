#!/usr/bin/env texlua
svn_revision = 4281
module          = "scr-tagging-lab"

typesetexe      = "lualatex-dev"
supportdir = "support-tests"

docfiledir="experiments"

-- This also unpacks the KOMAscript files itself to simplify testing without a local copy of the dev status.
sourcefiles     = { "*.dtx", "*.ins", "*.inc", "scrdocstrip.tex" }
installfiles    = { "*.sty", "*.cls", "*.clo", "*.lco", "*.hak" }
textfiles       = { "*.md", "*.txt", "README.md" }
unpackfiles = {"scr-tagging-lab.ins","scrmain.ins"}

-- This is only for demo files - does not include building the KOMAscript documentation
typesetfiles={
	"*.tex"
}

-- checkconfigs = {"build", "compare","tagging-project-tests"} -- compare config is only used when the real testfiles failed

checksuppfiles={"*.tex","**/*.ltx"}

testsuppdir = "support-tests"
typesetsuppfiles=checksuppfiles
supportdir  = testsuppdir
checkruns = 2
typesetruns=2
recordstatus=true

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
    luatexmain = {binary="luahbtex",format = "lualatex"},
  }

stdengine = luatex
checkengines = {"luatex",
-- pdftex,
-- main track only for local tests,
--	"luatexmain","pdftexmain"
}
