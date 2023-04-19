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
		Speed: _speed,
		Temp: false
	}
}

// Add a temporary timer that will be deleted once finished
// Note: this function also returns the randomly generated timerName
function ftimerTemp(_frames, _speed = 1)
{
	var _timerName = _randomizeTN();
	var exists = variable_struct_exists(global.fTimers, _timerName);
	while exists
	{
		_timerName = _randomizeTN();
		exists = variable_struct_exists(global.fTimers, _timerName);
	}
	
	global.fTimers[$ _timerName] = 
	{
		Frames: _frames,
		Speed: _speed,
		Temp: true
	}
	return _timerName;
}

// Generates a random name for the function ftimerTemp
function _randomizeTN() {
	var chars = "abcdefghijklmnopqrstuvwxyz0123456789#@!$"
	var _timerName = ""
	for (var i=0; i < 10; i++) {
		var char = string_char_at(chars, irandom_range(0, 39))
		_timerName += char;
	}
	return _timerName;
}

// Change the speed of a running timer
function ftimerSetSpeed(_timerName, _speed) { global.fTimers[$ _timerName] = { Speed: _speed } }

// Checks the status of the specified timer. If the timer has ended it will return false, otherwise it will return true.
function ftimerStatus(_timerName)
{
	if (global.fTimers[$ _timerName].Frames <= 0
		or !variable_struct_exists(global.fTimers, _timerName)) { return false; }
	else { return true; }
}

// Remove an existing timer from the fTimers struct
function ftimerRemove(_timerName)
{
	variable_struct_remove(global.fTimers, _timerName);
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
		if (global.fTimers[$ k].Frames <= 0 and global.fTimers[$ k].Temp) { ftimerRemove(k); }
	}
}