#!/usr/bin/env perl

use strict;
use warnings;

package MyUtil::IO::VCF;

sub new {
    use Carp;
    
    my $class = shift;
    my $self = { data => undef,
                 @_,
               };
    unless ( defined $self->{data} ) {
        confess('croak: data => in.vcf is required for initializing instance');
    }
    
    open my $fh, '<', $self->{data} or croak('Can not read vcf file');
    while (my $line = <$fh>) {
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
    my $id   = shift;
    
    my $chr = $self->{$id}->{chr};
    return $chr if defined $chr;
}

sub get_depth {
    my $self = shift;
    my $id   = shift;
        
    if ( $self->{$id}->{info} =~ m/(DP=\d+)/g ) {
        ( my $DP = $1 ) =~ s/^DP=//;
        return $DP;
    }
}

sub extract_DP4 {
    my $self = shift;
    my $id   = shift;
    
    if ($self->{$id}->{info} =~ m/(DP4=\d+\,\d+\,\d+\,\d+)/g) {
        (my $DP4 = $1) =~ s/^DP4=//;
        my @DP4 = split /\,/, $DP4;
        return join ",", @DP4;
    }
}

sub extract_PV4 {
    my $self = shift;
    my $id   = shift;
    
    if ($self->{$id}->{info} =~ m/(PV4=.+\,.+\,.+\,.+)/g) {
        ( my $PV4 = $1 ) =~ s/PV4=//g;
        my @PV4 = split /\,/, $PV4;
        return join ",", @PV4;
    }
}

sub calculate_edit_ratio {
    my $self = shift;
    my $id   = shift;
    my @DP4 = split /\,/, extract_DP4($id);
    
    my $ref_count = $DP4[0] + $DP4[1];
    my $alt_count = $DP4[2] + $DP4[3];
    if ($ref_count>0) {
        return;
    }
}


1;
