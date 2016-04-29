use Test::More tests => 5;
use strict;
use warnings;
use Test::Exception;

use_ok('wsTemplate::HelperFactory');
use wsTemplate::HelperFactory;
my $helperFactory = wsTemplate::HelperFactory->new();

lives_ok {$helperFactory->instance({helperClassName=>'tpl'}) } 'Lives to see and instance of wsTemplate::Helper::TPL';
lives_ok {$helperFactory->instance({helperClassName=>'tt'}) } 'Lives to see and instance of wsTemplate::Helper::TT';
lives_and { is ref $helperFactory->instance({helperClassName=>'tpl'}), 'wsTemplate::Helper::TPL' } 'Instances wsTemplate::Helper::TPL';
lives_and { is ref $helperFactory->instance({helperClassName=>'tt'}), 'wsTemplate::Helper::TT' } 'Instances wsTemplate::Helper::TT';
