[![codecov](https://codecov.io/gh/fhem/lib_timer/branch/master/graph/badge.svg)](https://codecov.io/gh/fhem/lib_timer)
![](https://github.com//fhem/lib_timer/workflows/Perl%20Modules%26FHEM%20Unittests/badge.svg?branch=master)

Timer - FHEM lib 
======


FHEM lib  for developers who want to easy managing internalTimers



How to install
======
update all https://raw.githubusercontent.com/fhem/lib_timer/master/controls_libtimer.txt

How To use this?
=====

Import the package into your package directly or via eval as needed:
`use FHEM::Timer::Helper;` or `eval { use FHEM::Timer::Helper;1 } ;`

Instead of calling InternalTimer you add the Timer with this command:
InternalTimer($name,$timestamp, $coderef, $arg, $waitIfInitNotDone);
Example:
`FHEM::Timer::Helper::addTimer($hash{NAME}, time(), \&someSub,"paramsGoesHere",0 );`

$name                 mandatory   A name or identifier to specify for this Timer
$timestamp            mandatory   Unix timestamp when the timer should run
$functionName         mandatory   Is a codref to some code to run / call after $timestamp is reached
$arg                  optional    Arguments you pass to the coderef, default = {}
$waitIfInitNotDone    operional   Blocks FHEM until $timestamp is reached, use it only if really needed
