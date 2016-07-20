package wsSingleCode::ErrorHandler;

sub getUserReadableResponseForException {
	return 'An error occurred: ' . $_[1];
}

1;
