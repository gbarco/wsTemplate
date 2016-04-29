use Test::More tests => 4;
use strict;
use warnings;
use Test::Exception;

use_ok('wsTemplate::HelperFactory');

lives { wsTemplate::HelperFactory->instance(helperClass=>'tpl') };
lives_and { is ref wsTemplate::HelperFactory->instance(helperClass=>'tpl'), 'wsTemplate::Helper::TPL' };
lives_and { is ref wsTemplate::HelperFactory->instance(helperClass=>'tt'), 'wsTemplate::Helper::TT' };
