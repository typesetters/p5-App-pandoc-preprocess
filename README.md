# ppp

`ppp` let's you use [ditaa](http://ditaa.sourceforge.net/), [dot](http://www.graphviz.org/pdf/dotguide.pdf), [rdfdot](https://metacpan.org/release/RDF-Trine-Exporter-GraphViz) and [neato](http://www.graphviz.org/pdf/neatoguide.pdf), [yUML](http://yuml.me) and, finally, [plantuml](http://plantuml.sourceforge.net/) *directly* in your [pandoc](http://johnmacfarlane.net/pandoc/) sources and will transform these into beautiful graphs.

## Usage

    cat chapters/input-*.pandoc | ppp | pandoc -o output.pdf --smart [more pandoc options...]

The good thing here: if you leave `ppp` out of the pipe-chain, your documents are still typeset nicely -- except you have ASCII-UML in code blocks.

See `ppp-Documentation.pandoc` for concrete usage examples and [cpan](https://metacpan.org/pod/App::pandoc::preprocess) for more information.

## Prerequisites

* dot/neato
* rdfdot
* ditaa
* Image::Magick (for downscaling of large images)
* [yuml](https://github.com/wandernauta/yuml) (install as python module using `pip install https://github.com/wandernauta/yuml/zipball/master` or `easy_install https://github.com/wandernauta/yuml/zipball/master`)
* [plantuml](http://plantuml.sourceforge.net/)

## License
WTFPL

## Credits
This package was inspired by [this great idea](https://github.com/nichtich/ditaa-markdown).

the yUML-CLI wrapper by: <https://github.com/wandernauta/yuml>.
