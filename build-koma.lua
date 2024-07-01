#!/usr/bin/env texlua

--[[
  Build script for the KOMA-Script project
  Copyright (C) 2022–2023 Markus Kohm

  This file is part of the build system of KOMA-Script.

  It may be distributed and/or modified under the conditions of the
  LaTeX Project Public License (LPPL), either version 1.3c of this
  license or (at your option) any later version.  The latest version
  of this license is in the file

    https://www.latex-project.org/lppl.txt

  Note: This l3build script is currently not suitable to build
        KOMA-Script distributions. However, following targets can used:

          unpack:  to unpack all classes, packages etc. to build/unpacked
   
          check:   unpack + do test(s) from testfiles/

          save:    unpack + save a test comparison file in testfiles/

          doc:     unpack + create the implementation documentations
                   + create the examples and the user guides

          clean:   cleanup the build/ directory

          ctan:    create a CTAN upload archive

          tag:     does not tag files but generate a new REAMDE.md
   
          install: do a local install (usually in TEXMFHOME) without
                   any documentation

          uninstall: revert install

          upload:  should be used by the (upload) maintainer only and
                   does an interactive upload of the CTAN upload archive
                   to CTAN
   
        The result of following tagets are currently invalid:

          manifest: we are using a manually created MANIFEST.md,
                    therefore the automatic generation should never be
                    used.
   
        See the l3build manual for more information about the targets.

  You should neither use this file to generate the distribution
  nor copy it to the distribution!
]]

-- Bundle and modules

module          = "koma-script"

unpackfiles     = {
   "scrmain.ins", "koma-script-source-doc.dtx",
   "scrlttr2-examples.dtx"
}

sourcefiles     = { "*.dtx", "*.ins", "*.inc", "scrdocstrip.tex" }

installfiles    = { "*.sty", "*.cls", "*.clo", "*.lco", "*.hak" }

textfiles       = { "*.md", "*.txt", "README.md" }

-- Implementation documentation

typesetexe      = "lualatex-dev"
typesetopts     = "--interaction=batchmode"

typesetruns     = 4

typesetfiles    = {
   "koma-script-source-doc.dtx",
   "japanlco.dtx",
   "scraddr.dtx",
   "scrextend.dtx",
   "scrjura.dtx",
   "scrkernel-addressfiles.dtx",
   "scrkernel-basics.dtx",
   "scrkernel-bibliography.dtx",
   "scrkernel-compatibility.dtx",
   "scrkernel-fonts.dtx",
   "scrkernel-footnotes.dtx",
   "scrkernel-floats.dtx",
   "scrkernel-index.dtx",
   "scrkernel-language.dtx",
   "scrkernel-letterclassoptions.dtx",
   "scrkernel-listsandtabulars.dtx",
   "scrkernel-listsof.dtx",
   "scrkernel-miscellaneous.dtx",
   "scrkernel-notepaper.dtx",
   "scrkernel-pagestyles.dtx",
   "scrkernel-paragraphs.dtx",
   "scrkernel-pseudolengths.dtx",
   "scrkernel-sections.dtx",
   "scrkernel-title.dtx",
   "scrkernel-tocstyle.dtx",
   "scrkernel-typearea.dtx",
   "scrkernel-variables.dtx",
   "scrkernel-version.dtx",
   "scrlayer.dtx",
   "scrlayer-notecolumn.dtx",
   "scrlayer-scrpage.dtx",
   "scrlfile.dtx",
   "scrlfile-patcholdlatex.dtx",
   "scrlogo.dtx",
   "scrtime.dtx",
   "tocbasic.dtx",
   "scrguide-en.tex",
   "scrguide-de.tex",
}

-- Speed up typesetting by using -draftmode for each but the final run
local function exedraftmode(exe,i,n)
   if i < n then return exe .. " -draftmode" else return exe end
end

function typeset(file,dir,exe)
  dir = dir or "."
  local errorlevel = tex(file,dir,exedraftmode(exe,1,typesetruns))
  if errorlevel ~= 0 then
    return errorlevel
  end
  local name = jobname(file)
  errorlevel = biber(name,dir) + bibtex(name,dir)
  if errorlevel ~= 0 then
    return errorlevel
  end
  for i = 2,typesetruns do
    errorlevel =
      makeindex(name,dir,".glo",".gls",".glg",glossarystyle) +
      makeindex(name,dir,".idx",".ind",".ilg",indexstyle)    +
      tex(file,dir,exedraftmode(exe,i,typesetruns))
    if errorlevel ~= 0 then break end
  end
  return errorlevel
end


-- User guides

guidetypesetruns = 5

typesetdemosourcefiles = { "musterlogo.eps", "me.lco", "ich.lco" }

typesetdemofiles = {
   -- The English examples:
   "letter-example-00-en.tex", "letter-example-01-en.tex",
   "letter-example-02-en.tex", "letter-example-03-en.tex",
   "letter-example-04-en.tex", "letter-example-05-en.tex",
   "letter-example-06-en.tex", "letter-example-07-en.tex",
   "letter-example-08-en.tex", "letter-example-09-en.tex",
   "letter-example-10-en.tex", "letter-example-11-en.tex",
   "letter-example-12-en.tex", "letter-example-13-en.tex",
   "letter-example-14-en.tex", "letter-example-15-en.tex",
   "letter-example-16-en.tex", "letter-example-17-en.tex",
   "letter-example-18-en.tex", "letter-example-19-en.tex",
   "letter-example-20-en.tex", "letter-example-21-en.tex",
   "letter-example-22-en.tex", "letter-example-23-en.tex",
   "scrjura-example-en.tex",
   "scrlayer-notecolumn-example-en.tex",
   "book-remarkbox-nopatch-en.tex",
   "book-remarkbox-patch-en.tex",
   -- The German examples:
   "letter-example-00-de.tex", "letter-example-01-de.tex",
   "letter-example-02-de.tex", "letter-example-03-de.tex",
   "letter-example-04-de.tex", "letter-example-05-de.tex",
   "letter-example-06-de.tex", "letter-example-07-de.tex",
   "letter-example-08-de.tex", "letter-example-09-de.tex",
   "letter-example-10-de.tex", "letter-example-11-de.tex",
   "letter-example-12-de.tex", "letter-example-13-de.tex",
   "letter-example-14-de.tex", "letter-example-15-de.tex",
   "letter-example-16-de.tex", "letter-example-17-de.tex",
   "letter-example-18-de.tex", "letter-example-19-de.tex",
   "letter-example-20-de.tex", "letter-example-21-de.tex",
   "letter-example-22-de.tex", "letter-example-23-de.tex",
   "scrjura-example-de.tex",
   "scrlayer-notecolumn-example-de.tex",
   "book-remarkbox-nopatch-de.tex",
   "book-remarkbox-patch-de.tex"
}

