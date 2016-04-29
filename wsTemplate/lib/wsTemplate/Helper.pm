package wsTemplate::Helper;

use Moose::Role;

has 'template' => (
	is => 'ro',
	isa => 'Str',
);

has 'parameters' => (
	is => 'ro',
	isa => 'Str',
);

requires 'mergeTemplateUnicornWithParametersPanda';

1;
