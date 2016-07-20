package wsSingleCode;
use strict;
use warnings;

use Dancer ':syntax';
set serializer => mutable;

use Try::Tiny;

require SingleCode::ErrorHandler;

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

post '/ws/setFlightData/:flightDate' => sub {
	require SingleCode::FlightData;

	my $serviceReadableResponse;
	my $flightData = SingleCode::FlightData->new();
	my $flightDate = params->{flightDate};

	try {
		$serviceReadableRespose = $flightData->setFlightData(request->upload('flightData'),$flightDate);
	} catch {
		$serviceReadableResponse = wsSingleCode::ErrorHandler->getResponseFromException($_);
	}

	return $serviceReadableResponse;
}

get '/ws/getFlightData/:flightDate' => sub {
	require SingleCode::FlightData;

	my $serviceReadableResponse;
	my $flightData = SingleCode::FlightData->new();
	my $flightDate = params->{flightDate};

	try {
		$serviceReadableRespose = $flightData->getFlightData($flightDate);
	} catch {
		$serviceReadableResponse = wsSingleCode::ErrorHandler->getResponseFromException($_);
	}

	return $serviceReadableResponse;
}

get '/ws/getHoldingFlightInformation/:flightDesignator/:flightDate' => sub {
	require SingleCode::FlightInformation;

	my $serviceReadableResponse;
	my $flightInfo = SingleCode::FlightInformation->new();
	my $flightDesignator = params->{flightDesignator};
	my $flightDate = params->{flightDate};

	try {
		$flightInfo->getFlightInformation($flightDesignator, $flightDate);
	} catch {
		$serviceReadableResponse = wsSingleCode::ErrorHandler->getResponseFromException($_);
	}

	return $serviceReadableResponse;
};

true;
