#!/usr/bin/perl

use strict;
use warnings;
use lib qw( lib ../lib );
use Games::RTB::Message::FromRobot;
use Data::Dumper;

my $msg = Games::RTB::Message::FromRobot->new(
		debug=> 1,
		type => 'Name',
		args => [qw( godsmacker )]
) or die 'Couldn\'t create Message object.';

print Dumper($msg);

$msg->send();
