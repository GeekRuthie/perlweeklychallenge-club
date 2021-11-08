#!/usr/bin/perl
use warnings;
use strict;

use enum qw( WIDTH HEIGHT AREA );

sub max_submatrix {
    my ($matrix) = @_;
    my @preceding_zeros;
    my @max = (0, 0, 0);
    for my $x (0 .. $#$matrix) {
        my $length = 0;
        for my $y (0 .. $#{ $matrix->[$x] }) {
            if ($matrix->[$x][$y]) {
                $preceding_zeros[$x][$y] = $length = 0;
            } else {
                my $width = $preceding_zeros[$x][$y] = ++$length;
                for my $z (1 .. $x + 1) {
                    my $w = $preceding_zeros[ $x - $z + 1 ][$y];
                    $width = $w if $w < $width;

                    # Optimization: skip if we can't beat the max.
                    last if $width * ($x + 1) <= $max[AREA];

                    @max = ($width, $z, $width * $z)
                        if $width * $z >= $max[AREA];
                }
            }
        }
    }
    return [map [(0) x $max[WIDTH]], 1 .. $max[HEIGHT]]
}

use Test2::V0;
plan 3;

is max_submatrix([[ 1, 0, 0, 0, 1, 0 ],
                  [ 1, 1, 0, 0, 0, 1 ],
                  [ 1, 0, 0, 0, 0, 0 ]]),
    [[0, 0, 0],
     [0, 0, 0]],
    'Example 1';


is max_submatrix([[ 0, 0, 1, 1 ],
                  [ 0, 0, 0, 1 ],
                  [ 0, 0, 1, 0 ]]),
    [[0, 0],
     [0, 0],
     [0, 0]],
    'Example 2';

is max_submatrix([
    [0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1],
    [0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1],
    [0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1],
    [0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
    [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
    [1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0],
    [1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
    [1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0],
    [0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0],
    [1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0]]),
    [[0, 0, 0, 0, 0, 0, 0, 0, 0],
     [0, 0, 0, 0, 0, 0, 0, 0, 0]],
    'Large';
