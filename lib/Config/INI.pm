use v6;

grammar INIfile {
	token TOP       { ^ <toplevel> \n* $ } # no sections yet
	token toplevel  { \n* <keyval> ** [ <dummyline> | \n ]+ }
	token keyval    { \s* <key> \s* '=' \s* <value> <comment>? }
	token key       { [<![;] > \w]+ }
	token value     { [ <![;]> \N ]+ }
	token comment   { ';' \N+ }
	token dummyline { \s* [';' \N*]? \n }
}

class Config::INI {
	has $!parser;
	has %!contents;

	method new (Str $file) {
		self.bless(*, file => $file)
	}

	submethod BUILD (:$file) {
		my $cstr = slurp $file;
		my $!parser = INIfile.parse($cstr);
		unless $!parser {
			die "Failed parsing $file";
		}
		for $!parser<toplevel><keyval> -> $param {
			%!contents<toplevel>{$param<key>.Str} = $param<value>.Str;
		}
	}

	method at_key(Str $section) {
		if $section ne 'toplevel' {
			die "Sorry, not yet implemented :("
		}
		return %!contents{$section};
	}
}
