#!/usr/bin/env perl
use strict;
use warnings;

use Test2::V0;
use Test2::Tools::Compare qw{is};


use FHEM::timer::helper;
use Time::HiRes;


sub timerCallback
{
	my $arg = shift;

		
	is ($arg,'addTimer test',"Check argument");
	done_testing();
	exit(0);
}


sub timerCallback2
{
	fail('this timerCallback2 should never be called');
}

	
my $count = FHEM::timer::helper::addTimer('myName',gettimeofday+2,\&timerCallback,'addTimer test',0);
is ($count,1,'addtimer returned one');
$count = FHEM::timer::helper::addTimer('myName',gettimeofday+1,\&timerCallback2,'remove timer test',0);
is ($count,2,'addtimer returned two');


FHEM::timer::helper::removeTimer('myName');

$count = FHEM::timer::helper::addTimer('myName',gettimeofday+2,\&timerCallback,'addTimer test',0);
is ($count,1,'addtimer returned one');


1;