use Test::More tests => 7;
use strict;
use warnings;
use Test::Exception;

my @knownHelpers = qw/TT TPL/;

use_ok('wsTemplate::HelperFactory');
use wsTemplate::HelperFactory;
my $helperFactory = wsTemplate::HelperFactory->new();

lives_ok {$helperFactory->instance({helperClassName=>$_}) } 'Lives to see and instance of wsTemplate::Helper::' . uc($_) for (@knownHelpers);
lives_and { is ref $helperFactory->instance({helperClassName=>'tpl'}), 'wsTemplate::Helper::TPL' } 'Instances wsTemplate::Helper::' . uc($_) for (@knownHelpers);

my $helperClass;

for (@knownHelpers) {
	$helperClass = $helperFactory->instance({helperClassName=>$_});
	can_ok($helperClass,'mergeTemplateUnicornWithParametersPanda');
}

