package Catmandu::Importer::Inspire;

use Catmandu::Sane;
use Moo;
use Furl;
use XML::Simple qw(XMLin);

with 'Catmandu::Importer';


# INFO:
# http://inspirehep.net/
# at the moment no api available


# Constants. -------------------------------------------------------------------

use constant BASE_URL => 'http://inspirehep.net/';


# Properties. ------------------------------------------------------------------

# required.
has base => (is => 'ro', default => sub { return BASE_URL; });
#has query => (is => 'ro', required => 1);

# optional.
has id => (is => 'ro');

# internal stuff.
#has _currentRecordSet => (is => 'ro');
#has _n => (is => 'ro', default => sub { 0 });
#has _start => (is => 'ro', default => sub { 0 });
#has _max_results => (is => 'ro', default => sub { 10 });


# Internal Methods. ------------------------------------------------------------

# Internal: HTTP GET something.
#
# $url - the url.
#
# Returns the raw response object.
sub _request {
  my ($self, $url) = @_;

  my $furl = Furl->new(
    agent => 'Mozilla/5.0',
    timeout => 10
  );

  my $res = $furl->get($url);
  die $res->status_line unless $res->is_success;

  return $res;
}

# Internal: Converts XML to a perl hash.
#
# $in - the raw XML input.
#
# Returns a hash representation of the given XML.
sub _hashify {
  my ($self, $in) = @_;

  my $xs = XML::Simple->new();
  my $out = $xs->XMLin(
	  $in, 
  );

  return $out;
}

# Internal: Makes a call to the Inspire record
#
# Returns the XML response body.
sub _call {
  my ($self) = @_;

  # construct the url
  my $url = $self->base;
  $url .= 'record/'.$self->id . '/export/xe' if $self->id;

  # http get the url.
  my $res = $self->_request($url);

  # return the response body.
  return $res->{content};
}

# Internal: gets the next set of results.
#
# Returns a array representation of the resultset.
sub _get_record {
  my ($self) = @_;
  
  # fetch the xml response and hashify it.
  my $xml = $self->_call;
  my $hash = $self->_hashify($xml);

  # get to the point.
 # my $set = $hash->{entry};

  # return a reference to a array.
  return $hash;
}

# Public Methods. --------------------------------------------------------------

sub generator {
  my ($self) = @_;
  my $return = 1;

  return sub {
	# hack to make iterator stop.
	if ($return) {
		$return = 0;
		return $self->_get_record;
	}
	return undef;
  };
}


# PerlDoc. ---------------------------------------------------------------------

=head1 NAME

  Catmandu::Importer::Inspire - Package that imports Inspire data.

=head1 SYNOPSIS

  use Catmandu::Importer::Inspire;

  my %attrs = (
    query => 'all:electron'
  );

  my $importer = Catmandu::Importer::Inspire->new(%attrs);

  my $n = $importer->each(sub {
    my $hashref = $_[0];
    # ...
  });

=cut

=head1 SEE ALSO

L<Catmandu::Iterable>

=cut

1;
