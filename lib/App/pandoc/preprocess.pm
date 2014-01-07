package App::pandoc::preprocess;

#  PODNAME: App::pandoc::preprocess
# ABSTRACT: Preprocess Pandoc before Processing Pandoc

use v5.14;
use strict;
use warnings;

use Moo;
use MooX::Options;
use MooX::Types::MooseLike::Base qw| :all |;

use Data::Printer;

use App::pandoc::preprocess::File;
use App::pandoc::preprocess::Checks;

option inputfiles => (
  is => 'ro',
  isa => ArrayRef[Str],
  # repeatable => 1,
  required => 1,
  format => 's@',
);

option output_directory => (
  is => 'rw',
  isa => Str,
  format => 's',
  default => sub { '.' },
  doc => 'directory to write image files to',
);

option downscale_image => (
  is => 'rw',
  isa => Bool,
  default => 1,
  doc => 'downscale the image',
);

has encoding_check => (
  is => 'ro',
  isa => Num,
  default => sub {
    `grep -c file.encoding \$(which ditaa)` > 0 or die q{
      Your ditaa executable
        a) could not be found in your $PATH or
        b) it lacks an option called '-Dfile.encoding=UTF-8' or
        c) your\'re lacking java altogehter

      Please add an executable called `ditaa` with the following content to your $PATH:
        #!/bin/sh
        java -Dfile.encoding=UTF-8 -jar /path/to/ditaa_XYZ.jar

      Abort.
    }
  }
);

has preprocess_file => (
  is => 'rw',
  isa => Object #'App::pandoc::preprocess::File',
);

has matchers => (
  is => 'ro',
  isa => HashRef[RegexpRef],
  default => sub {
    +{
      begin_of_line          => qr/^/sm,
      codeblock_begin        => qr/~{4,}/sm,
      codeblock_content      => qr/.*?/sm,
      codeblock_end          => qr/~{4,}/sm,
      format_specification   => qr/(?:dot|ditaa|rdfdot)/sm,
      random_stuff_nongreedy => qr/.*?/sm,
      possibly_spaces        => qr/\s*/sm,
    }
  }
);

has matcher => (
  is => 'lazy',
  isa => RegexpRef,
);

sub _build_matcher {
  my $self = shift;
  # This is a bit ugly, since we have to
  # use the @{[]}-"tutle operator" everywhere...
  my $qr =  qr/
    (?<MATCH>
      @{[$self->matchers->{codeblock_begin}]} @{[$self->matchers->{possibly_spaces}]} \{
        @{[$self->matchers->{random_stuff_nongreedy}]}
        \.(?<format> @{[$self->matchers->{format_specification}]} )
        @{[$self->matchers->{random_stuff_nongreedy}]}
      \}
      @{[$self->matchers->{random_stuff_nongreedy}]}
      (?<content> @{[$self->matchers->{codeblock_content}]} )
      @{[$self->matchers->{codeblock_end}]}
    )
  /x;
}

sub slurp_file {
  my $self = shift;
  return $_ = do { local (@ARGV, $/) = @{$self->inputfiles}; <> };
}

sub generator { # needs to return the include line for pandoc
  my $self = shift;
  my ($format, $content) = @_;
  my $file = App::pandoc::preprocess::File->new(
    current_format => $format,
    content => $content,
    output_directory => $self->output_directory,
    downscale_image => 1,
  );
  $file->current_image_include;
}

sub run {
  my $self = shift;
  $_ = $self->slurp_file;           # get (whole) STDIN/File(s) into $_
  my $matcher = $self->matcher;     # $matcher will set $+{format} and $+{content}
  s/$matcher/$self->generator( $+{format} => $+{content} )/posixgems; # transmute $_ and (as a side-effect) write image files
  say $_                            # you will have to output modified $_ to STDOUT again
}

1;