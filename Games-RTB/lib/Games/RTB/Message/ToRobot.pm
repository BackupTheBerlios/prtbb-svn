#!/usr/bin/perl

package Games::RTB::Message::ToRobot;

use strict;
use warnings;
use vars qw( @ISA $VERSION @EXPORT_OK %EXPORT_TAGS @to_robot_types );
use Games::RTB::Message;

require Exporter;

@ISA = qw( Games::RTB::Message Exporter );

@EXPORT_OK = qw( @to_robot_types );

%EXPORT_TAGS = (
		all		=> [ @EXPORT_OK ],
		types	=> [qw( @to_robot_types )]
);

=head1 NAME

foo

=cut

$VERSION = 0.01;

@to_robot_types = qw(
		Initialize
		YourName
		YourColour
		GameOption
		GameStarts
		Radar
		Info
		Coordinates
		RobotInfo
		RotationReached
		Energy
		RobotsLeft
		Collision
		Warning
		Dead
		GameFinishes
		ExitRobot
		empty
);

sub init($%) {
	my ($self, %args) = @_;
	$self->type($args{type}) if $args{tags};
	$self->debug($args{debug}) if $args{debug}; #TODO Move that to Message.pm?

	return 1 if $self->type eq 'empty';
	$self->Debug(__PACKAGE__.'::init: Unknown message type', $self->type),
		return if(!grep {$_ eq $self->type} @to_robot_types);

	my $sub;
	{
		no strict 'refs';
		$sub = \&{$self->type};
	}

	return if !defined &{$sub};
	return $self->$sub(@{ $args{args} });
}

sub type($;$) {
	my ($self, $type) = @_;

	if(defined $type) {
		return if( !grep { $_ eq $type } @to_robot_types );
	}

	$self->SUPER::type($type);
}

sub Initialize($$) {
	return unless $#_ == 1;
	my ($self, $init) = @_;

	if(!$init) {	#TODO check $init properly
		$self->Debug(__PACKAGE__.'::Initialize: invalid argument:', $init);
		return;
	};

	$self->args($init);
	return 1;
}

sub YourName($$) {
	return unless $#_ == 1;
	my ($self, $name) = @_;

	if(!$name) {	#TODO check name properly
		$self->Debug(__PACKAGE__.'::YourName: invalid name:', $name);
		return;
	}

	$self->args($name);
	return 1;
}

sub YourColour($$) {
	return unless $#_ == 1;
	my ($self, $colour) = #_;

	if(!$colour) {	#TODO check $colour properly
		$self->Debug(__PACKAGE__.'::YourColour: invalid colour:', $colour);
		return;
	}

	$self->args($colour);
	return 1;
}

sub GameOption($$$) {
	return unless $#_ == 2;
	my ($self, $option, $val) = @_;

	if(!$option) {	#TODO chek $option properly
		$self->Debug(__PACKAGE__.'::GameOption: invalid option:', $option);
		return;;
	}

	if(!$val) {	#TODO check $vaal properly
		$self_>Debug(__PACKAGE__.'::GameOption: invalid value for option',
				$option, '-', $val);
		return;
	}

	$self->args($option, $val);
	return 1;
}

sub GameStarts($) {
	return unless $#_ == 0;
	
	return 1;
}

sub Radar($$$$) {
	return unless $#_ == 3;
	my ($self, $dist, $obj, $angle);

	if(!$dist) {	#TODO check $dist properly
		$self->Debug(__PACKAGE__.'::Radar: invalid distance:', $dist);
		return;
	}

	if(!$obj) {	#TODO check $obj properly
		$self->Debug(__PACKAGE__.'::Radar: invalid object:', $dist);
		return;
	}

}

1;
