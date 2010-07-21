use v6;

module Config::INI;

grammar INIfile {
	token TOP       { ^ <toplevel> \n* $ } # no sections yet
	token toplevel  { <dummyline>* <keyval> ** [ <dummyline> | \n ]+ }
	token keyval    { \s* <key> \s* '=' \s* <value> <comment>? }
	token key       { [ <![;]> \w ]+ }
	token value     { [ <![;]> \N ]+ }
	token comment   { ';' \N* }
	token dummyline { \s* <comment>? \n }
}

our sub parse_file (Str $file) {
	my $conf = slurp $file;
	my $parseconf = 0;
	my %result;
	try {
		%result = parse $conf;
		CATCH {
			$parseconf = 1
		}
	}
	if $parseconf {
		die "Failed parsing $file"
	}
	return %result
}

our sub parse (Str $conf) {
	my %result;
	my $match = INIfile.parse($conf);
	unless $match {
		die "Failed parsing the given string"
	}
	for $match<toplevel><keyval> -> $param {
		%result{$param<key>.Str} = $param<value>.Str
	}
	return %result
}
