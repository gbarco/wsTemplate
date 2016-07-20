package SingleCode::Exception;

use Exception::Base
  'SingleCode::Exception::Error' => { has => ['error'] },
  'SingleCode::Exception::AirlineCodeUnknown' => { isa => 'SingleCode::Exception::Error' },
  'SingleCode::Exception::FlightNumberFormat' => { isa => 'SingleCode::Exception::Error' },
  'SingleCode::Exception::FlightDateFormat' => { isa => 'SingleCode::Exception::Error' },

1;
