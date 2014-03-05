# ppp

`ppp` let's you use [ditaa](http://ditaa.sourceforge.net/), [dot](http://www.graphviz.org/pdf/dotguide.pdf), [rdfdot](https://metacpan.org/release/RDF-Trine-Exporter-GraphViz) and [neato](http://www.graphviz.org/pdf/neatoguide.pdf) and [yUML](http://yuml.me) *directly* in your [pandoc](http://johnmacfarlane.net/pandoc/) sources and will transform these into beautiful graphs.

## Usage

    cat chapters/input-*.pandoc | ppp | pandoc -o output.pdf --smart [more pandoc options...]

The good thing here: if you leave `ppp` out of the pipe-chain, your documents are still typeset nicely -- except you have ASCII-UML in code blocks.

See `etc/input.pandoc` for concrete usage examples and [cpan](https://metacpan.org/pod/App::pandoc::preprocess) for more information.

## Prerequisites

* dot/neato
* rdfdot
* ditaa
* Image::Magick (for downscaling of large images)
* the yUML commandline wrapper to the webservice is bundled with this perl-Module and comes from [here](https://github.com/wandernauta/yuml)

## License
WTFPL

## Credits
This package was inspired by [this great idea](https://github.com/nichtich/ditaa-markdown).

the yUML-CLI wrapper by: <https://github.com/wandernauta/yuml>.
