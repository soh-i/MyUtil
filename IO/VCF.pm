#!/usr/bin/env perl

use strict;
use warnings;
use Carp;

package MyUtil::IO::VCF;

sub new {
    my $class = shift;
    my $self = { data => shift,
               };
    
    open my $fh, '<', $self->{data} or die 'Can not read vcf';
    while (my $line=<$fh>) {
        next if !$line;
        next if $line =~ m/^#{2}|^#{1}/;
        my @t = split /\t/, $line;
        next if $t[4] =~ m/[ATGC]?\,.+/g;
                
        my $chr    = $t[0];
        my $pos    = $t[1];
        my $id     = $t[2];
        my $ref    = $t[3];
        my $alt    = $t[4];
        my $qual   = $t[5];
        my $filter = $t[6];
        my $info   = $t[7];
        my $add    = $t[9];
        
        my $primary = "$chr:$pos";
        $self->{$primary}->{chr}    = $chr;
        $self->{$primary}->{pos}    = $pos;
        $self->{$primary}->{id}     = $id;
        $self->{$primary}->{ref}    = $ref;
        $self->{$primary}->{alt}    = $alt;
        $self->{$primary}->{qual}   = $qual;
        $self->{$primary}->{filter} = $filter;
        $self->{$primary}->{info}   = $info;
        $self->{$primary}->{add}    = $info;
    }
    return bless $self, $class;
}

sub get_all_vcf {
    my $self = shift;
    return keys %$self;
}

sub get_chr {
    my $self = shift;
    my $id = shift;
    
    my $chr = $self->{$id}->{chr};
    return $chr if defined $chr;
}

sub get_depth {
    my $self = shift;
    my $id = shift;
        
    if ( $self->{$id}->{info} =~ m/(DP=\d+)/g ) {
        ( my $DP = $1 ) =~ s/^DP=//;
        return $DP;
    }
}

sub get_DP4 {
    my $self = shift;
    my $id = shift;
    
    if ( $self->{$id}->{info} =~ m/(DP4=\d+\,\d+\,\d+\,\d+)/g ) {
        ( my $DP4 = $1 ) =~ s/^DP4=//;
        my @DP4 = split /\,/, $DP4;
        wantarray ? return @DP4 : return join ",", @DP4;
    }
}

=pod
        my $ref_count = $DP4[0] + $DP4[1];
        my $alt_count = $DP4[2] + $DP4[3];
        my $edit_ratio = $alt_count / ( $alt_count + $ref_count );
        
        $data->{$primary}->{DP4}->{f_ref}      = $DP4[0];
        $data->{$primary}->{DP4}->{r_ref}      = $DP4[1];
        $data->{$primary}->{DP4}->{f_alt}      = $DP4[2];
        $data->{$primary}->{DP4}->{r_alt}      = $DP4[3];
        $data->{$primary}->{DP4}->{edit_ratio} = $edit_ratio;
    }
}

=cut

sub get_PV4 {
    my $self = shift;
    my $id = shift;
    
    if ( $self->{$id}->{info} =~ m/(PV4=.+\,.+\,.+\,.+)/g ) {
        ( my $PV4 = $1 ) =~ s/PV4=//g;
        my @PV4 = split /\,/, $PV4;
        wantarray ? return @PV4 :  return join ",", @PV4;
    }
}

1;
