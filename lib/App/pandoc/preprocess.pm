package App::pandoc::preprocess;

#  PODNAME: App::pandoc::preprocess
# ABSTRACT: Preprocess Pandoc before Processing Pandoc

=begin wikidoc

= ppp - pandoc pre-process

= USAGE

    cat chapters/input-*.pandoc | ppp | pandoc -o output.pdf --smart [more pandoc options...]

Additionally see `etc/input.txt` for concrete examples.

= PREREQUISITES

* dot/neato (neato is new!)
* rdfdot
* ditaa
* Image::Magick (for downscaling of large images)

= BACKGROUND

* much simpler design than version 1: pipeable & chainable, reading line-by-line
* parallelized work on image file creation

== How it works

1. while-loop will iterate line by line and is using the flip-flop-operator:
    * as soon, as a ditaa/rdfdot/dot-block starts,
      globals ($fileno, $outfile, etc) are set, so all other routines can see them
    * when actually *inside* the block, the block's contents are printed
      to the newly generated file (image-X.(ditaa/rdfdot/dot))
2. once the flip-flop-operator hits the end of the ditaa/rdfdot/dot-block,
a child will be spawned to take over the actual ditaa/rdfdot/dot-process
to create the png-file and the globals are reset

3. all other lines which are not part of a ditaa/rdfdot/dot-block will simply
be piped through to stdout

4. at the end of the program, all children are waited for

5. in the meantime, the new pandoc contents are printed to stdout

6. all child-processes will remain quiert as far as stdout is concerned and
write to their individual log-files

== Todo

* Captions
* Checks whether ditaa... are available
* check whether ditaa has file.encoding set
* bundle ditaa with this

=end wikidoc

'make CPAN happy -- we only have a main in bin/ppp'