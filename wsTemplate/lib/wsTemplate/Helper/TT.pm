package wsTemplate::Helper::TT;

use strict;
use warnings;
use Moose;
with 'wsTemplate::Helper';

use Template;
use JSON qw();
use Try::Tiny;

use wsTemplate::Exception;

sub mergeTemplateUnicornWithParametersPanda {
	my ($self, $template, $parameters) = @_;
	my $output;

	my $tt = Template->new();
	my $vars;

	try {
		$vars = JSON::from_json($parameters->content);
	} catch {
		wsTemplate::Exception::BadJSON->throw(error=>$_);
	};
		
	$tt->process($template->file_handle,$vars,\$output);

	return $output;
};

no Moose;
__PACKAGE__->meta->make_immutable;
