/// Script that manages the camera position in-game
/// by Fhraze
/*

  Please note that this script works by managing Game Maker's
viewports and cameras that need to be properly configured
for each room of your game.

  There are 7 different types of camera which can be set
using their respective set function. If you don't know what
a camera type does, just search for its function in the script,
the function's description will be right on top of it.

*/

#macro MOUSE_X obj_aim.x //mouse_x
#macro MOUSE_Y obj_aim.y //mouse_y
#macro DEFAULT_CURSOR_INFLUENCE_REDUCTION 10
//   The higher the influence reduction, the less influence
// the cursor will have on the camera position
#macro DEFAULT_CAMERA_INDEX 0
#macro DEFAULT_CAMERA_SPEED 0.03125
// Recommended camera speed values:
// 0.5
// 0.25
// 0.125
// 0.0625
// 0.03125
#macro DEFAULT_SHAKE_TIME 0
#macro DEFAULT_SHAKE_MAGNITUDE 10
#macro DEFAULT_SHAKE_FADE 0.25

global.cameraStruct =
{
	type: noone, // Available types: "follow", "snapFollow", "softFollow" and "scene"
	obj: noone,
	camX: noone,
	camY: noone,
	cameraIndex: DEFAULT_CAMERA_INDEX,
	cameraSpeed: DEFAULT_CAMERA_SPEED,
	cursorInfluenceReduction: DEFAULT_CURSOR_INFLUENCE_REDUCTION,
	lastX: noone,
	lastY: noone,
	fixedX: noone,
	fixedY: noone,
	shakeTime: 0,
	shakeMagnitude: DEFAULT_SHAKE_MAGNITUDE,
	shakeFade: DEFAULT_SHAKE_FADE,
	shake: false
}

// Start a screen shake
function camera_shake(_shakeFade = DEFAULT_SHAKE_FADE, _shakeMagnitude = DEFAULT_SHAKE_MAGNITUDE, _shakeTime = DEFAULT_SHAKE_TIME)
{
	global.cameraStruct.shakeTime = _shakeTime;
	global.cameraStruct.shakeMagnitude = _shakeMagnitude;
	global.cameraStruct.shakeFade = _shakeFade;
	global.cameraStruct.shake = true
}

// Set camera to snap to an object, but slightly attracted by the mouse cursor
function set_camera_follow(_followedObject, _cameraIndex = DEFAULT_CAMERA_INDEX, _fixedX = noone, _fixedY = noone, _cursorInfluenceReduction = DEFAULT_CURSOR_INFLUENCE_REDUCTION)
{
	global.cameraStruct.type = "follow";
	global.cameraStruct.obj = _followedObject;
	global.cameraStruct.cameraIndex = _cameraIndex;
	global.cameraStruct.cursorInfluenceReduction = _cursorInfluenceReduction;
	global.cameraStruct.fixedX = _fixedX;
	global.cameraStruct.fixedY = _fixedY;
}

// Set camera to snap to an object
function set_camera_snap_follow(_followedObject, _cameraIndex = DEFAULT_CAMERA_INDEX, _fixedX = noone, _fixedY = noone)
{
	global.cameraStruct.type = "snapFollow";
	global.cameraStruct.obj = _followedObject;
	global.cameraStruct.cameraIndex = _cameraIndex;
	global.cameraStruct.fixedX = _fixedX;
	global.cameraStruct.fixedY = _fixedY;
}

// Set camera to slowly follow an object
function set_camera_soft_follow(_followedObject, _cameraIndex = DEFAULT_CAMERA_INDEX, _fixedX = noone, _fixedY = noone, _cameraSpeed = DEFAULT_CAMERA_SPEED)
{
	global.cameraStruct.type = "softFollow";
	global.cameraStruct.obj = _followedObject;
	global.cameraStruct.cameraIndex = _cameraIndex;
	global.cameraStruct.fixedX = _fixedX;
	global.cameraStruct.fixedY = _fixedY;
	if(global.cameraStruct.lastX == noone)
	{
		global.cameraStruct.lastX = global.cameraStruct.obj.x - camera_get_view_width(view_camera[global.cameraStruct.cameraIndex]) * 0.5;
		global.cameraStruct.lastY = global.cameraStruct.obj.y - camera_get_view_height(view_camera[global.cameraStruct.cameraIndex]) * 0.5;
	}
}

// Set camera to slowly follow an object, but slightly attracted by the mouse cursor
function set_camera_extra_soft_follow(_followedObject, _cameraIndex = DEFAULT_CAMERA_INDEX, _fixedX = noone, _fixedY = noone, _cameraSpeed = DEFAULT_CAMERA_SPEED, _cursorInfluenceReduction = DEFAULT_CURSOR_INFLUENCE_REDUCTION)
{
	global.cameraStruct.type = "extraSoftFollow";
	global.cameraStruct.obj = _followedObject;
	global.cameraStruct.cameraIndex = _cameraIndex;
	global.cameraStruct.cursorInfluenceReduction = _cursorInfluenceReduction;
	global.cameraStruct.fixedX = _fixedX;
	global.cameraStruct.fixedY = _fixedY;
	if(global.cameraStruct.lastX == noone)
	{
		global.cameraStruct.lastX = global.cameraStruct.obj.x - camera_get_view_width(view_camera[global.cameraStruct.cameraIndex]) * 0.5;
		global.cameraStruct.lastY = global.cameraStruct.obj.y - camera_get_view_height(view_camera[global.cameraStruct.cameraIndex]) * 0.5;
	}
}

