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

=begin pod

=head1 NAME
Config::INI - parse standard configuration files (.ini files)

=head1 SYNOPSIS
	use Config::INI;
	my %hash = Config::INI::parse_file('config.ini');
	#or
	%hash = Config::INI::parse($file_contents);
	say %hash<root_property_key>;
	say %hash<section><in_section_key>;

=head1 DESCRIPTION

This module provides 2 functions: parse() and parse_file(), both taking
one C<Str> argument, where parse_file is just parse(slurp $file).
Both return a hash which keys are either toplevel keys or a section
names. For example, the following config file:

	foo=bar
	[section]
	another=thing

would result in the following hash:

	{ foo => "bar", section => { another => "thing" } }

=head1 CAVEATS

Parser will fail if a file contains either empty sections, or keys
without specified value (as in 'foo='). Whether this is a bug
or a feature, time will tell.

=end pod
