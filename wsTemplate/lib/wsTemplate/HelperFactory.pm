package wsTemplate::HelperFactory;

use Moose;
use Try::Tiny;

has 'helperClassName' => (
	is  => 'ro',
	isa => 'Str',
);

sub instance {
	my $self = shift;
	my $helperInstantializationFailed = 0;

	my $helperClassName = $self->helperClassName;
	$helperClassName =~ /((tt)|(tpl))/i;
	$helperClassName = 'wsTemplate::Helper::' . uc($1);

	my $helperClass;

	if ($helperClassName) {
		require $helperClassName;
		$helperClass = wsTemplate::HelperFactory->instance(params->{templateType});
	}

	return $helperClass;
}


no Moose;
__PACKAGE__->meta->make_immutable;
