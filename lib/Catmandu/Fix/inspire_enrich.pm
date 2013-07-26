package Catmandu::Fix::inspire_enrich;

use Catmandu::Sane;
use Catmandu::Importer::Inspire;

sub fix {
  my ( $self, $pub ) = @_;
  my $inspire = Catmandu::Importer::Inspire->new( doi => $pub->{doi} )->first;
  my $val;

  if ( $inspire && $inspire->{record} ) {
    foreach ( @{ $inspire->{record}->{controlfield} } ) {
      if ( $_->{tag} eq "001" and $_->{content} ) {
        $val->{id}  = $_->{content};
        $val->{url} = "http://inspirehep.net/record/" . $_->{content};
      }
    }


    foreach my $datafield ( @{ $inspire->{record}->{datafield} } ) {
      next unless $datafield->{tag} eq "035";
      if ( ref $datafield->{subfield} eq "ARRAY" ) {
        my $temphash;
        foreach my $sf ( @{ $datafield->{subfield} } ) {
          if ( $sf->{code} eq '9' ) {
            $temphash->{type} = $sf->{content};
          }
          elsif ( $sf->{code} eq 'z' or $sf->{code} eq 'a' ) {
            $temphash->{value} = $sf->{content};
          }
        }

        if ( $temphash->{type}
          && $temphash->{type} eq "arXiv"
          && $temphash->{value} )
        {
          $temphash->{value} =~ s/oai\:arXiv.org\:(.*)/$1/g;
          $val->{arxiv}->{id} = $temphash->{value} if $temphash->{value};
          $val->{arxiv}->{url} = "http://arxiv.org/abs/" . $temphash->{value}
            if $temphash->{value};
        }
        elsif ( $temphash->{type} and $temphash->{type} eq "CDS" ) {
          $val->{cern}->{id} = $temphash->{value} if $temphash->{value};
          $val->{cern}->{url} =
            "http://cds.cern.ch/record/" . $temphash->{value}
            if $temphash->{value};
        }
      }
      else {
        my $temphash;
        if ( $datafield->{subfield}->{code} eq '9' ) {
          $temphash->{type} = $datafield->{subfield}->{content};
        }
        elsif ( $datafield->{subfield}->{code} eq 'z'
          or $datafield->{subfield}->{code} eq 'a' )
        {
          $temphash->{value} = $datafield->{subfield}->{content};
        }

        if (  $temphash->{type}
          and $temphash->{type} eq "arXiv"
          and $temphash->{value} )
        {
          $temphash->{value} =~ s/oai\:arXiv.org\:(.*)/$1/g;
          $val->{arxiv}->{id} = $temphash->{value} if $temphash->{value};
          $val->{arxiv}->{url} = "http://arxiv.org/abs/" . $temphash->{value}
            if $temphash->{value};
        }
        elsif ( $temphash->{type} and $temphash->{type} eq "CDS" ) {
          $val->{cern}->{id} = $temphash->{value} if $temphash->{value};
          $val->{cern}->{url} =
            "http://cds.cern.ch/record/" . $temphash->{value}
            if $temphash->{value};
        }
      }
    }
  }

  my $pub = { inspire => $val };
}
