use v6;
use Test;

use Config::INI;

ok 1, 'Config::INI loads';

my $test1 = Q {
foo = bar, asd
; comments
	asd= 7
burp =bump ;another comment

};

my %a = Config::INI::parse($test1);

ok 1, 'can parse a string';

is %a<foo>, 'bar, asd', '1st key parsed ok';
is %a<asd>, '7', '2nd key parsed ok';
is %a<burp>, 'bump ', '3rd key parsed ok';

my %b = Config::INI::parse_file('t/test00.ini');

ok 1, 'can parse a file';
is %b<foo>, 'comma, separated, values', '1st key parsed ok';
is %b<ano>, 'ther ', '2nd key parsed ok';
is %b<ki>, 'waliu', '3rd key parsed ok';
is %b<asd>, 'esd', '4th key parsed ok';

done_testing;
