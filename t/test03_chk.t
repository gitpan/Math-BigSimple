use strict;
use Test;
BEGIN { plan tests => 1 }
use Math::BigSimple qw(is_simple);

my $loc = 0;
for(my $i = 3; $i <= 17; $i ++)
{
	$loc ++ if(is_simple($i) == 1);
}

if($loc == 6)
{
	ok(1);
}
else
{
	ok(0);
}
