# $Id$
package FHEM::Core::Timer::Helper;
use strict;
use warnings;
use utf8;
use Carp qw(croak carp);
use Time::HiRes;

use version; our $VERSION = qv('1.0.0');
my %LOT;  # Hash for ListOfTimers

use Exporter qw(import);
 
our @EXPORT_OK = qw(addTimer removeTimer optimizeLOT getTimerByIndex renewTimer); 

sub addTimer {
	my $defName 	= shift // carp 'No definition name'	 	&& return;
	my $time 		= shift	// carp q[No time specified] 		&& return;
	my $func 		= shift	// carp q[No function specified] 	&& return;
	my $arg 		= shift	// q{};
	my $initFlag 	= shift	// 0;
	
	
	my %h = (
			arg		 	=> $arg, 
			func 		=> $func,
			calltime 	=> $time,
			initflag 	=> $initFlag,
	);

	
	::InternalTimer($h{calltime}, $h{func}, $h{arg} , $h{initflag});      

    return (push @{$LOT{$defName}} , \%h) -1; # Returns Index of added timer, not anymore number of added timers
}

sub getTimerByIndex{
    my $defName 	= shift // carp q[No definition name];
    my $index 		= shift	// carp q[No index defined];

    return $LOT{$defName}[$index] if ( exists $LOT{$defName}[$index] );
}

sub renewTimer {
    my $TimerHash   = shift ;
    my $newtime 	= shift	// carp q[No new time specified] && return;
    
    if ( !ref($TimerHash) eq 'HASH' || !exists ($TimerHash->{arg}) || !exists ($TimerHash->{func}) || !exists ($TimerHash->{calltime}) ) 
    {
        carp q[No valid timerhash as argument specified, aborting removeTimer];
        return ;
    }

    ::RemoveInternalTimer($TimerHash->{arg},$TimerHash->{func});
    ::InternalTimer($newtime, $TimerHash->{func}, $TimerHash->{arg} , $TimerHash->{initFlag});      

    $TimerHash->{calltime}=$newtime;
    return 1;
}

sub removeTimer {
	
	my $defName 	= shift // carp q[No definition name];
	my $func 		= shift	// undef;
	my $arg 		= shift	// q{};

	return 0 if ( !exists $LOT{$defName} );
	
	my $numRemoved	=	0;
    for my $index (0 .. scalar @{$LOT{$defName}}-1 ) {
     	if ( ref $LOT{$defName}[$index] eq 'HASH' && exists	$LOT{$defName}[$index]->{func}
     		&&	(!defined $func 		|| $LOT{$defName}[$index]->{func} 		== $func ) 
			&& 	( $arg eq q{} 			|| $LOT{$defName}[$index]->{arg}		eq $arg) 
		   ) {
			::RemoveInternalTimer($LOT{$defName}[$index]->{arg},$LOT{$defName}[$index]->{func});
			delete($LOT{$defName}[$index]);
			$numRemoved++;
		}  
    }
    return $numRemoved;
}


sub optimizeLOT
{
	my $defName 	= shift // carp q[No definition name];
	return 0 if ( !exists $LOT{$defName} );
	
	my $now= ::gettimeofday();
	@{$LOT{$defName}} = grep {  $_->{calltime} >= $now  } @{$LOT{$defName}};

	return scalar @{$LOT{$defName}};
}

1;