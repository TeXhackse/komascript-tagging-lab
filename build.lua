#!/usr/bin/env texlua

module          = "scr-tagging-lab"

typesetexe      = "lualatex-dev"

typesetfiles={}

unpackfiles = {"scr-tagging-lab.ins"}
testfiledir = "tagging-lab-testfiles"


checksuppfiles={"*.tex"}
demofiles={"tagging-experiments/*.tex"}
typesetdemofiles={"tagging-experiments/*.tex"}

supportdir="tagging-lab-support"
