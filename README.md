MyUtil
======

## VCV Parser
* The variant call format (VCF) is a generic format for storing DNA polymorphism data such as SNPs, insertions, deletions and structural variants, together with rich annotations.
* [Variant Call Format v.4.1.](http://www.1000genomes.org/wiki/Analysis/Variant%20Call%20Format/vcf-variant-call-format-version-41)

### Usage:
```perl
#!/usr/bin/env perl
use warnings;
use strict;
use MyUtil::IO::VCF;

my $v = MyUtil::IO::VCF->new(data=>'./test.vcf');
for my $entory ($v->get_all_vcf()) {
    print $v->depth($entory);
    print $v->chromosome($entory);
    print $v->extract_DP4($entory);
 }

```

## BAM Parser
* BAM is the compressed binary version of the Sequence Alignment/Map (SAM) format, a compact and index-able representation of nucleotide sequence alignments by using Next-generation sequencing.
