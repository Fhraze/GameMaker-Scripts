/// Tag-based animtaion system
/// by Fhraze
//
global.tags = {}

// Adds an animation tag to the tags struct
function animation_add(_tag, _sprite, _startFrame, _endFrame, _xscale = 1, _yscale = 1)
{
	global.tags[$ _tag] =
	{
		sprite: _sprite,
		startFrame: _startFrame,
		endFrame: _endFrame,
		xScale: _xscale,
		yScale: _yscale,
		repeatAmmount: 0,
		iterations: 0
	}
}

// Adds a finite animation tag to the tags struct
function animation_add_finite(_tag, _sprite, _startFrame, _endFrame, _repeatAmmount = 1, _xscale = 1, _yscale = 1)
{
	global.tags[$ _tag] =
	{
		sprite: _sprite,
		startFrame: _startFrame,
		endFrame: _endFrame,
		xScale: _xscale,
		yScale: _yscale,
		repeatAmmount: _repeatAmmount,
		iterations: 0
	}
	
}

// Delete a tag from the tags struct
function animation_remove(_tag) { variable_struct_remove(global.tags, _tag) }

function animation_set(_tag, _xscale = 1, _yscale = 1)
{
	if !variable_instance_exists(id, "currentAnimation") { variable_instance_set(id, "currentAnimation", _tag); }
	else { currentAnimation = _tag; }
	global.tags[$ _tag].xScale = _xscale;
	global.tags[$ _tag].yScale = _yscale;
}

// Reset animation's image_index and speed
function animation_reset(_speed = 1)
{
	if variable_instance_exists(id, "currentAnimation")
	{
		image_speed = _speed
		if _speed < 0 { image_index = global.tags[$ currentAnimation].endFrame }
		else { image_index = global.tags[$ currentAnimation].startFrame }
	}
}

// Returns current animation tag
function animation_get()
{
	if variable_instance_exists(id, "currentAnimation") { return currentAnimation; }
}

// animation_system's step event
function animation_step(_speed = 1)
{
	if variable_instance_exists(id, "currentAnimation")
	{
		image_xscale = global.tags[$ currentAnimation].xScale;
		image_yscale = global.tags[$ currentAnimation].yScale;
		object_set_sprite(self, global.tags[$ currentAnimation].sprite);
		var _image_index = floor(image_index)
		var _startFrame = global.tags[$ currentAnimation].startFrame;
		var _endFrame = global.tags[$ currentAnimation].endFrame;
		var _repeatAmmount = global.tags[$ currentAnimation].repeatAmmount;
		image_speed = _speed;
		
		if _speed < 0
		{
			if _repeatAmmount > 0 and _image_index == _startFrame
			{
				if global.tags[$ currentAnimation].iterations >= _repeatAmmount { image_speed = 0 }
				else { global.tags[$ currentAnimation].iterations++ }
			}
			if _image_index < _startFrame or _image_index > _endFrame
			{
				image_index = _endFrame;
			}
		}
		else
		{
			if _repeatAmmount > 0 and _image_index == _endFrame
			{
				if global.tags[$ currentAnimation].iterations >= _repeatAmmount { image_speed = 0 }
				else { global.tags[$ currentAnimation].iterations++ }
			}
			if _image_index < _startFrame or _image_index > _endFrame
			{
				image_index = _startFrame;
			}
		}
	}
}