use v6;
use Test;

use Config::INI;

my $a = Config::INI.new('t/test00.ini');

ok $a, 'can parse a file';

is $a<toplevel><foo>, 'comma, separated, values', '1st key parsed ok';
is $a<toplevel><ano>, 'ther ', '2nd key parsed ok';
is $a<toplevel><ki>, 'waliu', '3rd key parsed ok';
is $a<toplevel><asd>, 'esd', '4th key parsed ok';

done_testing;
