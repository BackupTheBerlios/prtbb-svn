#!/usr/bin/perl

package Games::RTB::Message::FromRobot;

use strict;
use warnings;
use vars qw( @ISA $VERSION @EXPORT_OK %EXPORT_TAGS %from_robot_types );
use Games::RTB::Message;
use Games::RTB::Type qw( :types );

require Exporter;

@ISA = qw( Games::RTB::Message Exporter );

$VERSION = 0.01;

@EXPORT_OK = qw( ROBOT CANNON RADAR %from_robot_types SEND_SIGNAL
				SEND_ROTATION_REACHED SIGNAL USE_NON_BLOCKING );

%EXPORT_TAGS = (
		all					=> [ @EXPORT_OK ],
		parts				=> [qw( ROBOT CANNON RADAR )],
		types				=> [qw( %from_robot_types )],
		robot_option_types	=> [qw( SEND_SIGNAL SEND_ROTATION_REACHED SIGNAL
								USE_NON_BLOCKING )]
);

use constant {
	#RobotOption types
	SEND_SIGNAL				=> 0,
	SEND_ROTATION_REACHED	=> 1,
	SIGNAL					=> 2,
	USE_NON_BLOCKING		=> 3,
	
};	#TODO export properly using Exporter (How? An array or hash can't be used
	# like ROBOT+CANNON i.e. constants can't be exported that easy using the
	# Exporter (really? -- check that)) Uh, they are just normal typeglobs, so
	# they can. Great! Check if that may raises other issues.
	#TODO maybe move that to another module because it's probably also essential
	# for other submodules and the whole robot class but may also be used with
	# the robot script


=head1 NAME

Games::RTB::Message::FromRobot - Class representing a message sent by the Robot
to the RealTimeBattle game engine

=head1 SYNOPSIS

  use Games::RTB::Message::FromRobot qw/:all/;
  $msg = Games::RTB::Message::FromRobot->new(
          type  => RobotOption,
          args  => [qw( SEND_ROTATION_REACHED 2 )],
          debug => 1
  );
  $msg->send();

=head1 DESCRIPTION

Games::RTB::Message::FromRobot provides a class that represents a RealTimeBattle
message sent by the bot to the game engine. It's based on the
Games::RTB::Message class.

Games::RTB::Message::FromRobot may be used with the following import sets:

=head2 :parts

Exports constants for the parts of the robot (ROBOT, CANNON, RADAR).

=head2 :types

Export all valid message types for the robot to send as %from_robot_types

=head2 :all

Exports all of the obove tags.

=head1 METHODS

=head2 new

  $msg = Games::RTB::Message::FromRobot->new();
  $msg = Games::RTB::Message::FromRobot->new(
          type => 'Name',
          args => [qw( moo )]
  );

Class constructor. Inherited from Games::RTB::Message. See Games::RTB::Message's
documentation for details.

Valid message types are all valid RealTimeBattle messages the bot can (

=head2 send

  $msg->send();

Sends the message. Inherited from Games::RTB::Message. See Games::RTB::Message's
documentation for details.

=head2 debug

  my $debug = $msg->debug();
  $msg->debug(1);

Set or return the debug status. Inherited from Games::RTB::Message. See
Games::RTB::Message's documentation for details.

=cut

%from_robot_types = (
		RobotOption		=> [qw( Int Int )],
		Name			=> [qw( String )],
		Colour			=> [qw( Hex Hex )],
		Rotate			=> [qw( Int Double )],
		RotateTo		=> [qw( Int Double Double )],
		RotateAmount	=> [qw( Int Double Double )],
		Sweep			=> [qw( Int Double Double Double )],
		Accelerate		=> [qw( Double )],
		Brake			=> [qw( Double )],
		Shoot			=> [qw( Double )],
		Print			=> [qw( String )],
		Debug			=> [qw( String )],
		DebugLine		=> [qw( Double Double Double Double )],
		DebugCircle		=> [qw( Double Double Double )],
		UNKNOWN			=> [qw( )]
);

sub init($%) {	#TODO maybe move that to the Message.pm and use the
				# {From,To}Robot classes simply to export constants, etc.
	my ($self, %args) = @_;
	$self->type($args{type}) if $args{type};
	$self->debug($args{debug}) if $args{debug};

	return 1 if $self->type eq 'UNKNOWN';
	$self->Debug(__PACKAGE__.'::init: Unknown message type', $self->type),
		return if(!grep {$_ eq $self->type} keys %from_robot_types);

	if( @{ $args{args} } != @{ $from_robot_types{$self->type} } ) {
		$self->Debug( __PACKAGE__ . ':', $self->type . ':',
				'incorrect number of arguments.', 
				'Got', scalar @{ $args{args} },
				'expected', @{ $from_robot_types{$self->type} } );
		return;
	}

	return 1 if $self->make_args( $from_robot_types{$self->type}, $args{args} );

	$self->Debug( __PACKAGE__ . ':', $self->type . ': invalid arguments',
			'expected', join(' ', @{ $from_robot_types{$self->type} }) );
	return;
}

=head2 type

  my $type = $msg->type();
  $msg->type('Rotate');

Returns or sets the messages type. This is a wrapper around
Games::RTB::Message::type() which adds type checking.

=cut

sub type($;$) {
	my ($self, $type) = @_;

	if(defined $type) {
		return if( !grep { $_ eq $type } keys %from_robot_types );
	}

	$self->SUPER::type($type);
}

=head2 Debug

=cut

sub Debug($@) {	#TODO that's not needed anymore, is it? Figure out something to
				# be able to create Debug Messages and handle errors while that.
	my ($self, @msg) = @_;


	if(!@msg) {
		$self->Debug(__PACKAGE__.'::Debug: no message given');
		return;
	}

	if($self->type ne 'Debug' && $self->debug) {	# Are we called to create a
													# new Debug Message or to
													# report an already occured
													# error?
		my $dbg = Games::RTB::Message::FromRobot->new(
				debug	=> 0,	# must be 0 to prevent infinit loops
				type	=> 'Debug',
				args	=> [ @msg ]
		)->send();
		return;
	}

	$self->args(@msg);
	return 1;
}

=head1 AUTHOR

Florian Ragwitz <florian@mookooh.org>

=head1 COPYRIGHT

(C) 2004 Florian Ragwitz

=head1 LICENSE

This code is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

=head1 SEE ALSO

Games::RTB, Games::RTB::Message

=cut

1;
