package wsTemplate::Exception;

use Exception::Base
	'wsTemplate::Exception::Error' => {has => ['error']},
	'wsTemplate::Exception::FailedToInstanceHelperClass' => { isa => 'wsTemplate::Exception::Error' },
	'wsTemplate::Exception::MuggleClass' => { isa => 'wsTemplate::Exception::Error' };

1;
