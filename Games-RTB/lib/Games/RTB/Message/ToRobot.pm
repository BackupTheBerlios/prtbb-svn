#!/usr/bin/perl

package Games::RTB::Message::ToRobot;

use strict;
use warnings;
use vars qw( @ISA $VERSION @EXPORT_OK %EXPORT_TAGS %to_robot_types );
use Games::RTB::Message;

require Exporter;

@ISA = qw( Games::RTB::Message Exporter );

$VERSION = 0.01;

@EXPORT_OK = qw( @to_robot_types );

%EXPORT_TAGS = (
		all		=> [ @EXPORT_OK ],
		types	=> [qw( %to_robot_types )]
);

=head1 NAME

foo

=cut

%to_robot_types = (
		Initialize		=> [qw( Int )],
		YourName		=> [qw( String )],
		YourColour		=> [qw( Hex )],
		GameOption		=> [qw( Int Double )],
		GameStarts		=> [qw( )],
		Radar			=> [qw( Double Int Double )],
		Info			=> [qw( Double Double Double )],
		Coordinates		=> [qw( Double Double Double )],
		RobotInfo		=> [qw( Double Int )],
		RotationReached	=> [qw( Int )],
		Energy			=> [qw( Double )],
		RobotsLeft		=> [qw( Int )],
		Collision		=> [qw( Int Double )],
		Warning			=> [qw( Int String )],
		Dead			=> [qw( )],
		GameFinishes	=> [qw( )],
		ExitRobot		=> [qw( )],
		empty			=> [qw( )]
);

sub init($%) {
	my ($self, %args) = @_;
	$self->type($args{type}) if $args{tags};
	$self->debug($args{debug}) if $args{debug}; #TODO Move that to Message.pm?

	return 1 if $self->type eq 'empty';
	$self->Debug(__PACKAGE__.'::init: Unknown message type', $self->type),
		return if(!grep {$_ eq $self->type} keys %to_robot_types);

	if( @{ $args{args} } != @{ $to_robot_types{$self->type} } ) {
		$self->Debug( __PACKAGE__ . ':', $self->type . ':',
				'incorrect number of arguments.',
				'Got', scalar @{ $args{args} },
				'expected', scalar @{ $to_robot_types{$self->type} } );
		return;
	}

	return 1 if $self->make_args( $to_robot_types{$self->type}, $args{args} );

	$self->Debug( __PACKAGE__ . ':', $self->type . ': invalid arguments:',
			'expected', join(' ', @{ $to_robot_types{$self->type} }) );
	return;
}

sub type($;$) {
	my ($self, $type) = @_;

	if(defined $type) {
		return if( !grep { $_ eq $type } keys %to_robot_types );
	}

	$self->SUPER::type($type);
}

1;
