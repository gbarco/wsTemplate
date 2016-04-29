use Test::More tests => 1;
use strict;
use warnings;

use wsTemplate;

# the order is important
use Dancer::Test;
use Test::File::Contents;

my $testFilePath = 't/test_files/';

my @happyPathTests = (
	{template=>'warning.tt',parameters=>'warning.simpleERROR.json',results=>'warning.simpleERROR.processed',message=>'Simple error on warning.tt'},

);

foreach my $happyPathTest (@happyPathTests) {
	my $happyPathResponse = dancer_response('POST' => '/ws/tt',{ files => [{filename => $testFilePath . $happyPathTest->{template}, name => 'template'},{filename => $testFilePath . $happyPathTest->{parameters}, name => 'parameter'}] });
	file_eq_or_diff($testFilePath . $happyPathTest->{results}, $happyPathResponse->{content}, $happyPathTest->{message});
}

