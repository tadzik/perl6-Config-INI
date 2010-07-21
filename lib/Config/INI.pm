use v6;

module Config::INI;

grammar INIfile {
	token TOP       { ^ 
						<dummyline>* <toplevel>?
						<dummyline>* <sections>*
						<dummyline>*
						$
					}
	token toplevel  { <keyval> ** <dummyline>* }
	token sections  { <sheader> <keyval> ** <dummyline>* }
	token sheader   { '[' (\w+) ']' }
	token keyval    { \s* <key> \s* '=' \s* <value> <dummyline> }
	token key       { [ <![;]> \w ]+ }
	token value     { [ <![;]> \N ]+ }
	token comment   { \s* ';' \N* \n }
	token dummyline { [ <comment> | \n ]+ }
}

our sub parse (Str $conf) {
	my %result;
	my $match = INIfile.parse($conf);
	unless $match {
		die "Failed parsing the given string"
	}
	for $match<toplevel>[0]<keyval> -> $param {
		next unless $param;
		%result{$param<key>.Str} = $param<value>.Str
	}
	for $match<sections> -> $section {
		my $sname = $section<sheader>[0].Str;
		for $section<keyval> -> $param {
			%result{$sname}{$param<key>.Str} = $param<value>.Str;
		}
	}
	return %result
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
