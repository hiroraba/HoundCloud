package HoundCloud::Util::Logic;
use Mojo::Base 'Mojolicious::Controller';

use URI;
use Mozilla::CA;
use LWP::UserAgent;
use HTTP::Request;
use JSON;

use constant CORE_URL_SC => "https://api.soundcloud.com/tracks.json";
use constant CLIENT_ID_SC => $ENV{'CLIENT_ID_SC'};

use constant CORE_URL_LF => "http://ws.audioscrobbler.com/2.0/";
use constant CLIENT_ID_LF => $ENV{'CLIENT_ID_LF'};

sub getTracks {
  my $artist = shift;

  my $uri_sc = URI->new(CORE_URL_SC);
  my $uri_lf = URI->new(CORE_URL_LF);

  $uri_lf->query_form(api_key => CLIENT_ID_LF,
    artist => $artist,
    format => "json",
    method => "artist.getsimilar",
    limit => 3
  );
  my $similarArtists = &_getSimilar(&_requestApi($uri_lf));

  my $artist = splice @{$similarArtists}, int rand @{$similarArtists} , 1;
  $uri_sc->query_form(client_id => CLIENT_ID_SC, q => $artist );
  my $track_url = &_getTrack(&_requestApi($uri_sc));
  return $track_url;
}

sub _requestApi {
  my ($uri) = shift;

  my $req = HTTP::Request->new(GET => $uri);
  my $ua = LWP::UserAgent->new();
  my $res = $ua->request($req);
  return $res->content;
}

sub _getTrack {
  my ($res) = shift;
  my $track_data = decode_json($res);
  my $tracks = ();
  foreach my $track (@{$track_data}) {
    push(@{$tracks}, $track->{uri});
  }
  return $tracks;
}

sub _getSimilar {
  my ($res) = shift;
  my $similar_data = decode_json($res);
  my $similar_artists = ();
  foreach my $similar (@{$similar_data->{similarartists}->{artist}}) {
    my $artist = $similar->{name};
    push(@{$similar_artists}, $artist);
  }
  return $similar_artists;
}
1;
