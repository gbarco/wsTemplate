package SingleCode::FlightInformation;

use 5.18.2;

use Moose;
use namespace::autoclean;

use Memoize qw();

require DateTime qw();
require DateTime::Format::DateParse;

require SingleCode::Exception;

use constant {
	MIN_DATE => 19000101,
	MAX_DATE => 99993112,
};

has 'flightRangeDataUpdated' => (isa => 'Int', is => 'rw', builder => '_resetFlightRangeDataUpdated' );
has 'flightRangeData' => ( isa => 'HashRef', is => 'ro', lazy => 1, builder => '_getFlightRangeData' );

# Publics

# If flightDate needs be determined for today this is the recommended snippet
# use DateTime;
# my $flightDate = DateTime->today()->set_time_zone('GMT')->ymd('');

sub getFlightInformationMemoized {
	my ($self, $flightDesignator, $flightDate) = @_;

	my ($flightAirlineCode, $flightNumber) = $self->parseFlightDesignator($flightDesignator);

	SingleCode::Exception::AirlineCodeUnknown->throw(
		error=>"Non holding airline code <$flightAirlineCode> extracted from designator <$flightDesignator>.") unless defined($self->flightRangeData->{$flightAirlineCode});
	SingleCode::Exception::FlightNumberFormat->throw(
		error=>"Flight number format unknown <$flightNumber> extracted from designator <$flightDesignator>.") unless $flightNumber > 0;
	SingleCode::Exception::FlightDateInvalid->throw(
		error=>"Flight date out of range or invalid <$flightDate>. Expected " . MIN_DATE . ' to ' . MAX_DATE . '.') unless $self->isFlightDateValidMemoized($flightDate);

	my $activeFlightRangeData = $self->_getActiveFlightRangeData($flightAirlineCode, $flightDate);
	my $flightInformation = $self->_getFlightInformationFromFlightRangeData($flightNumber, $activeFlightRangeData);

	return $flightInformation;
}

# Privates

# Returns the range data valid for a given flight date

sub _getActiveFlightRangeData {
	my ($self, $flightAirlineCode, $flightDate) = @_;

	my $activeFlightRangeDate = $self->getActiveFlightRangeDataKey($flightAirlineCode, $flightDate);
	my $flightRangeData = $self->flightRangeData->{$activeFlightRangeDate};

	return $flightRangeData;
}

# Select the proper range from flight data for a given flight airline code and flight number

sub _getFlightInformationFromFlightRangeData {
	my ($self, $flightNumber, $activeFlightRangeData) = @_;
	my $flightInformation;

	for my $range (@$activeFlightRangeData) {
		if ($range->{min} <= $flightNumber && $flightNumber <= $range->{max}) {
			$flightInformation = $range;
		}
	}

	return $flightInformation;
}

# Returns the key to the active flight range data for a given date

sub _getActiveFlightRangeDataKey {
	my ($self, $flightAirlineCode, $flightDate) = @_; 
	my $lesserOrEqualDate = MIN_DATE;
	for my $dateIterator (sort keys %{$self->flightRangeData->{$flightAirlineCode}}) {
		$lesserOrEqualDate = $dateIterator if ($lesserOrEqualDate <= $flightDate && $flightDate < $dateIterator);
	}

	return $lesserOrEqualDate
}

# Determines if a flight date is valid based on parsability/calendar validity and date range

sub _isFlightDateValidMemoized {
	my ($self, $flightDate) = @_;
	my $validFlightDate = 1;
	try {
		DateTime::Format::DateParse->parse_datetime($flightDate);

		# Since this is a valid date... it is faster to just check we are within the expected range.
		$validFlightDate = 0 unless $flightDate >= MIN_DATE && $flightDate <= MAX_DATE;
	} catch {
		$validFlightDate = 0;
	}
	return $validFlightDate;
}

sub _parseFlightDesignator {
	my ($self, $flightDesignator) = @_;

	if ($flightDesignator =~ /(\w+)?(\d)/) {
		$flightAirlineCode = $1 if $1;
		$flightNumber = $2;
	}

	return ($flightAirlineCode, $flightNumber);
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

sub _getFlightRangeData {
	my ($self) = @_;
	my $flightData = {
		'LA' => {
			'20160801' => [
				{min=>1, max=>250,operating_airline=>'LA', marketing_airline=>'LA'},
				{min=>251, max=>399,operating_airline=>'LA', marketing_airline=>'LU'},
				{min=>400, max=>1299,operating_airline=>'LA', marketing_airline=>'LA'},
				{min=>1300, max=>1349,operating_airline=>'PZ', marketing_airline=>'LA'},
				{min=>1350, max=>1499,operating_airline=>'XL', marketing_airline=>'LA'},
				{min=>1500, max=>1999,operating_airline=>'',marketing_airline=>''},
				{min=>2000, max=>2549,operating_airline=>'LP',marketing_airline=>'LA'},
				{min=>2550, max=>2999,operating_airline=>'',marketing_airline=>''},
				{min=>3000, max=>9999,operating_airline=>'JJ',marketing_airline=>'LA'},
			],
			'20170101' => [
				{min=>1, max=>250,operating_airline=>'LA', marketing_airline=>'LA'},
				{min=>251, max=>399,operating_airline=>'LA', marketing_airline=>'LU'},
				{min=>399, max=>1299,operating_airline=>'LA', marketing_airline=>'LA'},
				{min=>1300, max=>1349,operating_airline=>'PZ', marketing_airline=>'LA'},
				{min=>1350, max=>1499,operating_airline=>'XL', marketing_airline=>'LA'},
				{min=>1500, max=>1999,operating_airline=>'',marketing_airline=>''},
				{min=>2000, max=>2549,operating_airline=>'LP',marketing_airline=>'LA'},
				{min=>2550, max=>2999,operating_airline=>'',marketing_airline=>''},
				{min=>3000, max=>9999,operating_airline=>'JJ',marketing_airline=>'LA'},
			],
		}
	};

	my ($first, $last) = (sort keys %$flightData)[0,-1];

	$flightData->{MIN_DATE} = $flightData->{$first};
	$flightData->{MAX_DATE} = $flightData->{$last};

	$self->_resetMemoizedResults();

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
