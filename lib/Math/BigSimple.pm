package Math::BigSimple;
$VERSION = "1.0";
require Exporter;
use Math::BigInt;
@ISA = qw(Exporter);
@EXPORT = qw(new);
$VERSION = 0.01;
sub new
{
	my($class, %param) = @_;
	my $CHECKS = $param{'Checks'};
	$CHECKS = 4 if(!$CHECKS);
	my $LENGTH = $param{'Length'};
	die "Length not defined or incorrect" if($LENGTH + 1 == 1);
	my $RAND = $param{'Random'};
	$RAND = sub{rand} if((ref($RAND) ne "CODE") || (!$RAND));
	my $ref = [$CHECKS, $LENGTH, $RAND];
	bless $ref, $class;
	return $ref;
}
sub make
{
	my $ref = shift;
	my($CHECKS, $LENGTH, $RAND) = @$ref;
	my $_2 = Math::BigInt -> new(2);
	my $p;
	while($p = int(&$RAND() * (10 ** $LENGTH)))
	{
		next if(!$p);
		my $coof = $p << 4;
		my $simple = 1;
		my $_p = Math::BigInt -> new($p);
		my $_i1 = Math::BigInt -> new($p - 1);
		my $_i2 = $_i1 -> bdiv($_2);
		my $count;
		for($count = 0; $count < $CHECKS; $count ++)
		{
			$simple = 0;
			last if($p % 2 == 0);
			my $x = Math::BigInt -> new(int(&$RAND() * $coof) % $p);
			next if($x -> is_zero()); 
			
			my $func = $x -> bmodpow($_i1, $_p);
			$func = $func -> bstr();
			last if(($func != 1)&&($func != $p - 1));
		
			$func = $x -> bmodpow($_i2, $_p);
			$func = $func -> bstr();
			last if(($func != 1)&&($func != $p - 1));	
			
			$simple = 1;
		}
		if($simple == 1)
		{
			return $p;
		}
	}
	return -1;
}
__END__

=head1 NAME

Math::BigSimple

=head1 VERSION

Version number is 1.0(this is the first BigSimple version).
It isn't enough tested by other people but my own tests showed such a good stability...

It was written 11.11.2004.

=head1 DESCRIPTION

The Math::BigSimple module can generate big simple numbers; it's very usefull for cryptographic programs which follow the
open key principles(like RSA, IDEA, PGP and others). It's interface is VERY easy to use and it works enough fast even for the real-time applications.

=head1 SYNTAX

 use BigSimple;
 $bs = BigSimple -> new(
 	Length => 8,
 	Checks => 5
 );
 print $bs -> make();

=head1 FUNCTIONS

=head2 new(%params)

This function constructs the simple numbers generator with special parameters. The easiest form of usage is

 $bs = new BigSimple(Length => $length);

when maximum key length is set to $length and every number should be tested 4 times. You also may change it using the 'Checks' parameter, like in the example below:

 $bs = new BigSimple(
 	Length => $length,
 	Checks => 2 
 );

That should work faster twice.

And the last optional parameter, 'Random', when it's value is a reference to function which returns a random number, could change internal scheme of receiving numbers for tests.

=head2 make

Return a big simple number.

=head1 KNOWN BUGS

The main and the only 'feauture' that is good to be fixed is that this module can't garrantee that the length of the generated number is exactly required length: it may be shorter. But for the most of the tasks it isn't a problem...

And the process of generating numbers longer then 15 decimal symbols lasts MUCH longer with each next char.

=head1 AUTHOR

Here is a pure information about the author of this module:

 Edward Chernenko <specpc@yandex.ru> - the professional PERL programmer.
 Lives in the Russian Federation, Obninsk city.
 Birthday date: 19.08.1989.

For more info you may visit http://www.aportal.org/ website(warning:
remember that this is available for russian-speaking persons only ;-) - and it's absolutely clear why).

=head1 COPYRIGHT

Copyright (C)Edward Chernenko.
This program may be used with the same license as the perl Artistic.
All right reserved.

 !!!: This algorithm was taken from the Hasanov's family
 !!!: website(www.hasanov.ru).

=head1 LOOK ALSO

Crypt::RSA - the open key cryptographic module.

There is(IMPORTANT FOR RUSSIAN_SPEAKING PERSONS!!) a russian
documentation on my offical website.
