#!/usr/bin/perl

package Games::RTB::Type;

use strict;
use warnings;
use vars qw( @ISA $VERSION @EXPORT_OK %EXPORT_TAGS @types );

require Exporter;

@EXPORT_OK = qw( @types );

%EXPORT_TAGS = (
		all		=> [ @EXPORT_OK ],
		types	=> [qw( @types )]
);

@types = qw(
		Int
		String
		Hex
		Double
		Angle
);	#TODO Do we need this? Should this know about it's subclasses?

sub new($$) {
	my ($this, $value) = @_;
	$class = ref($this) || $this;
	
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

sub print($) {
	my $self = shift;

	print $self->value;
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

sub print($) {
	my $self = shift;
	printf "%x", $self->value;
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
