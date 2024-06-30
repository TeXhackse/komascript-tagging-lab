#
# Makefile to generate the obsolete packages and distributions
#

all:
	l3build unpack

clean:
	l3build clean
	rm -rf build *.curlopt upload.lua

dist-ctan:
	l3build ctan

upload-ctan: svncheck dist-ctan
	sed 's/^modules = {.*}/modules = {}/;s/^bundle =/module =/' build.lua > upload.lua
	texlua upload.lua upload
	rm upload.lua

svncheck:
	svn up
	$(eval SVNOUTPUT=$(shell svn status))
	$(if $(SVNOUTPUT),$(error Please commit or revert outstanding changes '$(SVNOUTPUT)'))

help:
	@echo "SUPPORTED RULES"
	@echo "all:          generate all files"
	@echo "clean:        remove all generated files and the temporary files and folders"
	@echo "dist-ctan:    generate a CTAN distribution of KOMA-Script obsolete"
	@echo "upload-ctan:  make the CTAN upload"
	@echo "              NOTE: Before the upload you should use"
	@echo "                      l3build tag <versioninfo>"
	@echo "                    to do the version tagging."
