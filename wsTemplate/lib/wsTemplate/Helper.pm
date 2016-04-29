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

requires 'instance';
requires 'mergeTemplateUnicornWithParametersPanda';

no Moose;
__PACKAGE__->meta->make_immutable;
