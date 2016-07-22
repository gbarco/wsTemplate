package SingleCode::Exception;

use Exception::Base
  'SingleCode::Exception::Error' => { has => ['error'] },
  'SingleCode::Exception::FlightRangeDatesInvalid' => { isa => 'SingleCode::Exception::Error' },
  'SingleCode::Exception::FlightDateInvalid' => { isa => 'SingleCode::Exception::Error' },
  'SingleCode::Exception::FlightDesignatorInvalid' => { isa => 'SingleCode::Exception::Error' },
  ;

1;
