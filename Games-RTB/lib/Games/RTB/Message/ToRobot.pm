#!/usr/bin/perl

package Games::RTB::Message::ToRobot;

use strict;
use warnings;
use vars qw( @ISA $VERSION @EXPORT_OK %EXPORT_TAGS %to_robot_types );
use Games::RTB::Message;

require Exporter;

@ISA = qw( Games::RTB::Message Exporter );

$VERSION = 0.01;

@EXPORT_OK = qw( @to_robot_types UNKNOWN PROCESS_TIME_LOW
				MESSAGE_SENT_IN_ILLEGAL_STATE UNKNOWN_OPTION OBSOLETE_KEYWORD
				NAME_NOT_GIVEN COLOUR_NOT_GIVEN ROBOT_MAX_ROTATE
				ROBOT_CANNON_MAX_ROTATE ROBOT_RADAR_MAX_ROTATE
				ROBOT_MAX_ACCELERATION ROBOT_MIN_ACCELERATION ROBOT_START_ENERGY
				ROBOT_MAX_ENERGY ROBOT_ENERGY_LEVELS SHOT_SPEED SHOT_MIN_ENERGY
				SHOT_MAX_ENERGY SHOT_ENERGY_INCREASE_SPEED TIMEOUT DEBUG_LEVEL
				SEND_ROBOT_COORDINATES );

%EXPORT_TAGS = (
		all					=> [ @EXPORT_OK ],
		types				=> [qw( %to_robot_types )],
		warning_types		=> [qw( UNKNOWN PROCESS_TIME_LOW
								MESSAGE_SENT_IN_ILLEGAL_STATE UNKNOWN_OPTION
								OBSOLETE_KEYWORD NAME_NOT_GIVEN
								COLOUR_NOT_GIVEN )],
		game_option_types	=> [qw( ROBOT_MAX_ROTATE ROBOT_CANNON_MAX_ROTATE
								ROBOT_RADAR_MAX_ROTATE ROBOT_MAX_ACCELERATION
								ROBOT_MIN_ACCELERATION ROBOT_START_ENERGY
								ROBOT_MAX_ENERGY ROBOT_ENERGY_LEVELS SHOT_SPEED
								SHOT_MIN_ENERGY SHOT_MAX_ENERGY
								SHOT_ENERGY_INCREASE_SPEED TIMEOUT DEBUG_LEVEL
								SEND_ROBOT_COORDINATES )]
);

use constant {
		#Warning types
		UNKNOWN							=> 0,
		PROCESS_TIME_LOW				=> 1,
		MESSAGE_SENT_IN_ILLEGAL_STATE	=> 2,
		UNKNOWN_OPTION					=> 3,
		OBSOLETE_KEYWORD				=> 4,
		NAME_NOT_GIVEN					=> 5,
		COLOUR_NOT_GIVEN				=> 6,
		#GameOption types
		ROBOT_MAX_ROTATE				=> 0,
		ROBOT_CANNON_MAX_ROTATE			=> 1,
		ROBOT_RADAR_MAX_ROTATE			=> 2,
		ROBOT_MAX_ACCELERATION			=> 3,
		ROBOT_MIN_ACCELERATION			=> 4,
		ROBOT_START_ENERGY				=> 5,
		ROBOT_MAX_ENERGY				=> 6,
		ROBOT_ENERGY_LEVELS				=> 7,
		SHOT_SPEED						=> 8,
		SHOT_MIN_ENERGY					=> 9,
		SHOT_MAX_ENERGY					=> 10,
		SHOT_ENERGY_INCREASE_SPEED		=> 11,
		TIMEOUT							=> 12,
		DEBUG_LEVEL						=> 13,
		SEND_ROBOT_COORDINATES			=> 14
};

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
		UNKNOWN			=> [qw( )]
);

sub init($%) {
	my ($self, %args) = @_;
	$self->type($args{type}) if $args{tags};
	$self->debug($args{debug}) if $args{debug}; #TODO Move that to Message.pm?

	return 1 if $self->type eq 'UNKNOWN';
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
