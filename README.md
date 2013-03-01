MyUtil
======

## Usage:
### example
* 以下のようにして、VCFフォーマットの各カラムの値にアクセスできる。
* コンストラクタの引数はdata=>in.vcfのようにファイルを指定する。

```perl
#!/usr/bin/env perl -w
use strict;

use MyUtil::IO::VCF;

my $v = MyUtil::IO::VCF->new(data=>'./test.vcf');
for my $entory ($v->get_all_vcf()) {
    print $v->get_depth($entory);
    print $v->extract_DP4($entory);

```

