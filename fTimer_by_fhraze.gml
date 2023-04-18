/// A more versatile alternative to GameMaker's alarms
/// by Fhraze
//
global.fTimers = {}

// Add a new timer or modify an existing one
function ftimer(_timerName, _frames = 0, _speed = 1)
{
	global.fTimers[$ _timerName] = 
	{
		Frames: _frames,
		Speed: _speed
	}
}

// Change the speed of a running timer
function ftimerSetSpeed(_timerName, _speed) { global.fTimers[$ _timerName] = { Speed: _speed } }

// Checks the status of the specified timer. If the timer has ended it will return false, otherwise it will return true.
function ftimerStatus(_timerName)
{
	if global.fTimers[$ _timerName].Frames <= 0 { return false; }
	else { return true; }
}

// Get current time left in a timer
function ftimerGetFrames(_timerName) { return global.fTimers[$ _timerName].Frames; }

// fTimer's step event.
function ftimerStep()
{
	var keys = variable_struct_get_names(global.fTimers);	
	for (var i = array_length(keys)-1; i >= 0; --i)
	{
	    var k = keys[i];
		var _speed = global.fTimers[$ k].Speed
		if global.fTimers[$ k].Frames > 0 { global.fTimers[$ k].Frames -= _speed; }
	}
}