// Set camera to be fixed at a scene
function set_camera_scene(_sceneX, _sceneY, _cameraIndex = DEFAULT_CAMERA_INDEX)
{
	global.cameraStruct.type = "scene";
	global.cameraStruct.camX = _sceneX;
	global.cameraStruct.camY = _sceneY;
	global.cameraStruct.cameraIndex = _cameraIndex;
	global.cameraStruct.obj = noone;
}

// Slowly move camera to a scene
function set_camera_soft_scene(_sceneX, _sceneY, _cameraIndex = DEFAULT_CAMERA_INDEX)
{
	global.cameraStruct.type = "softScene";
	global.cameraStruct.camX = _sceneX;
	global.cameraStruct.camY = _sceneY;
	global.cameraStruct.cameraIndex = _cameraIndex;
	global.cameraStruct.obj = noone;
	if(global.cameraStruct.lastX == noone)
	{
		global.cameraStruct.lastX = camera_get_view_width(view_camera[global.cameraStruct.cameraIndex]) * 0.5;
		global.cameraStruct.lastY = camera_get_view_height(view_camera[global.cameraStruct.cameraIndex]) * 0.5;
	}
}

// Camera's shake function's step event !!! THIS FUNCTION ISN'T MEAN TO BE CALLED OUTSIDE THE SCRIPT !!!
function NEVER_CALL_shakeStep()
{
	global.cameraStruct.shakeTime -= 1;
	
	var _x = choose(-global.cameraStruct.shakeMagnitude, global.cameraStruct.shakeMagnitude);
	var _y = choose(-global.cameraStruct.shakeMagnitude, global.cameraStruct.shakeMagnitude);
	
	global.cameraStruct.lastX += _x;
	global.cameraStruct.lastY += _y;
	
	if(global.cameraStruct.shakeTime <= 0)
	{
		global.cameraStruct.shakeMagnitude -= global.cameraStruct.shakeFade;
		
		if(global.cameraStruct.shakeMagnitude <= 0)
		{
			global.cameraStruct.shake = false;
		}
	}
}

