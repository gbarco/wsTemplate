package wsTemplate::Helper::TPL;

use Moose;
with 'wsTemplate::Helper';

sub instance {};
sub mergeTemplateUnicornWithParametersPanda {};

no Moose;
__PACKAGE__->meta->make_immutable;
