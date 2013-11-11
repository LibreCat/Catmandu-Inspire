#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Exception;
use Catmandu::Fix qw(inspire);
use Catmandu::Importer::Inspire;

my $fixer = Catmandu::Fix->new(fixes => ['inspire()']);

my $importer = Catmandu::Importer::Inspire->new(
	format => 'marc', 
	doi => '10.1088/1126-6708/2009/03/112',
	);

my $importer2 = Catmandu::Importer::Inspire->new(
	format => 'marc', 
	id => '811388',
	);

my $f = $fixer->fix($importer);
my $f2 = $fixer->fix($importer2);

my $data = {
    'url' => 'http://inspirehep.net/record/811388',
    'id' => '811388',
    'arxiv' => {
        'url' => 'http://arxiv.org/abs/0901.3094',
        'id' => '0901.3094'
        },
    'doi' => '10.1088/1126-6708/2009/03/112',
	};

is_deeply $f->first, $data, "compare records";
is_deeply $f2->first, $data, "compare records";

done_testing 2;