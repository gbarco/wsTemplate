package wsTemplate;
use strict;
use warnings;

use Dancer ':syntax';

use Try::Tiny;
use JSON;

require wsTemplate::ErrorHandler;

our $VERSION = '0.1';

get '/' => sub {
	template 'index';
};

get '/version' => sub {
	content_type 'application/json';
	
	return to_json { version => $VERSION };
};

post '/ws/:templateType/' => sub {
	require wsTemplate::HelperFactory;

	my $helperClass;
	my $userReadableResponse;	

	try {
		$helperClass = wsTemplate::HelperFactory->instance(params->{templateType});
	} catch {
		my $exception = $_;
		$userReadableResponse = wsTemplate::ErrorHandler->getUserReadableResponseForException($exception);
	}

	unless ($helperClass) {
		my $templateUnicorn = request->upload('template');
		my $parametersPanda = request->upload('vars');

		try {
			my $templatePandicorn = $helperClass->mergeUnicornWithPanda($templateUnicorn, $parametersPanda);
			$userRedableResponse = $templatePandicorn || wsTemplate::ErrorHandler->getUserReadableResponseForException(new Exception::HelperProducedNoOutput);
		} catch {
			my $exception = $_;
			$userReadableResponse = wsTemplate::ErrorHandler->getUserReadableResponseForException($exception);
		}
	}

	return $userReadableResponse;
};

true;
