#!/usr/bin/perl

package Games::RTB::Message::FromRobot;

use strict;
use warnings;
use vars qw( @ISA $VERSION @EXPORT_OK %EXPORT_TAGS @from_robot_types );
use Games::RTB::Message;

require Exporter;

@ISA = qw( Games::RTB::Message Exporter );

@EXPORT_OK = qw( ROBOT CANNON RADAR @from_robot_types );

%EXPORT_TAGS = (
		all		=> [ @EXPORT_OK ],
		parts	=> [qw( ROBOT CANNON RADAR )],
		types	=> [qw( @from_robot_types )]
);

use constant {
	ROBOT	=> 1,
	CANNON	=> 2,
	RADAR	=> 4
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

Export all valid message types for the robot to send as @from_robot_types

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

$VERSION = 0.01;

@from_robot_types = qw(
		RobotOption
		Name
		Colour
		Rotate
		RotateTo
		RotateAmount
		Sweep
		Accelerate
		Brake
		Shoot
		Print
		Debug
		DebugLine
		DebugCircle
		empty
);

sub init($%) {
	my ($self, %args) = @_;
	$self->type($args{type}) if $args{type};
	$self->debug($args{debug}) if $args{debug};

	return 1 if $self->type eq 'empty';
	$self->Debug(__PACKAGE__.'::init: Unknown message type', $self->type),
		return if(!grep {$_ eq $self->type} @from_robot_types);

	my $sub;
	{
		no strict 'refs';
		$sub = \&{$self->type};
	}

	return if !defined &{$sub};
	return $self->$sub(@{ $args{args} });
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
		return if( !grep { $_ eq $type } @from_robot_types );
	}

	$self->SUPER::type($type);
}

=head2 RobotOption

=cut

sub RobotOption($$$) {
	return unless $#_ == 2;
	my ($self, $option, $value) = @_;

	if(	$option eq 'SIGNAL' ||	#TODO What value does signal need?
			$option eq 'SEND_SIGNAL' ||
			$option eq 'USE_NON_BLOCKING' ) {

		if($value == 0 || $value == 1) {
			$self->args($option, $value);
			return 1;
		}

		$self->Debug(__PACKAGE__.'::RobotOption: Invalid value for RobotOption',
				$option, '-', $value);
		return;

	} elsif( $option eq 'SEND_ROTATION_REACHED' ) {

		if($value == 0 || $value == 1 || $value == 2) {
			$self->args($option, $value);
			return 1;
		}

		$self->Debug(__PACKAGE__.'::RobotOption: Invalid value for RobotOption',
				$option, '-', $value);
		return;

	}

	$self->Debug(__PACKAGE__.'::RobotOption: Unknown RobotOption:', $option);
	return;
}

=head2 Name

=cut

sub Name($$) {
	return unless $#_ == 1;
	my ($self, $name) = @_;

	if($name) {
		$self->args($name);
		return 1;
	}

	$self->Debug(__PACKAGE__.'::Name: Invalid name:', $name);
	return;
}

=head2 Colour

=cut

sub Colour($$$) {
	return unless $#_ == 2;
	my ($self, $home, $away) = @_;

	if($home && $away) {
		$self->args($home, $away);
		return 1;
	}

	$self->Debug(__PACKAGE__.'::Colour: Invalid colour(s):', $home, $away);
	return;
}

=head2 Rotate

=cut

sub Rotate($$$) {
	return unless $#_ == 2;
	my ($self, $what, $vel) = @_;

	if( $what < 1 || $what > 7 || int($what) != $what ) {
		$self->Debug(__PACKAGE__.'::Rotate: Invalid object to rotate:', $what);
		return;
	}

	if(!$vel) {	#TODO check $vel properly (double)
		$self->Debug(__PACKAGE__.'::Rotate: Invalid angular velocity:', $vel);
		return;
	}

	$self->args($what, $vel);
	return 1;
}

=head2 RotateTo

=cut

sub RotateTo($$$$) {
	return unless $#_ == 3;
	my ($self, $what, $vel, $to) = @_;

	if( $what < 1 || $what > 7 || int($what) != $what ) {
		$self->Debug(__PACKAGE__.'::RotateTo: Invalid object to rotate:',
				$what);
		return;
	}

	if(!$vel) {	#TODO check $vel properly
		$self->Debug(__PACKAGE__.'::RotateTo: Invalid angular velocity:', $vel);
		return;
	}

	$self->args($what, $vel, $to);
	return 1;
}

=head2 RotateAmount

=cut