docfiledir   = "doc"

docfiles     = {
   -- General files
   "scrguide.cls", "scrguide.ist", "scrguide.gst",
   "scrguide-body.tex", "linkalias.tex",
   "scrlttr2-examples.dtx",
   "plength-tikz.tex",
   "variables-tikz.tex",
   -- The English user guide files (main file is in typesetfiles)
   "terms-en.tex",
   "preface-en.tex",
   "introduction-en.tex",
   "authorpart-en.tex",
   "typearea-en.tex",
   "scrbookreportarticle-en.tex",
   "scrlttr2-en.tex",
   "scrlayer-scrpage-en.tex",
   "scrdate-en.tex",
   "scrtime-en.tex",
   "scraddr-en.tex",
   "scrextend-en.tex",
   "scrjura-en.tex",
   "scrlogo-en.tex",
   "common-options-en.tex",
   "common-compatibility-en.tex",
   "common-draftmode-en.tex",
   "common-typearea-en.tex",
   "common-fontsize-en.tex",
   "common-textmarkup-en.tex",
   "common-titles-en.tex",
   "common-parmarkup-en.tex",
   "common-oddorevenpage-en.tex",
   "common-interleafpage-en.tex",
   "common-footnotes-en.tex",
   "common-dictum-en.tex",
   "common-lists-en.tex",
   "common-marginpar-en.tex",
   "common-headfootheight-en.tex",
   "common-pagestylemanipulation-en.tex",
   "expertpart-en.tex",
   "scrbase-en.tex",
   "scrlfile-en.tex",
   "scrwfile-en.tex",
   "tocbasic-en.tex",
   "scrlayer-en.tex",
   "scrlayer-scrpage-experts-en.tex",
   "scrlayer-notecolumn-en.tex",
   "typearea-experts-en.tex",
   "scrbookreportarticle-experts-en.tex",
   "scrlttr2-experts-en.tex",
   "common-footnotes-experts-en.tex",
   "japanlco-en.tex",
   -- The German user guide files (main file is in typesetfiles)
   "terms-de.tex",
   "preface-de.tex",
   "introduction-de.tex",
   "authorpart-de.tex",
   "typearea-de.tex",
   "scrbookreportarticle-de.tex",
   "scrlttr2-de.tex",
   "scrlayer-scrpage-de.tex",
   "scrdate-de.tex",
   "scrtime-de.tex",
   "scraddr-de.tex",
   "scrextend-de.tex",
   "scrjura-de.tex",
   "scrlogo-de.tex",
   "common-options-de.tex",
   "common-compatibility-de.tex",
   "common-draftmode-de.tex",
   "common-typearea-de.tex",
   "common-fontsize-de.tex",
   "common-textmarkup-de.tex",
   "common-titles-de.tex",
   "common-parmarkup-de.tex",
   "common-oddorevenpage-de.tex",
   "common-interleafpage-de.tex",
   "common-footnotes-de.tex",
   "common-dictum-de.tex",
   "common-lists-de.tex",
   "common-marginpar-de.tex",
   "common-headfootheight-de.tex",
   "common-pagestylemanipulation-de.tex",
   "expertpart-de.tex",
   "scrbase-de.tex",
   "scrlfile-de.tex",
   "scrwfile-de.tex",
   "tocbasic-de.tex",
   "scrlayer-de.tex",
   "scrlayer-scrpage-experts-de.tex",
   "scrlayer-notecolumn-de.tex",
   "typearea-experts-de.tex",
   "scrbookreportarticle-experts-de.tex",
   "scrlttr2-experts-de.tex",
   "common-footnotes-experts-de.tex",
   -- "japanlco-de.tex" -- intentionally missing
}

guideindexstyle    = "scrguide.ist"
guideglossarystyle = "scrguide.gst"

-- Typesetting

function docinit_hook()
   local demofile
   local guidefile
   local errorlevel = 0
   for _,demofile in ipairs(typesetdemosourcefiles) do
      errorlevel = cp(demofile,unpackdir,typesetdir)
      if errorlevel ~=0 then return errorlevel end
   end
   specialtypesetting = specialtypesetting or {}
   for _,demofile in ipairs(typesetdemofiles) do
      errorlevel = cp(demofile,unpackdir,typesetdir)
      if errorlevel ~= 0 then return errorlevel end
      -- Add to specialtypesetting to do typeset_example() instead of typeset()
      if specialtypesetting[demofile] == nil then
	 specialtypesetting[demofile] = {func = typeset_example,
					 cmd  = "pdflatex-dev"}
      end
   end
   return errorlevel
end

