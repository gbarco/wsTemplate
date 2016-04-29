use Test::More tests => 7;
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

route_exists [POST => '/ws/tt'], 'a route handler is defined for /ws/tt';
route_exists [POST => '/ws/tpl'], 'a route handler is defined for /ws/tpl';
