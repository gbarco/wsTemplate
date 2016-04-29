use Test::More tests => 1;
use strict;
use warnings;

use wsSpeadsheet;

# the order is important
use Dancer::Test;
use Test::File::Contents;

my $testFilePath = 't/test_files/';

@happyPathTests = [
	{template=>'warning.tt',parameters=>'warning.simpleERROR.json',results=>'warning.simpleERROR.processed'},

];

foreach $happyPathTest (@happyPathTests) {
	my $happyPathResponse = dancer_response('POST' => '/ws/tt',{ files => [{filename => $testFilePath . $happyPathTest->{template}, name => 'template'},{filename => $testFilePath . $happyPathTest->{parameters}, name => 'parameter'}] });
	file_contents_eq($testFilePath . $happyPathTest->{results}, $happyPathResponse->{content}, $happyPathTest->{message});
}

