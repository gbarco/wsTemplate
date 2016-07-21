package SingleCode::FlightRanges;

use 5.18.2;

use Moose;
use namespace::autoclean;

use Memoize qw();

require DateTime qw();
require DateTime::Format::DateParse;
 $flightDesignator, $flightDate)
require SingleCode::Exception;

use constant {
	MIN_DATE => 19000101,
	MAX_DATE => 99993112,
};

has 'flightRangeDataUpdated' => (isa => 'Int', is => 'rw', builder => '_resetFlightRangeDataUpdated' );
has 'flightRangeData' => ( isa => 'HashRef', is => 'ro', lazy => 1, builder => '_getFlightRangeData' );

# Publics

# Returns the flight range information for a given flight designator and date
# If flightDate needs be determined for today this is the recommended snippet
# use DateTime;
# my $flightDate = DateTime->today()->set_time_zone('GMT')->ymd('');
# throws SingleCode::Exception::FlightDesignatorFormat, SingleCode::Exception::FlightDateInvalid

sub getFlightInformationMemoized {
    my ( $self, $flightDesignator, $flightDate ) = @_;

    my $flightDesignatorNormalized = $self->_normalizeFlightDesignator($flightDesignator);
    my $flightDateNormalized = $self->_normalizeFlightDate($flightDate);

    my $flightInformation = $self->_getFlightInformationFromNormalizedParameters($flightDesignatorNormalized, $flightDateNormalized);

    return $flightInformation;
}

# Privates

# Returns a flight date converted to a flight range definition start date

sub _normalizeFlightDate {
	my ($self, $flightDate) = @_; 
	my $flightRangeDates = $self->_getBackendFlightRangesDatesSorted();

	SingleCode::Exception::FlightRangeDatesInvalid->throw('Flight range valid dates failed') unless ref $flightRangeValidDates eq 'ARRAY' and scalar @$flightRangeValidDates > 0

	my $lesserOrEqualDate = $$flightRangeDates[0];
	
	for my $dateIterator (@$flightRangeDates) {
		$lesserOrEqualDate = $dateIterator if ($lesserOrEqualDate <= $flightDate && $flightDate < $dateIterator);
	}

	return $lesserOrEqualDate;
}

# Returns a flight date normalized to YMD format
# Throws SingleCode::Exception::FlightDateInvalid

sub _normalizeFlightDateFormat {
	my ($self, $flightDate) = @_;
	my $validFlightDate = 1;
	my $flightDateNormalized;

	try {
		$flightDateNormalized = DateTime::Format::DateParse->parse_datetime($flightDate)->ymd('');
	} catch {
		SingleCode::Exception::FlightDateInvalid->throw(
			error=>"Flight date invalid  <$flightDate>. Expected YYYYMMDD from gregorian calendar.");
	}
	# Since this is a valid date and has been normalized it is faster to just check we are within the expected range.
	SingleCode::Exception::FlightDateInvalid->throw(
		error=>"Flight date out of range <$flightDate> normalized <$flightDateNormalized>. Expected " . MIN_DATE . ' to ' . MAX_DATE . '.') unless ($flightDate >= MIN_DATE && $flightDate <= MAX_DATE);

	return $flightDateNormalized;
}

# Normalizes a flight designator for look up in backend.
# LA0001 -> LA1

sub _normalizeFlightDesignator {
	my ($self, $flightDesignator) = @_;

	if ($flightDesignator =~ /^(\w{2})(\d{1,4})$/) {
		$flightAirlineCode = $1 if $1;
		$flightNumber = $2;
	} else {
		SingleCode::Exception::FlightDesignatorFormat->throw('The format of the flight designator could not be parsed correctly from <$flightDesginator> to Two letters: <$1> and 1 to 4 numbers <$2>.');
	}

	return $flightAirlineCode . scalar $flightNumber;
}

# Moose builders and builder helpers

# Resets backend data last update to right now

sub _resetFlightRangeDataUpdated {
	return time;
}

# Mocked datasource for flight ranges
# This should be replaced
=item Expected input format
Fecha	Rango	Operating	Marketing
20160801	1	LA	LA
20160801	250	LA	LU
20160801	399	LA	LA
20160801	1299	PZ	LA
20160801	1349	XL	LA
20160801	1499		
20160801	1999	LP	LA
20160801	2549		
20160801	2999	JJ	LA
20160801	9999		
20170101	1	JJ	LA
20170101	250	PZ	LA
20170101	399	XL	LA
20170101	1299	4M	LA
20170101	1349	4C	LA
20170101	1499		
20170101	1999	LP	LA
20170101	2549		
20170101	2999	JJ	LA
20170101	9999		
=cut

# Returns a _SORTED_ set of valid flight ranges normalized to YYYYMMDD format

sub _getBackendFlightRangesDatesSorted {
	my ($self) = @_;

	return sort self->_getFlightRangeData()->{'flightRangeValidDates'};
}

# Returns a single flight data for a valid flight range start date and normalized flight designator
# Normalized flight designator LA001 => LA1, LA0000001=>LA1, LA0999=>LA999
# Undef for unknown convinations of valid dates

sub _getBackendFlightRangeData {
	my ($self,  $flightDesignatorNormalized, $flightDateValidRangeStart) = @_;

	return self->_getFlightRangeData()->{$flightDesignatorNormalized.$flightDateValidRangeStart};
}

# Simulates backend data

sub _getFlightRangeData {
	my ($self) = @_;
	my $flightData = {
		flightRangeValidDates => qw/20160701 20160802 20160901/,
		'20160701LA1' => {airline_code=>'LA', flight_number=>1, marketing_airline=>'LA', operating_airline=>'LA', valid_from=>'20160701', valid_to=>'20160802'},
		'20160802LA1' => {airline_code=>'LA', flight_number=>1, marketing_airline=>'LA', operating_airline=>'LA', valid_from=>'20160802', valid_to=>'20160830'},
		'20160901LA1' => {airline_code=>'LA', flight_number=>1, marketing_airline=>'LA', operating_airline=>'LA', valid_from=>'20160901', valid_to=>MAX_DATE},
	};

	return $flightData;
}

sub _resetMemoizedResults {
	Memoize::unmemoize('getFlightInformationMemoized');
	Memoize::memoize('getFlightInformationMemoized');
	Memoize::unmemoize('isFlightDateValidMemoized');
	Memoize::memoize('isFlightDateValidMemoized');
}

__PACKAGE__->meta->make_immutable;

1;
