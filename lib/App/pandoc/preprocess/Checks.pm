package App::pandoc::preprocess;

#  PODNAME: App::pandoc::preprocess::Checks
# ABSTRACT: Checks your environment

use v5.14;
use strict;
use warnings;

use Moo;
use MooX::Types::MooseLike::Base qw| :all |;

has installed_ditaa   => (is => 'ro', isa => Defined, required => 1, default => sub { `which ditaa`   or die q<Can't find program ditaa -- Abort>  });
has installed_rdfdot  => (is => 'ro', isa => Defined, required => 1, default => sub { `which rdfdot`  or die q<Can't find program rdfdot -- Abort> });
has installed_dot     => (is => 'ro', isa => Defined, required => 1, default => sub { `which dot`     or die q<Can't find program dot -- Abort>    });
has installed_mogrify => (is => 'ro', isa => Defined, required => 1, default => sub { `which mogrify` or die q<Can't find program mogrify -- Abort>});

1;