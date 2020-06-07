# $Id$
package FHEM::timer::helper;
use strict;
use warnings;
use utf8;
use Carp qw(croak carp);





my @AOT=();  # ArrayOfTimers

sub addTimer {
	my $defName 	= shift // carp 'No definition name';
	my $time 		= shift	// carp q[No time specified];
	my $func 		= shift	// carp q[No function specified];
	my $arg 		= shift	// q{};
	my $initFlag 	= shift	// 0;
	
	::InternalTimer($time, $func, $arg, $initFlag);      
	
	my %h = (
			defName => $defName, 
			arg 	=> $arg, 
			func 	=> $func,
		);
	return push  @AOT, \%h ;
}


sub removeTimer {
	my $defName 	= shift // carp q[No definition name];
	my $func 		= shift	// undef;
	my $arg 		= shift	// q{};

    for my $index (0 .. $#AOT) {
     	if ($AOT[$index]->{defName} eq $defName 
			&& ( !defined $func || $AOT[$index]->{func} eq $func ) 
			&& ( $arg eq q{} 	|| $AOT[$index]->{arg}	eq $arg) 
		   ) {
			::RemoveInternalTimer($AOT[$index]->{arg},$AOT[$index]->{func});
			delete($AOT[$index]);
		}  
    }
}

1;