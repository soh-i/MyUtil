#!/usr/bin/env perl

package MyUtil::IO::BAM;

use strict;
use warnings;
use Carp;

sub new {
    my $class = shift;
    my $self = {};
    return bless $self, $class;
}

1;
