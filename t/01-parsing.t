use v6;
use Test;

use Config::INI;

my $first = Q {
foo=bar
some=thing
};

ok Config::INI::parse($first), 'first config parsed';

my $second = Q {
	foo = bar
 some=  thing
};

ok Config::INI::parse($second), 'second config parsed';

my $third = Q {
	foo = bar ; comment
	another= thing;commie
};

ok Config::INI::parse($third), 'third config parsed';

my $forth = Q {
	foo = bar
[core]
inur=section
messing=with
ur=keyvals

[more]
optimized=fun
dragon=storm

};

ok Config::INI::parse($forth), 'forth config parsed';

my $fifth = Q {
	emptykey = 
	another = withvalue

	[section with space]
	whynot=;comment
	why yes=because
};

ok Config::INI::parse($fifth), 'fifth config parsed';

my $sixth = Q {
root=something

[section]
one=two
Foo=Bar
this=Your Mother!
blank=

[section]
moo=kooh

[Section Two]
something else=blah
 remove = whitespace
};

ok Config::INI::parse($sixth), 'sixth config parsed';
