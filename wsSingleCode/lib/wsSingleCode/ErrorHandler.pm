package wsSingleCode::ErrorHandler;

sub getUserReadableResponseForException {
	return {error=> $_[1]};
}

1;
