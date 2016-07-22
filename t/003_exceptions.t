use Test::More tests => 5;
use strict;
use warnings;
use Test::Exception;

use_ok('SingleCode::Exception');

can_ok('SingleCode::Exception::Error', 'throw');
can_ok('SingleCode::Exception::FlightRangeDatesInvalid', 'throw');
can_ok('SingleCode::Exception::FlightDateInvalid','throw');
can_ok('SingleCode::Exception::FlightDesignatorInvalid','throw');

1;
