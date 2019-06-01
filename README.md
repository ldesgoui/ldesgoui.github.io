# ldesgoui.github.io

This website is statically generated, the output files can be reached
[here](https://github.com/ldesgoui/ldesgoui.github.io/tree/master).

The bulk of the generation happens in the [Makefile](Makefile), it should be
fairly easy to understand how it works by reading. It depends on the following:

- [Fira Sans and Fira Mono](https://github.com/mozilla/Fira)
- [ImageMagick](https://imagemagick.org)
- [Pandoc](https://pandoc.org)
- [TeX Live](https://www.tug.org/texlive)
- [darkhttpd](http://eradman.com/entrproject)
- [entr](http://eradman.com/entrproject)
- [minify](https://github.com/tdewolff/minify)

I also make use of [GNU Make](https://www.gnu.org/software/make/) and
[`nix`](https://nixos.org/nix). The dependencies can easily be installed by
running `nix-shell` in this directory.

I would like to thank the creators, contributors and maintainers of these
projects.

## Makefile explanations

The default target, `all`, depends on the list of generated files in the master
directory (`master/index.html`, ...).

The `master` target creates an empty repository pointing to the master branch.

The `master/%...` targets all depend on `master` in an order-only way, this
means that updates to `master` won't cause these targets to be considered out
of date. They also all begin with `mkdir --parents "$(@D)"`, making sure that
their output directory is present when created (the target `master/test/test`
would cause `mkdir --parents master/test`).

Some targets are helpers:

- `push` always builds from scratch, minifies said build, commits and pushes it
- `clean` removes the contents of `master` except from `.git`. Note that,
   usually, `clean` is defined to delete build artifacts
- `fclean` completely deletes `master`. Note that, usually, `fclean` depends
   on `clean` and deletes the build result
- `re` deletes and rebuilds everything
- `serve` runs a local web server, hosting the contents of a build
- `watch` starts a process that will `make` whenever the source files are
   touched
- `dev` runs `serve` and `watch` in parallel

These helper targets are declared as `.PHONY`, they will always cause `make` to
run their recipes because they don't have an output on the filesystem.
