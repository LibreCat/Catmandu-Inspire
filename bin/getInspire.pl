#!/usr/bin perl

use lib qw(../lib);
use Catmandu::Importer::Inspire;
use Data::Dumper;
#my %attr = ( id => '1198915');

while (<>) {
	chomp;
	my $imp = Catmandu::Importer::Inspire->new({id => $_});
	$imp->each( sub {
		print Dumper $_[0];
	});
}
