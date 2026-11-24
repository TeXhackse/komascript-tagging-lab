-- tagging tests

tagging_lab_dir=tagging_lab_dir or "tagging-lab/"

checksearch = true
testfiledir = tagging_lab_dir.."testfiles"
testsuppdir = tagging_lab_dir.."support-tests"

checksuppfiles = { "*.tex", "**/*.ltx" }
if options["target"] == "save" then
  checkopts = ""
else
  checkopts = "--interaction=batchmode"
end

checkformat="latex-dev"
stdengine="luatex"

checkengines = {
  "luatex"
}

supportdir = testsuppdir
checkruns = 3
typesetruns = 2
recordstatus = true