sub RotateAmount($$$$) {
	return unless $#_ == 3;
	my ($self, $what, $vel, $angle) = @_;

	if( $what < 1 || $what > 7 || int($what) != $what ) {
		$self->Debug(__PACKAGE__.'::RotateAmount: Invalid object to rotate:',
				$what);
		return;
	}

	if(!$vel) {	#TODO check $vel properly
		$self->Debug(__PACKAGE__.'::RotateAmount: Invalid angular velocity:',
				$vel);
		return;
	}


	if(!$angle) {	#TODO check $angle properly
		$self->Debug(__PACKAGE__.'::RotateAmount: Invalid angule:', $angle);
		return;
	}

	$self->args($what, $vel, $angle);
	return 1;
}

=head2 Sweep

=cut

sub Sweep($$$$$) {
	return unless $#_ == 4;
	my ($self, $what, $vel, $l, $r) = @_;

	if( $what < 1 || $what > 7 || int($what) != $what ) {
		$self->Debug(__PACKAGE__.'::Sweep: Invalid object to rotate:', $what);
		return;
	}

	if(!$vel) {	#TODO check $vel properly
		$self->Debug(__PACKAGE__.'::Sweep: Invalid angular velocity:', $vel);
		return;
	}

	if(!$l) {	#TODO check $l properly
		$self->Debug(__PACKAGE__.'::Sweep: Invalid left angle:', $l);
		return;
	}

	if(!$r) {	#TODO check $r properly
		$self->Debug(__PACKAGE__.'::Sweep: Invalid right angle:', $r);
		return;
	}

	$self->args($what, $vel, $l, $r);
	return 1;
}

=head2 Accelerate

=cut

sub Accelerate($$) {
	return unless $#_ == 1;
	my ($self, $val) = @_;

	if(!$val) {	#TODO check $val properly
		$self->Debug(__PACKAGE__.'::Accelerate: Invalid accelaration value:',
				$val);
		return;
	}

	$self->args($val);
	return 1;
}

=head2 Brake

=cut

sub Brake($$) {
	return unless $#_ == 1;
	my ($self, $val) = @_;

	if(!$val) {	#TODO check $val properly
		$self->Debug(__PACKAGE__.'::Accelerate: Invalid brake portion:', $val);
		return;
	}

	$self->args($val);
	return 1;
}

=head2 Shoot

=cut

sub Shoot($$) {
	return unless $#_ == 1;
	my ($self, $energy) = @_;

	if(!$energy) {	#TODO check $energy properly
		$self->Debug(__PACKAGE__.'::Shoot: Invalid energy value:', $energy);
		return;
	}

	$self->args($energy);
	return 1;
}

=head2 Print

=cut

sub Print($@) {
	my ($self, @msg) = @_;

	if(!@msg) {
		$self->Debug(__PACKAGE__.'::FromRobot::Print: no message given');
		return;
	}

	$self->args(@msg);
	return 1;
}

=head2 Debug

=cut

sub Debug($@) {
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

=head2 DebugLine

=cut

sub DebugLine($$$$$) {
	return unless $#_ == 4;
	my ($self, $angle1, $radius1, $angle2, $radius2) = @_;

	if(!$angle1) {	#TODO check $angle1 properly
		$self->Debug(__PACKAGE__.'::DebugLine: Invalid first angle:', $angle1);
		return;
	}

	if(!$radius1) {	#TODO check $radius1 properly
		$self->Debug(__PACKAGE__.'::DebugLine: Invalid first radius:',
				$radius1);
		return;
	}

	if(!$angle2) {	#TODO check $angle2 properly
		$self->Debug(__PACKAGE__.'::DebugLine: Invalid second angle:', $angle2);
		return;
	}

	if(!$radius2) {	#TODO check $radius2 properly
		$self->Debug(__PACKAGE__.'::DebugLine: Invalid second radius:',
				$radius2);
		return;
	}

	$self->args($angle1, $radius1, $angle2, $radius2);
	return 1;
}

=head2 DebugCircle

=cut

sub DebugCircle($$$$) {
	return unless $#_ == 3;
	my ($self, $angle, $center, $circle) = @_;

	if(!$angle) {	#TODO check $angle properly
		$self->Debug(__PACKAGE__.'::DebugCircle: Invalid center angle:',
				$angle);
		return;
	}

	if(!$center) {	#TODO check $center properly
		$self->Debug(__PACKAGE__.'::DebugCircle: Invalid center radius:',
				$center);
		return;
	}

	if(!$circle) {	#TODO check $circle properly
		$self->Debug(__PACKAGE__.'::DebugCircle: Invalid circle radius:',
				$circle);
		return;
	}

	$self->args($angle, $center, $circle);
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
