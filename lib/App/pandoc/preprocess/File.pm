package App::pandoc::preprocess::File;

#  PODNAME: App::pandoc::preprocess::File
# ABSTRACT: Internal class representing a file

use v5.14;
use strict;
use warnings;

use Moo;
use MooX::Options;
use MooX::Types::MooseLike::Base qw(:all);
use namespace::clean;
use Path::Class;

use Data::Printer;

state $file_count = 0;

sub BUILDARGS {
  my ( $class, @args ) = @_;

  die "Wrong arguments: $!" if @args % 2 == 1;

  return {
    file_count => ++$file_count,
    @args
  };
};

# supported output formats:
# dot: ps svg svgz fig mif hpgl pcl png gif dia imap cmapx
# ditaa: png only?
# rdfdot: --same as dot?-- compare: `rdfdot -output`
sub BUILD {
    my $self = shift;
    my $dir = dir($self->output_directory);
    $dir->mkpath unless -e $dir;
    $self->current_file();
    $self->build_image_file();
    $self->do_downscale_image() if $self->downscale_image();
}

has file_count => (is => 'ro', isa => Int); # default => state $file
has current_image => (is => 'lazy', isa => Str); # e.g. image-x.ditaa
has current_file => (is => 'lazy', isa => Str); # .e.g. is where ditaa/dot is printed to
has output_filename => (is => 'lazy', isa => Str ); # e.g. image-x.png
has downscale_image => (is => 'rw', isa => Bool, default => 0);
has current_format => (is => 'rw', isa => Str);
has content => (is => 'rw', isa => Str);
has output_directory => (
  is => 'rw',
  isa => Str,
  default => '.',
);
has image_generator => (
  is => 'rw',
  isa => HashRef[CodeRef],
  default => sub { +{
      dot   => sub {
        my $self = shift;
        my $cmd = "dot -Tpng -Gsize=1,2\\! -o @{[$self->output_filename]} @{[$self->current_image]}";
        qx/$cmd/;
      },
      ditaa => sub {
        my $self = shift;
        my $cmd = "ditaa -e UTF-8 @{[$self->current_image]} @{[$self->output_filename]}"; #`; #--no-shadows --scale 0.4
        qx/$cmd/;
      },
      rdfdot => sub {
        my $self = shift;
        my $cmd = "rdfdot -ttl @{[$self->current_image]} @{[$self->output_filename]}"; #--no-shadows --scale 0.4
        qx/$cmd/;
      }
    }
  }
);

sub _build_current_image {
  my $self = shift;
  file($self->output_directory, "image-".$self->file_count.".".$self->current_format)->stringify
}

sub _build_output_filename {
  my $self = shift;
  file($self->output_directory, "image-".$self->file_count."."."png")->stringify
}

sub _build_current_file {
  my $self = shift;
  open my $outfile, '>', $self->current_image or die $!;
  print {$outfile} $self->content;
}

sub build_image_file {
  my $self = shift;
  $self->image_generator->{$self->current_format}->($self); # Hack: we need to pass in $self here
}

sub current_image_include {
  my $self = shift;
  return "![](@{[$self->output_filename]})" #\\
}

sub do_downscale_image {
  my $self = shift;
  `mogrify -scale 75% @{[$self->output_filename]}`;
}

1;