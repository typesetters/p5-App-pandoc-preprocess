# ppp

`ppp` let's you use ditaa, dot, rdfdot and neato directly in your pandoc sources and will transform these into beautiful graphs.

## Usage

    cat chapters/input-*.pandoc | ppp | pandoc -o output.pdf --smart [more pandoc options...]

The good thing here: if you leave `ppp` out of the pipe-chain, your documents are still typeset nicely -- except you have UML in code blocks.

See `etc/input.pandoc` for concrete usage examples.

## Prerequisites

* dot/neato (neato is new!)
* rdfdot
* ditaa
* Image::Magick (for downscaling of large images)

## License
WTFPL

## Thanks
This package was inspired by [this great idea](https://github.com/nichtich/ditaa-markdown).

