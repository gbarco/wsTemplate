use Test::More tests => 5;
use strict;
use warnings;
use Test::Exception;

use_ok('wsTemplate::Exception');

can_ok('wsTemplate::Exception::Error', 'throw');
can_ok('wsTemplate::Exception::FailedToInstanceHelperClass', 'throw');
can_ok('wsTemplate::Exception::MuggleHelper','throw');
can_ok('wsTemplate::Exception::BadJSON','throw');

1;
