#!/usr/bin/enc texlua

--[[
  Build script for using format latex-dev instead of latex
  Copyright (C) 2021 Markus Kohm

  This file is part of the build system of KOMA-Script.

  It may be distributed and/or modified under the conditions of the
  LaTeX Project Public License (LPPL), either version 1.3c of this
  license or (at your option) any later version.  The latest version
  of this license is in the file

    https://www.latex-project.org/lppl.txt

  Usage: l3build <cmd> --config build-dev.lua <parameter> ...
]]


checkformat = "latex-dev"

dofile("build.lua")
