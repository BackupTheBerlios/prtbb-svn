#!/usr/bin/perl

package Games::RTB::Type;

use strict;
use warnings;
use vars qw( @ISA $VERSION @EXPORT_OK %EXPORT_TAGS @types );

require Exporter;

@ISA = qw( Exporter );

@EXPORT_OK = qw( @types RTB_INT RTB_STRING RTB_HEX RTB_DOUBLE RTB_ANGLE );

%EXPORT_TAGS = (
		all			=> [ @EXPORT_OK ],
		valid_types	=> [qw( @types )],
		types		=> [qw( RTB_INT RTB_STRING RTB_HEX RTB_DOUBLE RTB_ANGLE )]
);

@types = qw(
		Int
		String
		Hex
		Double
		Angle
);	#TODO Do we need this? Should this know about it's subclasses?
	# Yeah, it should.

sub RTB_INT($)		{ Games::RTB::Type::Int->new($_[0]); }
sub RTB_STRING($)	{ Games::RTB::Type::String->new($_[0]); }
sub RTB_HEX($)		{ Games::RTB::Type::Hex->new($_[0]); }
sub RTB_DOUBLE($)	{ Games::RTB::Type::Double->new($_[0]); }
sub RTB_ANGLE($)	{ Games::RTB::Type::Angle->new($_[0]); }

sub new($$) {
	my ($this, $value) = @_;
	my $class = ref($this) || $this;
	
	my $self = \$value;
	bless $self, $class;

	return if !grep { $_ eq $self->type } @types;
	$self->check() or return;

	return $self;
}

sub check($) {
	return 1;
}

sub type($) {
	my $self = shift;
	my $class = ref($self) || $self;
	
	$class =~ s/.*://;
	return $class;
}

sub value($) {
	my $self = shift;

	return ${$self};
}

sub as_string($) {
	my $self = shift;

	return ${$self};
}

package Games::RTB::Type::Int;

use strict;
use warnings;
use vars qw( @ISA );

@ISA = qw( Games::RTB::Type );

sub check($) {
	return 1; #TODO
}

package Games::RTB::Type::String;

use strict;
use warnings;
use vars qw( @ISA );

@ISA = qw( Games::RTB::Type );

sub check($) {
	return 1; #TODO
}

package Games::RTB::Type::Hex;

use strict;
use warnings;
use vars qw( @ISA );

@ISA = qw( Games::RTB::Type );

sub check($) {
	return 1; #TODO
}

sub as_string($) {
	my $self = shift;
	sprintf "%x", $self->value;
}

package Games::RTB::Type::Double;

use strict;
use warnings;
use vars qw( @ISA );

@ISA = qw( Games::RTB::Type );

sub check($) {
	return 1; #TODO
}

package Games::RTB::Type::Angle;

use strict;
use warnings;
use vars qw( @ISA );

@ISA = qw( Games::RTB::Type::Double );

sub check($) {
	return 1; #TODO
}
