use Test::More tests => 6;
use strict;
use warnings;

use wsTemplate;

# order is important for Dancer::Test and life as social beings
use Dancer::Test;

route_exists [GET => '/'], 'a route handler is defined for /';
response_status_is ['GET' => '/'], 200, 'response status is 200 for /';

route_exists [GET => '/version'], 'a route handler is defined for /version';
response_status_is ['GET' => '/version'], 200, 'response status is 200 for /version';
response_content_is_deeply [GET => '/version'], '{"version":"0.1"}', "got json version from /version";

route_exists [POST => '/ws'], 'a route handler is defined for /ws';
