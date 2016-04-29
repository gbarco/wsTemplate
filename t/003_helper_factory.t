use Test::More tests => 5;
use strict;
use warnings;
use Test::Exception;

use_ok('wsTemplate::HelperFactory');

lives_ok { wsTemplate::HelperFactory->instance(helperClass=>'tpl') };
lives_ok { wsTemplate::HelperFactory->instance(helperClass=>'tt') };
lives_and { is ref wsTemplate::HelperFactory->instance(helperClass=>'tpl'), 'wsTemplate::Helper::TPL' };
lives_and { is ref wsTemplate::HelperFactory->instance(helperClass=>'tt'), 'wsTemplate::Helper::TT' };
