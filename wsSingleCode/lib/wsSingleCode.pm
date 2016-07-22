package wsSingleCode;
use strict;
use warnings;

use Dancer ':syntax';

use Try::Tiny;

require wsSingleCode::ErrorHandler;

our $VERSION = '0.1';

get '/' => sub {
	template 'index';
};

get '/version' => sub {
	return { version => $VERSION };
};

get '/livelyness' => sub {
	return { live => 1 };
};

get '/ws/getFlightRangeInformation/:flightDesignator/:flightDate' => sub {
	require SingleCode::FlightInformation;

	my $serviceReadableResponse;
	my $flightInfo = SingleCode::FlightInformation->new();
	my $flightDesignator = params->{flightDesignator};
	my $flightDate = params->{flightDate};

	try {
		$serviceReadableResponse = $flightInfo->getFlightInformationMemoized($flightDesignator, $flightDate);
	} catch {
		$serviceReadableResponse = wsSingleCode::ErrorHandler::getResponseFromException($_);
	}

	return $serviceReadableResponse;
};

true;
