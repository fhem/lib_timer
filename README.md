[![codecov](https://codecov.io/gh/fhem/lib_timer/branch/master/graph/badge.svg)](https://codecov.io/gh/fhem/lib_timer)
![Repository CI Workflow](https://github.com/fhem/lib_timer/workflows/Repository%20CI%20Workflow/badge.svg)

Timer - FHEM lib 
======

FHEM lib  for developers who want to easy managing internalTimers

This Package, uses FHEM InternalTimer function, to add timers under a given identifier
With removeTimer there is an option to remove all timers belonging to this identifier.
So no need to manage this by your own, what timers where started.

How to install
======

Issue `update all https://raw.githubusercontent.com/fhem/lib_timer/master/controls_libtimer.txt` at the FHEM command line

How To use this?
=====

### Load Package

Load the package into your package directly or via eval as needed:
`use FHEM::Core::Timer::Helper;`

or 

`eval { use FHEM::Core::Timer::Helper;1 } ;`

### Function overview

Function overview:
| Function        | Description  |
| :-------------- |:------------ | 
| `addTimer()`    | Adds a timer |
| `removeTimer()` | Removes a timer |
| `optimizeLOT()` | Optimizes internal data storage to reduce memory overhead |

### addTimer

Instead of calling FHEMs `InternalTimer()` you can add a timer with `addTimer()`:

**addTimer($name,$timestamp, $function_ref, $arg, $waitIfInitNotDone);**

Example:

`FHEM::Core::Timer::Helper::addTimer( $hash{NAME}, time(), \&do_something, { argument => q{value} }, 0 );`

| Parameter             | Required?   | Description  |
| :---------------------|:----------- | :----------  |
| `$name`               | mandatory   | A label for this timer|
| `$timestamp`          | mandatory   | Unix timestamp when the timer should run|
| `$function_ref`       | mandatory   | Is a codref to some code to run / call if `$timestamp` is reached|
| `$arg`                | optional    | Arguments passed to the `$function_ref`, default = `q{}`(empty string) |
| `$waitIfInitNotDone`  | optional    | **Blocks** FHEM until `$timestamp` is reached, use it only if really needed|

Returnvalue:
Returns Index of added timer to specify it later user directly

### getTimerByIndex
If you need all your passed arguments for a timer identified by a index you can use this function.

**getTimerByIndex($name,$index);**

Example:

`FHEM::Core::Timer::Helper::getTimerByIndex( $hash{NAME}, 2);`

| Parameter             | Required?   | Description  |
| :---------------------|:----------- | :----------  |
| `$name`               | mandatory   | A label for this timer|
| `$index`              | mandatory   | The index under which the timer was added |

Returnvalue:
Returns hashref with fields 
'arg' which is the passed arg via addTimer, 
'func' which is a coderef passed via function_ref arg via addTimer, 
'calltime' which is timestamp passed via timestamp arg via addTimer and
'initglag' which is value for initflag spcified via addTimer.



### removeTimer

Instead of calling RemoveInternalTimer you can remove Timers with this command:

**removeTimer($name,$function);** 

Example:
`  FHEM::Core::Timer::Helper::removeTimer($name); ` to delete all timers which are added via `addTimer($name,...);`

| Parameter        | Required?      | Description  |
| :--------------- | :------------- | :------------|
| `$name`          | mandatory      | Remove timers with the name `$name` |
| `$function_ref`  | optional       | Remove only timers with name `$name` and set by `$function_ref` |
| `$arg`           | optional       | Remove only timers with name `$name` and set with `$arg` |


### renewTimer
Call 'renewTimer' if you want to rescedule a timer which is or is not called already.

Example:
`  FHEM::Core::Timer::Helper::renewTimer($timerHash,gettimeofday+3600); ` updates the given timer to run in a hour from now`


| Parameter        | Required?      | Description  |
| :--------------- | :------------- | :------------|
| `$TimerHash`     | mandatory      | You can gather this hash from getTimerByIndex |
| `$newtime`       | mandatory      | Unix timestamp when the timer should run |
 
returns `undef`  on failure or `1` if timer is added with new timestamp

### optimizeLOT

Call `optimizeLOT()` if some of the timers are finished to free up some memory:

**optimizeLOT($name);** 

Example:
`FHEM::Core::Timer::Helper::optimizeLOT(q{my_timer);`

| Parameter     | Required? | Description |
| :------------ | :-------  | :---------- |
| `$name`       | mandatory | Delete timers with name `$name` |
