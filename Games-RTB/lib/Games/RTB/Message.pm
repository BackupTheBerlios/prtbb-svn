#!/usr/bin/perl

package Games::RTB::Message;

use strict;
use warnings;
use vars qw( $VERSION );
use Switch;
use Games::RTB::Type qw( :types );

$VERSION = 0.01;

=head1 NAME

Games::RTB::Message - Message class prototype for messages from or to
RealTimeBattle Bots

=head1 SYNOPSIS

  package My::Message::Class;
  use Games::RTB::Message;
  @ISA = qw( Games::RTB::Message );
  ...
  sub init {
    ...
  }
  sub my_method {
    ...
  }

  package main;
  use My::Message::Class;
  $msg = My::Message::Class->new();
  ...
  if($msg->type() eq "foo") {
    $msg->args("bar");
    $msg->my_method();
  }
  ...
  $msg->send();

=head1 DESCRIPTION

Games::RTB::Message provides a prototype class for other message classes to use
with the RealTimeBattle game i.e. Games::RTB::Message::FromRobot and
Games::RTB::Message::ToRobot. It provides basic methods needed by any message
type.

=head1 METHODS

=head2 new

  $msg = Games::RTB::Message->new();
  $msg = Games::RTB::Message->new( type => 'bar', debug => 1 );
  $msg = Games::RTB::Message->new( type => 'foo', args => [qw( a b c )] );

Games::RTB::Message object constructor. new() invokes the init() method with
all its parameters and returns a reference to the object or undef if init()
returned a false value. Every message needs a type. If there's no type given
'empty' is used.

=cut

sub new($;@) {
	my ($this, @args) = @_;
	my $class = ref($this) || $this;
	my $self = {
		type	=> 'empty',
		args	=> [ ],
		debug	=> 0
	};
	bless $self, $class;
	return $self->init(@args) ? $self : undef;
}

=head2 init

This method is intended to be overwritten by inheriting classes and should do
the _real_ work during the creation of the object. It gets all arguments from
the new method and should return a true value if the initialisation succeeded or
undef if not. init() shouldn't be called by anybody else than the new() method.

=cut

sub init($%) {
	my ($self, %args) = @_;
	# override by inheriting classes
}

=head2 send

  $msg->send()

This method sends the message to STDOUT so that it can be received by the
RealTimeBattle game engine.

=cut

sub send($) {
	my $self = shift;
	print $self->type, ' ', join(' ', map { $_->as_string } $self->args), "\n";
}

=head2 type

  my $type = $msg->type();
  $msg->type('foobar');

This method returns the messages type if there's no argument given or sets a new
message type. This method may be overritten by inheritants to implement
type-checking, etc.

=cut

sub type($;$) {
	my ($self, $type) = @_;
	if($type) {
		$self->{type} = $type;
	} else {
		return $self->{type};
	}
}

=head2 args

  my @args = $msg->args();
  $msg->args(qw( a b c ));

Access method for the args property. Returns the current args array if there are
no arguments given or sets the args property if there are any arguments given.

=cut

sub args($;@) {
	my ($self, @args) = @_;
	if(@args) {
		$self->{args} = [ @args ];
	} else {
		return @{$self->{args}};
	}
}

sub make_args($$$) {
	my ($self, $types, $args) = @_;
	my (@args, $i);

	for($i = 0; $i < @{$types}; $i++) {
		my $arg;
		my $type = @{ $types }[$i];
		switch($type) {
			case 'Int'		{ $arg = RTB_INT( @{$args}[$i] ); }
			case 'String'	{ $arg = RTB_STRING( @{$args}[$i] ); }
			case 'Hex'		{ $arg = RTB_HEX( @{$args}[$i] ); }
			case 'Double'	{ $arg = RTB_DOUBLE( @{$args}[$i] ); }
			case 'Angle'	{ $arg = RTB_ANGLE( @{$args}[$i] ); }
			else			{ return; }
		}

		return if !$arg;
		push(@args, $arg);
	}

	$self->args(@args);
}

=head2 debug

  my $debug = $msg->debug();
  $msg->debug(1);

Sets or returns the debug property of there's either an argument given or not.

=cut

sub debug($;$) {
	my ($self, $val) = @_;
	if($val) {
		$self->{debug} = $val;
	} else {
		return $self->{debug};
	}
}

=head1 AUTHOR

Florian Ragwitz <florian@mookooh.org>

=head1 COPYRIGHT

(C) 2004 Florian Ragwitz

=head1 LICENSE

This code is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

=head1 SEE ALSO

Games::RTB, Games::RTB::Message::ToRobot, Games::RTB::Message::FromRobot

=cut

1;