// Camera's step event
function camera_step()
{
	var _index = global.cameraStruct.cameraIndex;
	
	switch(global.cameraStruct.type)
	{
		case "follow":
		{
			if(global.cameraStruct.obj != noone)
			{
				var _cursorX = (global.cameraStruct.obj.x - MOUSE_X) / global.cameraStruct.cursorInfluenceReduction; // Increment x value based on cursor pos
				var _cursorY = (global.cameraStruct.obj.y - MOUSE_Y) / global.cameraStruct.cursorInfluenceReduction; // Increment y value based on cursor pos
			
				if global.cameraStruct.fixedX != noone { global.cameraStruct.lastX = global.cameraStruct.fixedX - camera_get_view_width(view_camera[_index]) * 0.5; }
				else { global.cameraStruct.lastX = (global.cameraStruct.obj.x + -_cursorX) - camera_get_view_width(view_camera[_index]) * 0.5; }
				if global.cameraStruct.fixedY != noone { global.cameraStruct.lastY = global.cameraStruct.fixedY - camera_get_view_width(view_camera[_index]) * 0.5; }
				else { global.cameraStruct.lastY = (global.cameraStruct.obj.y + -_cursorY) - camera_get_view_height(view_camera[_index]) * 0.5; }
				
				if global.cameraStruct.shake == true { NEVER_CALL_shakeStep() }
			
				// Camera will snap to object, but slightly attracted by the player's mouse cursor
				camera_set_view_pos(view_camera[_index],
				global.cameraStruct.lastX,
				global.cameraStruct.lastY);
			}//fi
			break;
		}
		case "snapFollow":
		{
			if(global.cameraStruct.obj != noone)
			{
				if global.cameraStruct.fixedX != noone { global.cameraStruct.lastX = global.cameraStruct.fixedX - camera_get_view_width(view_camera[_index]) * 0.5; }
				else { global.cameraStruct.lastX = global.cameraStruct.obj.x - camera_get_view_width(view_camera[_index]) * 0.5; }
				if global.cameraStruct.fixedY != noone { global.cameraStruct.lastY = global.cameraStruct.fixedY - camera_get_view_width(view_camera[_index]) * 0.5; }
				else { global.cameraStruct.lastY = global.cameraStruct.obj.y - camera_get_view_height(view_camera[_index]) * 0.5; }
				
				if global.cameraStruct.shake == true { NEVER_CALL_shakeStep() }
				
				// Camera will snap to object
				camera_set_view_pos(view_camera[_index],
				global.cameraStruct.lastX,
				global.cameraStruct.lastY);
			}//fi
			break;
		}
		case "softFollow":
		{
			if(global.cameraStruct.obj != noone)
			{
				var _camX = global.cameraStruct.obj.x - camera_get_view_width(view_camera[_index]) * 0.5;
				var _camY = global.cameraStruct.obj.y - camera_get_view_height(view_camera[_index]) * 0.5;
				
				if global.cameraStruct.fixedX != noone { global.cameraStruct.lastX = global.cameraStruct.fixedX - camera_get_view_width(view_camera[_index]) * 0.5; }
				else { global.cameraStruct.lastX = lerp(global.cameraStruct.lastX, _camX, global.cameraStruct.cameraSpeed); }
				if global.cameraStruct.fixedY != noone { global.cameraStruct.lastY = global.cameraStruct.fixedY - camera_get_view_width(view_camera[_index]) * 0.5; }
				else { global.cameraStruct.lastY = lerp(global.cameraStruct.lastY, _camY, global.cameraStruct.cameraSpeed); }
				
				if global.cameraStruct.shake == true { NEVER_CALL_shakeStep() }
				
				// Camera will follow the object
				camera_set_view_pos(view_camera[_index],
				global.cameraStruct.lastX,
				global.cameraStruct.lastY);
			}//fi
			break;
		}
		case "extraSoftFollow":
		{
			if(global.cameraStruct.obj != noone)
			{
				var _camX = global.cameraStruct.obj.x - camera_get_view_width(view_camera[_index]) * 0.5;
				var _camY = global.cameraStruct.obj.y - camera_get_view_height(view_camera[_index]) * 0.5;
				
				var _cursorX = (global.cameraStruct.obj.x + -(global.cameraStruct.obj.x - MOUSE_X)/global.cameraStruct.cursorInfluenceReduction) - camera_get_view_width(view_camera[_index]) * 0.5; // Increment x value based on cursor pos
				var _cursorY = (global.cameraStruct.obj.y + -(global.cameraStruct.obj.y - MOUSE_Y)/global.cameraStruct.cursorInfluenceReduction) - camera_get_view_height(view_camera[_index]) * 0.5; // Increment y value based on cursor pos
				
				if global.cameraStruct.fixedX != noone { global.cameraStruct.lastX = global.cameraStruct.fixedX - camera_get_view_width(view_camera[_index]) * 0.5; }
				else { global.cameraStruct.lastX = lerp(global.cameraStruct.lastX, _camX, global.cameraStruct.cameraSpeed); }
				if global.cameraStruct.fixedY != noone { global.cameraStruct.lastY = global.cameraStruct.fixedY - camera_get_view_width(view_camera[_index]) * 0.5; }
				else { global.cameraStruct.lastY = lerp(global.cameraStruct.lastY, _camY, global.cameraStruct.cameraSpeed); }
				
				if global.cameraStruct.shake == true { NEVER_CALL_shakeStep() }
				
				var _x = global.cameraStruct.lastX;
				var _y = global.cameraStruct.lastY;
				if global.cameraStruct.fixedX == noone { _x = (global.cameraStruct.lastX + _cursorX) * 0.5; }
				if global.cameraStruct.fixedY == noone { _y = (global.cameraStruct.lastY + _cursorY) * 0.5; }
				
				// Camera will follow the object, but slightly attracted by the cursor
				camera_set_view_pos(view_camera[_index],
				_x,
				_y);
			}//fi
			break;
		}
		case "scene":
		{
			if(global.cameraStruct.camX != noone)
			{
				global.cameraStruct.lastX = global.cameraStruct.camX - camera_get_view_width(view_camera[_index]) * 0.5;
				global.cameraStruct.lastY = global.cameraStruct.camY - camera_get_view_height(view_camera[_index]) * 0.5;
				
				if global.cameraStruct.shake == true { NEVER_CALL_shakeStep() }
				
				// Camera will snap to object
				camera_set_view_pos(view_camera[_index],
				global.cameraStruct.lastX,
				global.cameraStruct.lastY);
			}//fi
			break;
		}
		case "softScene":
		{
			if(global.cameraStruct.camX != noone)
			{
				var _camX = global.cameraStruct.camX - camera_get_view_width(view_camera[_index]) * 0.5;
				var _camY = global.cameraStruct.camY - camera_get_view_height(view_camera[_index]) * 0.5;
				
				global.cameraStruct.lastX = lerp(global.cameraStruct.lastX, _camX, global.cameraStruct.cameraSpeed);
				global.cameraStruct.lastY = lerp(global.cameraStruct.lastY, _camY, global.cameraStruct.cameraSpeed);
				
				if global.cameraStruct.shake == true { NEVER_CALL_shakeStep() }
				
				// Camera will slowly move to the given coordinate
				camera_set_view_pos(view_camera[_index],
				global.cameraStruct.lastX,
				global.cameraStruct.lastY);
			}//fi
			break;
		}
		default: { break; }
	}
}
