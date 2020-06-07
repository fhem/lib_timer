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

		
	is ($arg,'timer called test',"Check argument");
	done_testing();
	exit(0);
}


sub timerCallback2
{
	fail('this timerCallback2 should never be called');
}
my $count;

subtest 'Add two timers ' => sub {
	$count = FHEM::timer::helper::addTimer('myName',gettimeofday+2,\&timerCallback,'addTimer test',0);
	is ($count,1,'addtimer returned one');
	$count = FHEM::timer::helper::addTimer('myName',gettimeofday+1,\&timerCallback2,'remove timer test',0);
	is ($count,2,'addtimer returned two');

};


subtest 'Remove all timers for myName' => sub {
	is(FHEM::timer::helper::removeTimer('myName'),2,'check number of removed timers');
};

subtest 'add Timer for myName to end test in 2 secs' => sub {
	is(FHEM::timer::helper::addTimer('myName',gettimeofday+2,\&timerCallback,'timer called test',0),1,'one timer in list');
};


subtest 'add and remove timer by callback func' => sub {
	$count = FHEM::timer::helper::addTimer('myName',gettimeofday+1,\&timerCallback2,'addTimer test',0);
	is ($count,2,'addtimer returned two');
	is(FHEM::timer::helper::removeTimer('myName',\&timerCallback2),1,'check number of removed timers');
};


subtest 'add and remove timer by arg' => sub {
	$count = FHEM::timer::helper::addTimer('myName',gettimeofday+1,\&timerCallback2,'addTimer test',0);
	$count = FHEM::timer::helper::addTimer('myName',gettimeofday+1,\&timerCallback,'addTimer test',0);
	is ($count,3,'addtimer returned three');
	is(FHEM::timer::helper::removeTimer('myName',undef,'addTimer test'),2,'check both added timers with arg are removed');
};

subtest 'add and remove timer by callback func and arg' => sub {
	$count = FHEM::timer::helper::addTimer('myName',gettimeofday+1,\&timerCallback2,'addTimer test',0);
	$count = FHEM::timer::helper::addTimer('myName',gettimeofday+1,\&timerCallback2,'other arg',0);
	is ($count,3,'addtimer returned three');
	is(FHEM::timer::helper::removeTimer('myName',\&timerCallback2,'addTimer test'),1,'check only one timer removed');
	is(FHEM::timer::helper::removeTimer('myName',\&timerCallback2,'other arg'),1,'check only one timer removed');
};

1;