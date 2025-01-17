#!/usr/bin/env raku
use Test;

ok  reduced-row-echelon([1, 0, 0, 1],
                        [0, 1, 0, 2],
                        [0, 0, 1, 3]);

nok reduced-row-echelon([1, 1, 0],
                        [0, 1, 0],
                        [0, 0, 0]);

ok  reduced-row-echelon([0, 1,-2, 0, 1],
                        [0, 0, 0, 1, 3],
                        [0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0]);

ok  reduced-row-echelon([1, 0, 0, 4],
                        [0, 1, 0, 7],
                        [0, 0, 1,-1]);

nok reduced-row-echelon([0, 1,-2, 0, 1],
                        [0, 0, 0, 0, 0],
                        [0, 0, 0, 1, 3],
                        [0, 0, 0, 0, 0]);

nok reduced-row-echelon([0, 1, 0],
                        [1, 0, 0],
                        [0, 0, 0]);

nok reduced-row-echelon([4, 0, 0, 0],
                        [0, 1, 0, 7],
                        [0, 0, 1,-1]);

nok reduced-row-echelon([1, 0, 0, 0],
                        [0, 1, 0, 3],
                        [0, 0, 1,-3],
                        [0, 0, 0, 1],
                        [0, 0, 0, 0]);

nok reduced-row-echelon([1, 0, 0, 0],
                        [0, 1, 0, 1],
                        [0, 0, 1, 0],
                        [0, 0, 0, 1],
                        [0, 0, 0, 0]);

ok  reduced-row-echelon([1, 0, 0, 0, 0],
                        [0, 1, 0, 0, 0],
                        [0, 0, 0, 0, 1],
                        [0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0]);

ok  reduced-row-echelon([0, 0, 0],
                        [0, 0, 0],
                        [0, 0, 0],
                        [0, 0, 0]);

sub reduced-row-echelon(+@m)
{
    # the first non-zero number in a row is the pivot
    my @pivots = @m>>.first(*.so, :kv);

    # the first row that is all zeroes
    my $k = @pivots.first(*.not, :k);

    # rows with all zeroes are grouped at the bottom
    with $k 
    { 
        return False unless all(@pivots[$k..*]) ~~ Any; 
        @pivots = @pivots[^$k];
        return True unless @pivots
    }

    my @cols   = @pivots>>[0];
       @pivots = @pivots>>[1];

    # pivots go from top-left to bottom-right
    return False unless [<] @cols;

    # remove zero rows and non-pivot columns
    @m = @m[^@pivots;@cols].batch(@cols.elems)>>.Array;
    # @m should be an identity matrix at this point if it is RREF

    # all pivots are ones
    return False unless squish(@m.keys.map({ |@m[$_].splice($_,1) })) ~~ (1,); 

    # everything else is zeroes
    return squish(@m[*;*]) ~~ (0,) 
}
