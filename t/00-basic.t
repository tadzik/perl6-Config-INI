use v6;
use Test;

use Config::INI;

ok 1, 'Config::INI loads';

my $easiest = Q {

foo=bar, asd
	asd= 7
burp =bump

};

my %a = Config::INI::parse($easiest);

ok 1, 'easiest test parsed';

is %a<foo>, 'bar, asd', '1st key parsed ok';
is %a<asd>, '7', '2nd key parsed ok';
is %a<burp>, 'bump', '3rd key parsed ok';

my $comments = Q {
; one comment here
foo=bar ;another one here

ey = bee
};

my %c = Config::INI::parse($comments);

ok 1, 'comments test parsed';
is %c<foo>, 'bar ', '1st key ok';
is %c<ey>, 'bee', '2nd key ok';

my %b = Config::INI::parse_file('t/test00.ini');

ok 1, 'can parse a file';
is %b<foo>, 'comma, separated, values', '1st key parsed ok';
is %b<ano>, 'ther ', '2nd key parsed ok';
is %b<ki>, 'waliu', '3rd key parsed ok';
is %b<asd>, 'esd', '4th key parsed ok';

done_testing;
