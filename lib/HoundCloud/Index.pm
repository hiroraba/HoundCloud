package HoundCloud::Index;
use Mojo::Base 'Mojolicious::Controller';

use HoundCloud::Util::Logic;

sub welcome {
  my $self = shift;

  $self->render();
}

sub get {
  my $self = shift;
  my $track_url = HoundCloud::Util::Logic::getTracks($self->param('artist'));
  $self->render(tracks => $track_url, artist => $self->param('artist'));
}

1;
