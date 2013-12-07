package HoundCloud;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  my $r = $self->routes;

  $r->get('/')->to('index#welcome');
  $r->get('/get')->to('index#get');
}

1;
