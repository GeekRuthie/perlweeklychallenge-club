#!/usr/bin/perl

use strict;
use warnings;

my $N = $ARGV[0] || 1234;

do { $N++ }
until ($N == reverse split //,$N);
print "$N\n";
