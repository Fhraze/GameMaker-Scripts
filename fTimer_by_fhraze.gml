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
function ftimer_temp(_frames, _speed = 1)
{
	var _timerName = random_str();
	var exists = variable_struct_exists(global.fTimers, _timerName);
	while exists
	{
		_timerName = random_str();
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
function random_str() {
	var chars = "abcdefghijklmnopqrstuvwxyz0123456789#@!$"
	var str = ""
	for (var i=0; i < 10; i++) {
		var char = string_char_at(chars, irandom_range(0, 39))
		str += char;
	}
	return str;
}

// Change the speed of a running timer
function ftimer_set_speed(_timerName, _speed) { global.fTimers[$ _timerName].Speed = _speed }

// Checks the status of the specified timer. If the timer has ended it will return false, otherwise it will return true.
function ftimer_status(_timerName)
{
	if variable_struct_exists(global.fTimers, _timerName)
	{
		if global.fTimers[$ _timerName].Frames > 0 { return true; }
		else return false;
	}
	else return false;
}

// Remove an existing timer from the fTimers struct
function ftimer_remove(_timerName)
{
	variable_struct_remove(global.fTimers, _timerName);
}

// Get current time left in a timer
function ftimer_get_frames(_timerName) { return global.fTimers[$ _timerName].Frames; }

// fTimer's step event.
function ftimer_step()
{
	var keys = variable_struct_get_names(global.fTimers);	
	for (var i = array_length(keys)-1; i >= 0; --i)
	{
	    var k = keys[i];
		var _speed = global.fTimers[$ k].Speed
		if global.fTimers[$ k].Frames >= 0 { global.fTimers[$ k].Frames -= _speed; }
		if global.fTimers[$ k].Frames < 0 { global.fTimers[$ k].Frames = 0; }
		if (global.fTimers[$ k].Frames <= 0 and global.fTimers[$ k].Temp) { ftimer_remove(k); }
	}
}
