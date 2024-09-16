# KOMA-Script tagging lab

This project ist based on files which are  part of KOMA-Script
Copyright [Markus Kohm](mailto:komascript@gmx.info) 1994–2024
The use within this project has been explicitly permitted by Markus Kohm.

The maintainer of this project is Marei Peischl.

Currently this Repository is based on revision 4120 of the KOMA-Script repository, which is located at https://sf.net/projects/koma-script/.

## How to use this bundle

Please ensure to use an up to date LaTeX installation!

We currently are trying to have some kind of patching mechanism to support [Ulrike Fischer's tagpdf](https://github.com/latex3/tagpdf) withing KOMA-Script. Therefore this Bundle is creating a package to adjust the settings.

Currently the setup is still a bit complex but that's under development. Within the `tagging-experiments` directory you find example files to see how to load the package. These files also include some debugging output to compare the structure to the those created by tagpdf itself.

This bundle provides the option to use an extra testphase key, named `KOMA-fixes`.
This will load some adjustments, currently the focus is on the document classes, but by “accident” (or let's say how this project is tangled) some things like the tocbasic package also got involved.

## Installation

It's possible to run the bundle without installation. By default the l3build script is configured to only run all experiment and testfiles when you call

```
l3build doc
```

the actul documentation is not created as the this would require the full KOMA-Script bundle to be built.

This will build all `*.tex` files within the tagging-experiments directory.

To use the package outside of this structure it's possible install the bundle within the user's texmfhome directory using

```
l3build install
```

It's constructed the way that this package will not overwrite your local KOMA-Script installation by default.
It will just add additional configuration files.

Disclaimer: At least a change is not intended ;-) If something feels weird, please report.
