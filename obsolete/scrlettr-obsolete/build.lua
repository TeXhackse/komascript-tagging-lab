#!/usr/bin/env texlua

--[[
  Build script for koma-script-obsolete module scrlettr-obsolete
  Copyright (C) 2020 Markus Kohm

  This file is part of the build system of koma-script-obsolete.

  It may be distributed and/or modified under the conditions of the
  LaTeX Project Public License (LPPL), either version 1.3c of this
  license or (at your option) any later version.  The latest version
  of this license is in the file

    https://www.latex-project.org/lppl.txt
]]

-- Bundle and modules

bundle = "koma-script-obsolete"
module = "scrlettr-obsolete"
maindir = "../"

-- Find and run build system

kpse.set_program_name("kpsewhich")
if not release_date then
  dofile(kpse.lookup("l3build.lua"))
end
