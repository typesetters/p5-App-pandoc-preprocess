package App::pandoc::preprocess;

#  PODNAME: pdoc
# ABSTRACT: typeset pandoc documents with document-specific, default options

use v5.14;
use strict;
use warnings;
use Moo;
use Moo;
use MooX::Options;

option 'show_this_file' => (
    is => 'ro',
    format => 's',
    required => 1,
    doc => 'the file to display'
);

sub main {
  state $file = 0;

  sub gen {
    my $cmd = {
      dot   => sub {
        my ($file, $filename) = @_;
        `dot -Tpng -Gsize=1,2\\! -o image-$file.png $filename`;
      },
      ditaa => sub {
        my ($file, $filename) = @_;
        `ditaa $filename image-$file.png`; #--no-shadows --scale 0.4
      },
      rdfdot => sub {
        my ($file, $filename) = @_;
        `rdfdot -ttl $filename image-$file.png`; #--no-shadows --scale 0.4
      },
    };

    my ($format, $content) = @_;
    my $filename = "image-". ++$file .".$format";
    open my $outfile, '>', $filename;
    print {$outfile} $content;
    $cmd->{$format}($file, $filename);
    `mogrify -scale 75% image-$file.png`;
    return "![](image-$file.png)" #\\
  }

  $_ = do { local (@ARGV, $/) = @ARGV; <> };

  my $RE = {
    begin_of_line          => qr/^/sm,
    codeblock_begin        => qr/^~+/sm,
    codeblock_content      => qr/.*?/sm,
    codeblock_end          => qr/^~+/sm,
    format_specification   => qr/(?:dot|ditaa|rdfdot)/sm,
    random_stuff_nongreedy => qr/.*?/sm,
    possibly_spaces        => qr/\s*/sm,
  };


  # This regex matches lines similar to:
  # ~~~~ {.ditaa}
  # <.ditaa content here>
  # ~~~~
  s[
    (?<MATCH>
      $RE->{codeblock_begin} $RE->{possibly_spaces} \{
        $RE->{random_stuff_nongreedy}
        \.(?<format> $RE->{format_specification} )
        $RE->{random_stuff_nongreedy}
      \}
      $RE->{random_stuff_nongreedy}
      $RE->{begin_of_line}(?<content> $RE->{codeblock_content} )
      $RE->{codeblock_end}
    )
  ][
    gen( $+{format} => $+{content} )
  ]gosemix;

  say $_
}

1;