package_doc = {
   scraddr = {
      chapter_en = 'Accessing Address Files with <tt>scraddr</tt>',
      chapter_de = 'Adressdateien mit <tt>scraddr</tt> erschließen',
      link       = 'chapter.8'
   },
   scrartcl = {
      chapter_en = 'The Main Classes: <tt>scrbook</tt>, <tt>scrreprt</tt>, and <tt>scrartcl</tt>',
      chapter_de = 'Die Hauptklassen <tt>scrbook</tt>, <tt>scrreprt</tt>, <tt>scrartcl</tt>',
      link       = 'chapter.3'
   },
   scrarticle = {
      chapter_en = 'The Main Classes: <tt>scrbook</tt>, <tt>scrreprt</tt>, and <tt>scrartcl</tt>',
      chapter_de = 'Die Hauptklassen <tt>scrbook</tt>, <tt>scrreprt</tt>, <tt>scrartcl</tt>',
      link       = 'chapter.3'
   },
   scrbase = {
      chapter_en = 'Basic Functions in the <tt>scrbase</tt> Package',
      chapter_de = 'Grundlegende Funktionen im Paket <tt>scrbase</tt>',
      link       = 'chapter.12'
   },
   scrbook = {
      chapter_en = 'The Main Classes: <tt>scrbook</tt>, <tt>scrreprt</tt>, and <tt>scrartcl</tt>',
      chapter_de = 'Die Hauptklassen <tt>scrbook</tt>, <tt>scrreprt</tt>, <tt>scrartcl</tt>',
      link       = 'chapter.3'
   },
   scrdate = {
      chapter_en = 'The Day of the Week with <tt>scrdate</tt>',
      chapter_de = 'Der Wochentag mit <tt>scrdate</tt>',
      link       = 'chapter.6'
   },
   scrextend = {
      chapter_en = 'Using Basic Features of the KOMA-Script Classes in Other Classes with the <tt>scrextend</tt> Package',
      chapter_de = 'Grundlegende Fähigkeiten der KOMA-Script-Klassen mit Hilfe des Pakets <tt>scrextend</tt> anderen Klassen erschließen',
      link       = 'chapter.9'
   },
   scrjura = {
      chapter_en = 'Support for the Law Office with <tt>scrjura</tt>',
      chapter_de = 'Unterstützung für die Anwaltspraxis durch <tt>scrjura</tt>',
      link       = 'chapter.10'
   },
   scrkbase = {
      note_en = 'It is an internal package only. Is is used by all KOMA-Script classes and most of the other KOMA-Script packages. Neither users nor developers of third party classes or packages should load this package on their own.',
      note_de = 'Es handelt sich hierbei um ein rein internes Paket. Dieses wird von allen KOMA-Script-Klassen und den meisten anderen KOMA-Script-Paketen verwendet. Weder Benutzer noch Entwickler anderer Klassen oder Pakete sollten dieses Paket selbst laden.'
   },
   scrlayer = {
      chapter_en = 'Defining Layers and Page Styles with <tt>scrlayer</tt>',
      chapter_de = 'Definition von Ebenen und Seitenstilen mit <tt>scrlayer</tt>',
      link       = 'chapter.17'
   },
   scrletter = {
      chapter_en = 'Letters with the <tt>scrlttr2</tt> Class or the <tt>scrletter</tt> Package',
      chapter_de = 'Briefe mit Klasse <tt>scrlttr2</tt> oder Paket <tt>scrletter</tt>',
      link       = 'chapter.4'
   },
   scrlfile = {
      chapter_en = 'Controlling Package Dependencies with <tt>scrlfile</tt>',
      chapter_de = 'Paketabhängigkeiten mit <tt>scrlfile</tt> beherrschen',
      link       = 'chapter.13'
   },
   scrlogo = {
      chapter_en = 'The KOMA - Script Logo with Package <tt>scrlogo</tt>',
      chapter_de = 'Das KOMA - Script-Logo mit Paket <tt>scrlogo</tt>',
      link       = 'chapter.11'
   },
   scrlttr2 = {
      chapter_en = 'Letters with the <tt>scrlttr2</tt> Class or the <tt>scrletter</tt> Package',
      chapter_de = 'Briefe mit Klasse <tt>scrlttr2</tt> oder Paket <tt>scrletter</tt>',
      link       = 'chapter.4'
   },
   scrreprt = {
      chapter_en = 'The Main Classes: <tt>scrbook</tt>, <tt>scrreprt</tt>, and <tt>scrartcl</tt>',
      chapter_de = 'Die Hauptklassen <tt>scrbook</tt>, <tt>scrreprt</tt>, <tt>scrartcl</tt>',
      link       = 'chapter.3'
   },
   scrreport = {
      chapter_en = 'The Main Classes: <tt>scrbook</tt>, <tt>scrreprt</tt>, and <tt>scrartcl</tt>',
      chapter_de = 'Die Hauptklassen <tt>scrbook</tt>, <tt>scrreprt</tt>, <tt>scrartcl</tt>',
      link       = 'chapter.3'
   },
   scrtime = {
      chapter_en = 'The Current Time with <tt>scrtime</tt>',
      chapter_de = 'Die aktuelle Zeit mit <tt>scrtime</tt>',
      link       = 'chapter.7'
   },
   tocbasic = {
      chapter_en = 'Managing Content Lists with <tt>tocbasic</tt>',
      chapter_de = 'Verzeichnisse verwalten mit Hilfe von <tt>tocbasic</tt>',
      link       = 'chapter.15'
   },
   typearea = {
      chapter_en = 'Calculating the Page Layout with <tt>typearea</tt>',
      chapter_de = 'Satzspiegelberechnung mit <tt>typearea.sty</tt>',
      link       = 'chapter.2'
   }
}

