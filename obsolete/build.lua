#!/usr/bin/env texlua

--[[
  Build script for koma-script-obsolete
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
modules = { "scrlettr-obsolete",
	    "scrpage-obsolete",
	    "scrpage2-obsolete",
	    "tocstyle-obsolete" }
textfiles = { "README" }

-- Tagging

tagfiles = { "build.lua", "README" }

function update_tag(file,contents,tagname,tagdate)
   if string.match(file, "build.lua") then
      return string.gsub(contents,
			 '(\n%s*version%s*=%s*")[^"]+"',
			 '%1' .. tagname .. '"')
   elseif string.match(file, "README") then
      return string.gsub(contents,
			 '(\nVersion:%s+)[^\n]*\n',
			 '%1' .. tagname .. '\n', 1)
   end
   return contents
end

-- CTAN

packtdszip = false
uploadconfig = {
   pkg         = "koma-script-obsolete",
   version     = "2020-06-06",
   author      = "Markus Kohm",
   license     = "lppl1.3c",
   summary     = "Deprecated packages from KOMA-Script",
   ctanPath    = "obsolete/macros/latex/contrib/koma-script-obsolete",
   description = "<p>The bundle provides copies of old versions of packages in the current koma-script bundle.</p><p>Packages in the obsolete 'distribution' are scrlttr2, scrpage, scrpage2 and tocstyle; they should no tbe used in new docments, but are preserved for use in existing documents.</p>",
   home        = "https://komascript.de",
   repository  = "http://svn.code.sf.net/p/koma-script/code/trunk/obsolete/",
   topic       = "obsolete",
   update      = true      
}

-- Find and run build system

kpse.set_program_name("kpsewhich")
if not release_date then
  dofile(kpse.lookup("l3build.lua"))
end
