package wsTemplate::Exception;

use Exception::Base
	'wsTemplate::Exception::Error' => {has => ['error']},
	'wsTemplate::Exception::FailedToInstanceHelperClass' => { isa => 'wsTemplate::Exception::Error' },
	'wsTemplate::Exception::MuggleHelper' => { isa => 'wsTemplate::Exception::Error' };

1;
