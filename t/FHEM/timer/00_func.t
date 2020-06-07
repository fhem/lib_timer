#!/usr/bin/env perl
use strict;
use warnings;

use Test2::V0;
use Test2::Tools::Compare qw{is};


use FHEM::Timer::Helper;
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
	fail('this callback should never be called');
}

	
my $count = FHEM::Timer::Helper::addTimer('myName',gettimeofday+2,\&timerCallback,'addTimer test',0);
$count = FHEM::Timer::Helper::addTimer('myName',gettimeofday+1,\&timerCallback2,'remove timer test',0);
is(@FHEM::Timer::Helper::AOT,$count,'array has element');

FHEM::Timer::Helper::removeTimer('myName');

is(@FHEM::Timer::Helper::AOT,0,'array has no element');
$count = FHEM::Timer::Helper::addTimer('myName',gettimeofday+2,\&timerCallback,'addTimer test',0);

1;