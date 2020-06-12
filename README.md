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
### Load Package

Load the package into your package directly or via eval as needed:
`use FHEM::Core::Timer::Helper;`

or 

`eval { use FHEM::Core::Timer::Helper;1 } ;`

### Function overview

Function overview:
| function     | description  |
| ------------- |:-------------:| 
| addTimer    | add a timer |
| removeTimer | removes a timer |
| optimizeLOT | optimizes internal data storage to reduce memory overhead |

### addTimer

Instead of calling InternalTimer you add the Timer with this command:

**addTimer($name,$timestamp, $coderef, $arg, $waitIfInitNotDone);**

Example:
`FHEM::Core::Timer::Helper::addTimer( $hash{NAME}, time(), \&do_something, { argument => q{value} }, 0 );`
| parameter     | required | description  |
| ------------- |:-------------:| -----:|
| $name                 |mandatory   | A label for this timer|
| $timestamp            |mandatory   | Unix timestamp when the timer should run|
| $function_ref         |mandatory   | Is a codref to some code to run / call if `$timestamp` is reached|
| $arg                  |optional    | Hash with arguments, passed to the `$function_ref`, default = `{}`(empty hash) |
| $waitIfInitNotDone    |optional    | **Blocks** FHEM until `$timestamp` is reached, use it only if really needed|


### removeTimer

Instead of calling RemoveInternalTimer you can remove Timers with this command:

**removeTimer($name,$function);** 

Example:
`  FHEM::Core::Timer::Helper::removeTimer($name); ` to delete all timers which are added via `addTimer($name,...);`
| parameter     | required | description  |
| ------------- |:-------------:| -----:|
| $name                 |mandatory   |Search filter of added timers under $name |
| $functionRef          |optional    |filters to timers which are referencing to this codered |
| $arg                  |optional    |filters to arguments which are passed to a internaltimer |

### optimizeLOT

Call optimizeLOT if some of the timers are finished to clean up some memory:

**optimizeLOT($name);** 
Example:
`  FHEM::Core::Timer::Helper::optimizeLOT($name); ` to delete all old timers`

| parameter     | required | description  |
| ------------- |:-------------:| -----:|
| $name                 |mandatory   | filter of added timers under $name |
