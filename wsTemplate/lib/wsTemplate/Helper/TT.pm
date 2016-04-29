package wsTemplate::Helper::TT;

use Moose;
with 'wsTemplate::Helper';

sub instance {return 1;};
sub mergeTemplateUnicornWithParametersPanda {return 1;};

no Moose;
__PACKAGE__->meta->make_immutable;