package_doc["scrlfile-hook"] = {
   note_en = 'It is an internal package, that should never be used directly. You should load <tt><a href="scrlfile.html">scrlfile</a></tt> instead.',
   note_de = 'Es handelt sich hierbei im ein internes Paket, das niemals direkt geladen werden sollte. Stattdessen sollte <tt><a href="scrlfile.html">scrlfile</a></tt> geladen werden.'
}
package_doc["scrlfile-hook-3.34"]     = package_doc["scrlfile-hook"]
package_doc["scrlfile-patcholdlatex"] = package_doc["scrlfile-hook"]

package_doc["scrlayer-notecolumn"] = {
   chapter_en = 'Note Columns with <tt>scrlayer-notecolumn</tt>',
   chapter_de = 'Notizspalten mit <tt>scrlayer-notecolumn</tt>',
   link       = 'chapter.19'
}

package_doc["scrlayer-scrpage"] = {
   chapter_en = 'Headers and Footers with <tt>scrlayer-scrpage</tt>',
   chapter_de = 'Kopf- und Fußzeilen mit <tt>scrlayer-scrpage</tt>',
   link       = 'chapter.5'
}

function generate_package_doc()
   local pkg
   local info
   local htmldir = tdsdir .. "/doc/" .. tdsroot .. "/" .. ctanpkg
   for pkg,info in pairs(package_doc) do
      print( "Generating " .. pkg .. ".html" )
      local html = assert(io.open(htmldir .. "/" .. pkg .. ".html", "wb"))
      if info.chapter_en ~= nil then
	 local title = string.gsub( info.chapter_en, '</?tt>', '' )
	 html:write( [[<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html 
          PUBLIC "-//W3C//DTD XHTML 1.1//EN"
          "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <meta name="keywords" content="KOMA-Script, ]] .. pkg .. [[ 
    <meta name="DC.Title" content="]] .. title .. [[" />
    <meta name="DC.Creator" content="l3build" />
    <meta name="DC.Subject" content="KOMA-Script Documentation" />
    <meta name="DC.Description" content="Where to find the KOMA-Script
                                         documentation of ]] .. pkg .. [[" />
    <meta name="DC.Publisher" content="Markus kohm" />
    <meta name="DC.Date" content="2022-06-03" />
    <meta name="DC.Type" content="Text" />
    <meta name="DC.Format" content="text/html" />
    <meta name="DC.Identifier" content="]] ..pkg .. [[.html" />
    <meta name="DC.Language" content="en,de" />
    <meta name="DC.Relation" content="Link to documentation" />
    <meta name="DC.Coverage" content="Version since 3.00" />
    <meta name="DC.Rights" content="LaTeX Public Private License 1.3c" />
    <title>]] .. title .. [[</title>
    <style type="text/css">
      <!--
          body {}
          #en { position:absolute; left:10px; width:45%; }
          #de { position:absolute; right:10px; width:45%; }
          #fn { position:absolute; bottom:0px; width:50%; 
                border-top-width:1px; border-top-style:solid; 
                font-size:x-small; }
          h1.right { text-align:right; }
        -->
    </style>
  </head>
  <body>
    <h1>]] .. info.chapter_en .. [[</h1>
    <h1 class="right">]] .. info.chapter_de .. [[</h1>
    <div id="en">
      I think you are searching for the chapter
      <a href="scrguide-en.pdf#]]
	    .. info.link .. [[">“]] .. info.chapter_en .. [[”</a> in the
      KOMA-Script documentation.
    </div>
    <div id="de">
      Ich nehme an, Sie suchen nach dem Kapitel
      <a href="scrguide-de.pdf#]]
	    .. info.link .. [[">„]] .. info.chapter_de .. [[”</a> in der
      KOMA-Script-Anleitung.
    </div>
    <div id="fn">
      Markus Kohm, 2022-06-03
      <p><a
        href="http://validator.w3.org/check?uri=referer"><img
        src="http://www.w3.org/Icons/valid-xhtml11" alt="Valid XHTML 1.1" 
        height="31" width="88" /></a></p>
     </div>
  </body>
</html>
 ]] .. "\n" )
      else
	 local title_en = info.title_en
	    or ( "KOMA-Script Package <tt>" .. pkg .. "</tt>" )
	 local title_de = info.title_de
	    or ( "KOMA-Script-Paket <tt>" .. pkg .. "</tt>" )
	 local title = string.gsub( title_en, '</?tt>', "" )
	 local note_en = info.note_en or ""
	 local note_de = info.note_de or ""
	 html:write( [[<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html 
          PUBLIC "-//W3C//DTD XHTML 1.1//EN"
          "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <meta name="keywords" content="KOMA-Script, ]] .. pkg .. [[ 
    <meta name="DC.Title" content="]] .. title .. [[" />
    <meta name="DC.Creator" content="l3build" />
    <meta name="DC.Subject" content="KOMA-Script Documentation" />
    <meta name="DC.Description" content="Where to find the KOMA-Script
                                         documentation of ]] .. pkg .. [[" />
    <meta name="DC.Publisher" content="Markus kohm" />
    <meta name="DC.Date" content="2022-06-03" />
    <meta name="DC.Type" content="Text" />
    <meta name="DC.Format" content="text/html" />
    <meta name="DC.Identifier" content="]] ..pkg .. [[.html" />
    <meta name="DC.Language" content="en,de" />
    <meta name="DC.Relation" content="Link to documentation" />
    <meta name="DC.Coverage" content="Version since 3.00" />
    <meta name="DC.Rights" content="LaTeX Public Private License 1.3c" />
    <title>]] .. title .. [[</title>
    <style type="text/css">
      <!--
          body {}
          #en { position:absolute; left:10px; width:45%; }
          #de { position:absolute; right:10px; width:45%; }
          #fn { position:absolute; bottom:0px; width:50%; 
                border-top-width:1px; border-top-style:solid; 
                font-size:x-small; }
          h1.right { text-align:right; }
        -->
    </style>
  </head>
  <body>
    <h1>]] .. title_en .. [[</h1>
    <h1 class="right">]] .. title_de .. [[</h1>
    <div id="en">
      There is no information about ]] .. pkg .. [[ in the
      <a href="scrguide-en.pdf">KOMA-Script user manual</a>.
]] .. note_en .. [[
    </div>
    <div id="de">
      Es gibt keine Informationen zu ]] .. pkg .. [[ in der
      <a href="scrguide-de.pdf">KOMA-Script Benutzeranleitung</a>.
]] .. note_de .. [[
    </div>
    <div id="fn">
      Markus Kohm, 2022-06-03
      <p><a
        href="http://validator.w3.org/check?uri=referer"><img
        src="http://www.w3.org/Icons/valid-xhtml11" alt="Valid XHTML 1.1" 
        height="31" width="88" /></a></p>
     </div>
  </body>
</html>
 ]] .. "\n" )
      end
      html:close()
   end

   local destdir = ctandir.."/"..ctanpkg
   if not flattern then
      destdir = string.gsub( destdir .. "/" .. docfiledir, "/%.", "" )
   end
   cp("*.html",htmldir,destdir)
end

--[[
   This is a simlified version of original function typeset():
   * do not run makeindex
   * do not run biber or bibtex
   * do at least two typeset runs up to specialtypesetting[file].runs
]]
function typeset_example(file,dir,exe)
  print("Typesetting example file " .. file .. " using " .. exe)
  dir = dir or "."
  local demotypesetruns = specialtypesetting[file].runs or 2
  local errorlevel = tex(file,dir,exedraftmode(exe,1,demotypesetruns))
  if errorlevel ~= 0 then
    return errorlevel
  end
  for i = 2,demotypesetruns do
     errorlevel = tex(file,dir,exedraftmode(exe,i,demotypesetruns))
     if errorlevel ~= 0 then break end
  end
  return errorlevel
end

--[[
   This is almost the original function typeset() but with some replacements:
   * makeindex() of the index by genindex(),
   * indexstyle by guideindexstyle,
   * glossarystyle by guideglossarystyle,
   * typesetexe by guidetypesetexe,
   * typesetruns by guidetypesetruns
]]
function typeset_guide(file,dir,exe)
   print("Typesetting guide main file " .. file .. " using " .. exe)
   dir = dir or "."
   local errorlevel = tex(file,dir,exedraftmode(exe,1,guidetypesetruns))
   if errorlevel ~= 0 then
      return errorlevel
   end
   local name = jobname(file)
   errorlevel = biber(name,dir) + bibtex(name,dir)
   if errorlevel ~= 0 then
      return errorlevel
   end
   for i = 2,guidetypesetruns do
      errorlevel = 
	 makeindex(name,dir,".glo",".gls",".glg",guideglossarystyle) +
	 genindex(name,dir,".idx",".ind",".ilg",guideindexstyle)    +
	 tex(file,dir,exedraftmode(exe,i,guidetypesetruns))
      if errorlevel ~= 0 then break end
   end
   return errorlevel
end

specialtypesetting = {
   ["scrguide-en.tex"]                    = {func = typeset_guide,
					     cmd  = "pdflatex-dev"},
   ["scrguide-de.tex"]                    = {func = typeset_guide,
					     cmd  = "pdflatex-dev"},
   ["scrlayer-notecolumn-example-en.tex"] = {func = typeset_example,
					     cmd  = "pdflatex-dev",
					     runs = 5},
   ["scrlayer-notecolumn-example-de.tex"] = {func = typeset_example,
					     cmd  = "pdflatex-dev",
					     runs = 5},
   ["scrjura-example-en.tex"]             = {func = typeset_example,
					     cmd  = "pdflatex-dev",
					     runs = 3},
   ["scrjura-example-de.tex"]             = {func = typeset_example,
					     cmd  = "pdflatex-dev",
					     runs = 3},
   ["book-remarkbox-nopatch-en.tex"]      = {func = typeset_example,
					     cmd  = "pdflatex-dev",
					     runs = 3},
   ["book-remarkbox-patch-en.tex"]        = {func = typeset_example,
					     cmd  = "pdflatex-dev",
					     runs = 3},
   ["book-remarkbox-nopatch-de.tex"]      = {func = typeset_example,
					     cmd  = "pdflatex-dev",
					     runs = 3},
   ["book-remarkbox-patch-de.tex"]        = {func = typeset_example,
					     cmd  = "pdflatex-dev",
					     runs = 3},
}

-- Implementation of additional targets

-- Target: genindex

-- Split one index and generate it
function genindex(name,dir,extidx,extind,extlog,style)
   local errorlevel = 0
   local dstfile = {}
   local srcidx = dir .. "/" .. name .. extidx
   local srcfile = io.open(srcidx,"r")
   if srcfile == nil then
      print("    Warning: Cannot open index file " .. srcidx)
      return 1
   end

   -- 1st pass: search for all sub-index files used
   local line
   for line in srcfile:lines() do
      local p,l,subidx = string.find(line,"\\UseIndex%s*{(.-)}")
      if subidx ~= nil and dstfile[subidx] == nil then
	 local filename = dir .. "/" .. name .. "-" .. subidx .. extidx
	 dstfile[subidx] = io.open(filename,"w")
      end
   end

   -- 2nd pass: copy all entries to the proper sub file
   srcfile:seek("set",0)
   for line in srcfile:lines() do
      local p,l,subidx = string.find(line,"\\UseIndex%s*{(.-)}")
      subidx = subidx or "gen"
      if dstfile[subidx] ~= nil then
	 dstfile[subidx]:write(line,"\n")
      end
   end
   
   -- close all files
   srcfile:close()
   local subfile
   local subidx
   for subidx,subfile in pairs(dstfile) do
      local subname = name .. "-" .. subidx
      local errlevel = 0
      print("    Make subindex " .. subidx )
      subfile:close()
      errlevel = makeindex(subname,dir,extidx,extind,extlog,style)
      if errlevel ~= 0 then
	 if options["halt-on-error"] then
	    return errlevel
	 else
	    errorlevel = errorlevel + errlevel
	 end
      end
   end

   return errorlevel
end

-- Target main function
function genindexes(names)
   local errorlevel = 0
   names = names or { }
   -- No names passed: find all index files of source files
   if not next(names) then
      -- ToDo: Not yet implemented
      print( "genindexes without arguments not yet implemented." )
      return 1
   end
   -- Run the splittings
   print("Running genindex on")
   for i, name in ipairs(names) do
      print("  " .. name .. " (" .. i .. "/" .. #names .. ")")
      -- ToDo: Allow to run it outside typesetdir
      --       (maybe by giving a file name istead of a name).
      local errlevel = genindex(name,typesetdir,".idx",".ind",".ilg",indexstyle)
      if errlevel ~= 0 then
	 if options["halt-on-error"] then
	    return errlevel
	 else
	    errorlevel = errlevel
	    print("        --> failed\n")
	 end
      end
   end
   if errorlevel == 0 then
      print("\n  All splittings passed\n")
   end
   return errorlevel
end

-- Add target to the target list table
target_list.genindex =
   {
      desc = "splitting the index files",
      func = genindexes
   }

-- tagging

--[[
   After tagging the files, we create the new README file
]]

-- get version of a class file
local function getclsversion(filename)
   local f = assert(io.open(unpackdir.."/testversion.tex","w"))
   local versionstring=nil
   f:write('\\documentclass{' .. string.sub(filename,1,-5) .. '}\n')
   f:write([[
\makeatletter
\newwrite\versionfile
\immediate\openout\versionfile testversion.txt
\def\writeversion#1 KOMA-Script#2\@nil{\immediate\write\versionfile{#1}}
\expandafter\expandafter\expandafter\writeversion \csname ver@]]
	 .. filename ..
	 [[\endcsname KOMA-Script\@nil
\immediate\closeout\versionfile
\@@end\end
\makeatother
\begin{document}\end{document}
]])
   f:close()
   
   if tex("testversion.tex",unpackdir,"pdflatex --interaction=batchmode") == 0 then
      f=assert(io.open(unpackdir.."/testversion.txt"))
      versionstring=f:read("*all")
      versionstring=string.gsub(versionstring,"\n"," ")
      f:close()
   end

   rm(unpackdir,"testversion.*")
   return versionstring
end

-- get version of a package file
local function getstyversion(filename)
   local f = assert(io.open(unpackdir.."/testversion.tex","w"))
   local versionstring=nil
   f:write([[
\documentclass{minimal}
\makeatletter
\newwrite\versionfile
\immediate\openout\versionfile testversion.txt
\def\writeversion#1 KOMA-Script#2\@nil{\immediate\write\versionfile{#1}}
\RenewDocumentCommand{\ProvidesPackage}{mo}{%
  \edef\cmpA{#1}%
  \edef\cmpB{]] .. string.sub(filename,1,-5) .. [[}%
  \ifx\cmpA\cmpB
    \expandafter\writeversion#2 KOMA-Script\@nil
    \csname endinput\endcsname
  \fi
}
\makeatother
\usepackage{]] .. string.sub(filename,1,-5) .. [[}
\csname @@end\endcsname\end
\begin{document}\end{document}
]])
   f:close()
   
   if tex("testversion.tex",unpackdir,"pdflatex --interaction=batchmode") == 0 then
      f=assert(io.open(unpackdir.."/testversion.txt"))
      versionstring=f:read("*all")
      versionstring=string.gsub(versionstring,"\n"," ")
      f:close()
   end

   rm(unpackdir,"testversion.*")
   return versionstring
end

--[[
   generate README.txt resp. README.md from README.in/README.* and
   unpacked source files
]]
function generate_readme_txt(tagname,tagdate)
   local versionnames = {}
   local mainversion
   local year

   unpack({sourcefiles},{sourcefiledir})

   for _,p in ipairs(tree("README.in","README.*")) do
      local readmename = basename(p.src)
      local filename = string.sub(readmename,8,-1)
      if fileexists(unpackdir.."/"..filename) then
	 if string.match( filename, "%.cls$" ) then
	    versionnames[readmename] = getclsversion( filename )
	 elseif string.match( filename, "%.sty$" ) then
	    versionnames[readmename] = getstyversion( filename )
	 end
      else
	 error("File " .. filename .. " is missing in unpacked!")
	 return 1
      end
   end

   if tagname == nil then
      mainversion = versionnames["README.scrartcl.cls"] or ( tagdate .. " v?.??" )
      year = string.sub(mainversion,1,4)
   else
      mainversion = tagdate .. " " .. tagname
      year = string.sub(tagdate,1,4)
   end

   local readme_out = assert(io.open("README.txt","w"))
   readme_out:write("KOMA-Script " .. mainversion .. "\n")
   readme_out:write("Copyright Markus Kohm <komascript@gmx.info> 1994–" .. year .. "\n\n")
   readme_out:write([[
This material is subject to the LaTeX Project Public License Version 1.3c.
See lppl.txt (English) or lppl-de.txt (German) for the details of that
license.
------------------------------------------------------------------------------
KOMA-Script is a versatile bundle of LaTeX2e document classes and packages.
The classes are designed as replacements to the standard LaTeX2e classes.
Several features have been added to make them more configurable.
------------------------------------------------------------------------------
Installation:

We highly recommend installing the latest official release via the package
manager of the TeX distribution you are using. For example, for Vanilla TeX
Live this would be `tlmgr` or `tlshell` or `tlcockpit`. For MiKTeX it would be
`MiKTeX Console`. Linux users who use the TeX Live of their Linux distribution
will often find KOMA script in one of the many TeX Live supplementary
packages. In Debian, for example, it is in `texlive-latex-recommended`.

If the package manager does not offer the desired KOMA-Script version, you can
find various versions via https://komascript.de/current in the KOMA-Script
project. There is also the installation from a TDS archive explained.

From KOMA-Script sources of a release on SourceForge
→ <https://sourceforge.net/p/koma-script/code/HEAD/tree/tags/> one can build
and even install KOMA-Script with the help of `l3build`. More details can be
found in the instructions for `l3build`.

If you want to generate KOMA-Script step by step from the sources, first run
`tex scrmain.ins`. This will generate a larger number of files with the
extensions `.cls`, `.sty`, `.lco`, `.clo` and `.hak`. All these files are
needed for KOMA-Script to work properly. They have to be copied either into
the document directory of your LaTeX project or into a directory of one of
your TEXMF search trees. In the TEXMF search tree further actions may be
necessary. Consult the instructions of your TeX distribution. After the
correct installation of these files, the manual is to be generated. To do
this, change to the subdirectory `/doc` and first run `pdflatex
scrguide-en.tex` there. Then repeat the runs of `bibtex scrguide-en`,
`makeindex scrguide-en`, `pdflatex scrguide-en.tex` min. four times. This
way you get a form of the English user manual with a simplified index. The
German user manual can be generated in the same way by substituting
`scrguide-en` for `scrguide-de`.

If you like to have the implementation documentation of KOMA-Script as a PDF,
first create the required class `koma-script-source-doc.cls` with
`tex koma-script-source-doc.dx`. This class can then be used to generate the
implementation documentation of this class with repeated calls to
`lualatex-dev koma-script-source-doc.dtx` and
`mkindex koma-script-source-doc`. Correspondingly, the documentation of the
other KOMA-Script components can be generated.
------------------------------------------------------------------------------
Classes and packages in this release:
]]
   )

   for _,p in ipairs(tree("README.in","README.*")) do
      local readmename = basename(p.src)
      local f = assert(io.open("README.in".."/"..readmename,"rb"))
      local content = f:read("*all")
      f:close()
      if versionnames[readmename] ~= nil then
	 content = string.gsub(content,
			       "!!!THIS WILL BE SET BY THE RELEASE PROCESS!!!",
			       versionnames[readmename])
      end
      readme_out:write("==============================================================================\n")
      readme_out:write(content)
   end

   readme_out:write("==============================================================================\n")
   readme_out:close()

   return 0
end

function generate_readme_md(tagname,tagdate)
   local versionnames = {}
   local mainversion
   local year
   local readmenames = {}
   local readmename

   unpack({sourcefiles},{sourcefiledir})

   for _,p in ipairs(tree("README.in","README.*")) do
      readmename = basename(p.src)
      local filename = string.sub(readmename,8,-1)
      table.insert(readmenames, readmename)
      if fileexists(unpackdir.."/"..filename) then
	 if string.match( filename, "%.cls$" ) then
	    versionnames[readmename] = getclsversion( filename )
	 elseif string.match( filename, "%.sty$" ) then
	    versionnames[readmename] = getstyversion( filename )
	 end
      else
	 error("File " .. filename .. " is missing in unpacked!")
	 return 1
      end
   end
   table.sort(readmenames)

   if tagname == nil then
      mainversion = versionnames["README.scrartcl.cls"] or ( tagdate .. " v?.??" )
      year = string.sub(mainversion,1,4)
   else
      mainversion = tagdate .. " " .. tagname
      year = string.sub(tagdate,1,4)
   end

   local readme_out = assert(io.open("README.md","w"))
   readme_out:write("# KOMA-Script " .. mainversion .. "\n")
   readme_out:write("Copyright [Markus Kohm](mailto:komascript@gmx.info) 1994–" .. year .. "\n\n")
   readme_out:write([[
This material is subject to the LaTeX Project Public License Version 1.3c. See [`lppl.txt`](lppl.txt) (English) or [`lppl-de.txt`](lppl-de.txt) (German) for the details of that license.

------------------------------------------------------------------------------

KOMA-Script is a versatile bundle of LaTeX2e document classes and packages. The classes are designed as replacements to the standard LaTeX2e classes. Several features have been added to make them more configurable.

------------------------------------------------------------------------------

## Classes and packages in this release:

]]
   )

   for _,readmename in ipairs(readmenames) do
      local f = assert(io.open("README.in".."/"..readmename,"rb"))
      local content = f:read("*all")
      f:close()
      if versionnames[readmename] ~= nil then
	 content = string.gsub(content,
			       "!!!THIS WILL BE SET BY THE RELEASE PROCESS!!!",
			       versionnames[readmename])
      end
      content = string.gsub(content,'\n%-+%s*\n','\n<pre>\n')
      content = string.gsub('###' .. content,'^###([%w%-.]+)%s+-','### `%1` —')
      content = string.gsub(content, 'komascript at gmx info', 'komascript@gmx.info')
      readme_out:write(content)
      readme_out:write('</pre>\n***\n\n')
   end

   readme_out:write( [[
## Installation:

We highly recommend installing the latest official release via the package manager of the TeX distribution you are using. For example, for Vanilla TeX Live this would be `tlmgr` or `tlshell` or `tlcockpit`. For MiKTeX it would be `MiKTeX Console`. Linux users who use the TeX Live of their Linux distribution will often find KOMA script in one of the many TeX Live supplementary packages. In Debian, for example, it is in `texlive-latex-recommended`.

If the package manager does not offer the desired KOMA-Script version, you can find [various versions in the KOMA-Script Project](https://komascript.de/current). There is also the installation from a TDS archive explained.

From KOMA-Script sources of a [release on SourceForge](https://sourceforge.net/p/koma-script/code/HEAD/tree/tags/) one can build and even install KOMA-Script with the help of `l3build`. More details can be found in the instructions for `l3build`.

If you want to generate KOMA-Script step by step from the sources, first run `tex scrmain.ins`. This will generate a larger number of files with the extensions `.cls`, `.sty`, `.lco`, `.clo` and `.hak`. All these files are needed for KOMA-Script to work properly. They have to be copied either into the document directory of your LaTeX project or into a directory of one of your TEXMF search trees. In the TEXMF search tree further actions may be necessary. Consult the instructions of your TeX distribution. After the correct installation of these files, the manual is to be generated. To do this, change to the subdirectory `/doc` and first run `pdflatex scrguide-en.tex` there. Then repeat the runs of `bibtex scrguide-en`, `makeindex scrguide-en`, `pdflatex scrguide-en.tex` min. four times. This way you get a form of the English user manual with a simplified index. The German user manual can be generated in the same way by substituting `scrguide-en` for `scrguide-de`.

If you like to have the implementation documentation of KOMA-Script as a PDF, first create the required class `koma-script-source-doc.cls` with `tex koma-script-source-doc.dx`. This class can then be used to generate the implementation documentation of this class with repeated calls to `lualatex-dev koma-script-source-doc.dtx` and `mkindex koma-script-source-doc`. Correspondingly, the documentation of the other KOMA-Script components can be generated.
]]
   )
   
   readme_out:close()

   return 0
end

function tag_hook(tagname,tagdate)
   return generate_readme_md(tagname,tagdate)
end

--[[
   Target manifest

   Note: We are currently using a handmade MANIFEST.md. So this function
         has to be deactivated to not overwrite the handmade file
         accidentally.

   ToDo: Maybe this should be used to generate the README file?
]]

function manifest()
   error( 'We are currently using a handmade "MANIFEST.md".\nSo target "manifest" should not be used!' )
end

target_list.manifest.func = manifest

-- CTAN package generation and upload

flatten    = false
tdsflatten = false
packtdszip = true

uploadconfig = {
   pkg        = "koma-script",
   author     = "Markus Kohm",
   license    = "lppl1.3c",
   summary    = "A bundle of versatile classes and packages",
   topic      = { "page-hf",
		  "class",
		  "geometry",
		  "letter",
		  "book-pub",
		  "float",
		  "toc-etc",
		  "legal",
		  "notes",
		  "addr-list",
		  "date-time",
		  "keyval",
                  "package-mgmt",
                  "io-mgmt" },
   ctanPath   = "/macros/latex/contrib/koma-script",
   bugtracker = "https://sourceforge.net/p/koma-script/tickets/",
   home       = "https://komascript.de",
   repository = "https://sourceforge.net/p/koma-script/code",
   development= "https://sourceforge.net/p/koma-script"
}

tdslocations = {
   "source/latex/koma-script/doc/scrlttr2-examples.dtx",
   "source/latex/koma-script/doc/*.tex",
   "source/latex/koma-script/doc/scrguide.*",
   "doc/latex/koma-script/examples/*-example-*.pdf",
   "doc/latex/koma-script/scrguide-*.pdf",
   "doc/latex/koma-script/koma-script-source-doc.pdf",
}

excludefiles = {
   ".*",
   "*~",
   "*.bak",
   "komamarks.dtx", -- in development, not ready for release
   "missing.dtx", -- only a dummy not for releases
   "releaselist.txt", -- information for developers only
   "koma-script-source-doc.pdf",
   "japanlco.pdf",
   "scraddr.pdf",
   "scrextend.pdf",
   "scrjura.pdf",
   "scrkernel-*.pdf",
   "scrlayer.pdf",
   "scrlayer-notecolumn.pdf",
   "scrlayer-scrpage.pdf",
   "scrlfile*.pdf",
   "scrlayer-scrpage.pdf",
   "scrlogo.pdf",
   "scrtime.pdf",
   "tocbasic.pdf"
}

l3buildcopyctan=copyctan

function copyctan()
   l3buildcopyctan()
   generate_package_doc()
   local tdsexampledir = tdsdir .. "/doc/" .. tdsroot .. "/" .. ctanpkg .. "/examples"
   for _,demo in ipairs(typesetdemofiles) do
      cp(demo,typesetdir,tdsexampledir)
   end
   for _,demo in ipairs(typesetdemosourcefiles) do
      cp(demo,typesetdir,tdsexampledir)
   end
end

--[[
   We need a more complicated rewrite_log(), because our version string could
   be
   - v<number>.<number>
   - v<number>.<number>.<number>
   - v<number>.<number> BETA
]]
local l3build_rewrite_log = rewrite_log
function rewrite_log(source, result, engine, errlevels)
   l3build_rewrite_log(source, result, engine, errlevels)
   -- after the general rewrite we do one more change
   local file = assert(io.open(result,"rb"))
   local content = string.gsub(file:read("*all") .. "\n","\r\n","\n")
   io.close(file)
   local new_content = string.gsub(
      string.gsub(
	 string.gsub(
	    content,
	    "%.%.%.%.%-%.%.%-%.%.%s+v%.%.%.%s+BETA%s+KOMA%-Script",
	    "....-..-.. v... KOMA-Script"),
	 "%.%.%.%.%-%.%.%-%.%.%s+v%.%.%.%.%d+%s+KOMA%-Script",
	 "....-..-.. v... KOMA-Script"
      ),
      "\n+$", "\n"
   )
   local newfile = io.open(result,"w")
   io.output(newfile)
   io.write(new_content)
   io.close(newfile)
end
