package wsTemplate::HelperFactory;

use Moose;
use Try::Tiny;
use wsTemplate::Exception;

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
		try {
			require $helperClassName;
			bless $helperClass, $helperClassName;
		} catch {
			my $errorMessage = $_;
			wsTemplate::Exception::FailedToInstanceHelperClass->throw(error=>$errorMessage);
		}
	}

	unless(ref $helperClass && $helperClass->can('instance')) {
		wsTemplate::Exception::MuggleHelper->throw(error=>"Class has no magic when trying to instance $helperClassName");
	}

	return $helperClass->instance;
}


no Moose;
__PACKAGE__->meta->make_immutable;
