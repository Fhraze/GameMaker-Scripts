///   Script that manages the camera position in-game
///   by Fhraze#4081
/*

  Please note that this script works by managing Game Maker's
viewports and cameras that need to be properly configured
for each room of your game.

  There are 7 different types of camera which can be set
using their respective set function. If you don't know what
a camera type does, just search for its function in the script,
the function's description will be right on top of it.

*/

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

global.cameraType =
{
	follow: "follow",
	snapFollow: "snapFollow",
	softFollow: "softFollow",
	extraSoftFollow: "extraSoftFollow",
	scene: "scene",
	softScene: "softScene"
}

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
	fixedY: noone
}

// Set camera to snap to an object, but slightly attracted by the mouse cursor
function setCameraFollow(_followedObject, _cameraIndex = DEFAULT_CAMERA_INDEX, _fixedX = noone, _fixedY = noone, _cursorInfluenceReduction = DEFAULT_CURSOR_INFLUENCE_REDUCTION)
{
	global.cameraStruct[$ "type"] = global.cameraType.follow;
	global.cameraStruct[$ "obj"] = _followedObject;
	global.cameraStruct[$ "cameraIndex"] = _cameraIndex;
	global.cameraStruct[$ "cursorInfluenceReduction"] = _cursorInfluenceReduction;
	global.cameraStruct[$ "fixedX"] = _fixedX;
	global.cameraStruct[$ "fixedY"] = _fixedY;
}

// Set camera to snap to an object
function setCameraSnapFollow(_followedObject, _cameraIndex = DEFAULT_CAMERA_INDEX, _fixedX = noone, _fixedY = noone)
{
	global.cameraStruct[$ "type"] = global.cameraType.snapFollow;
	global.cameraStruct[$ "obj"] = _followedObject;
	global.cameraStruct[$ "cameraIndex"] = _cameraIndex;
	global.cameraStruct[$ "fixedX"] = _fixedX;
	global.cameraStruct[$ "fixedY"] = _fixedY;
}

// Set camera to slowly follow an object
function setCameraSoftFollow(_followedObject, _cameraIndex = DEFAULT_CAMERA_INDEX, _fixedX = noone, _fixedY = noone, _cameraSpeed = DEFAULT_CAMERA_SPEED)
{
	global.cameraStruct[$ "type"] = global.cameraType.softFollow;
	global.cameraStruct[$ "obj"] = _followedObject;
	global.cameraStruct[$ "cameraIndex"] = _cameraIndex;
	global.cameraStruct[$ "fixedX"] = _fixedX;
	global.cameraStruct[$ "fixedY"] = _fixedY;
	if(global.cameraStruct.lastX == noone)
	{
		global.cameraStruct.lastX = global.cameraStruct.obj.x - camera_get_view_width(view_camera[global.cameraStruct.cameraIndex]) * 0.5;
		global.cameraStruct.lastY = global.cameraStruct.obj.y - camera_get_view_height(view_camera[global.cameraStruct.cameraIndex]) * 0.5;
	}
}

// Set camera to slowly follow an object, but slightly attracted by the mouse cursor
function setCameraExtraSoftFollow(_followedObject, _cameraIndex = DEFAULT_CAMERA_INDEX, _fixedX = noone, _fixedY = noone, _cameraSpeed = DEFAULT_CAMERA_SPEED, _cursorInfluenceReduction = DEFAULT_CURSOR_INFLUENCE_REDUCTION)
{
	global.cameraStruct[$ "type"] = global.cameraType.extraSoftFollow;
	global.cameraStruct[$ "obj"] = _followedObject;
	global.cameraStruct[$ "cameraIndex"] = _cameraIndex;
	global.cameraStruct[$ "cursorInfluenceReduction"] = _cursorInfluenceReduction;
	global.cameraStruct[$ "fixedX"] = _fixedX;
	global.cameraStruct[$ "fixedY"] = _fixedY;
	if(global.cameraStruct.lastX == noone)
	{
		global.cameraStruct.lastX = global.cameraStruct.obj.x - camera_get_view_width(view_camera[global.cameraStruct.cameraIndex]) * 0.5;
		global.cameraStruct.lastY = global.cameraStruct.obj.y - camera_get_view_height(view_camera[global.cameraStruct.cameraIndex]) * 0.5;
	}
}

// Set camera to be fixed at a scene
function setCameraScene(_sceneX, _sceneY, _cameraIndex = DEFAULT_CAMERA_INDEX)
{
	global.cameraStruct[$ "type"] = global.cameraType.scene;
	global.cameraStruct[$ "camX"] = _sceneX;
	global.cameraStruct[$ "camY"] = _sceneY;
	global.cameraStruct[$ "cameraIndex"] = _cameraIndex;
	global.cameraStruct.obj = noone;
}

// Slowly move camera to a scene
function setCameraSoftScene(_sceneX, _sceneY, _cameraIndex = DEFAULT_CAMERA_INDEX)
{
	global.cameraStruct[$ "type"] = global.cameraType.softScene;
	global.cameraStruct[$ "camX"] = _sceneX;
	global.cameraStruct[$ "camY"] = _sceneY;
	global.cameraStruct[$ "cameraIndex"] = _cameraIndex;
	global.cameraStruct.obj = noone;
	if(global.cameraStruct.lastX == noone)
	{
		global.cameraStruct.lastX = camera_get_view_width(view_camera[global.cameraStruct.cameraIndex]) * 0.5;
		global.cameraStruct.lastY = camera_get_view_height(view_camera[global.cameraStruct.cameraIndex]) * 0.5;
	}
}

// Call the camera step event
function cameraStep()
{
	var _index = global.cameraStruct.cameraIndex;
	
	switch(global.cameraStruct.type)
	{
		case "follow":
		{
			if(global.cameraStruct.obj != noone)
			{
				var _cursorX = (global.cameraStruct.obj.x - mouse_x)/global.cameraStruct.cursorInfluenceReduction; // Increment x value based on cursor pos
				var _cursorY = (global.cameraStruct.obj.y - mouse_y)/global.cameraStruct.cursorInfluenceReduction; // Increment y value based on cursor pos
			
				if global.cameraStruct.fixedX != noone { global.cameraStruct.lastX = global.cameraStruct.fixedX - camera_get_view_width(view_camera[_index]) * 0.5; }
				else { global.cameraStruct.lastX = (global.cameraStruct.obj.x + -_cursorX) - camera_get_view_width(view_camera[_index]) * 0.5; }
				if global.cameraStruct.fixedY != noone { global.cameraStruct.lastY = global.cameraStruct.fixedY - camera_get_view_width(view_camera[_index]) * 0.5; }
				else { global.cameraStruct.lastY = (global.cameraStruct.obj.y + -_cursorY) - camera_get_view_height(view_camera[_index]) * 0.5; }
			
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
				
				var _cursorX = (global.cameraStruct.obj.x + -(global.cameraStruct.obj.x - mouse_x)/global.cameraStruct.cursorInfluenceReduction) - camera_get_view_width(view_camera[_index]) * 0.5; // Increment x value based on cursor pos
				var _cursorY = (global.cameraStruct.obj.y + -(global.cameraStruct.obj.y - mouse_y)/global.cameraStruct.cursorInfluenceReduction) - camera_get_view_height(view_camera[_index]) * 0.5; // Increment y value based on cursor pos
				
				if global.cameraStruct.fixedX != noone { global.cameraStruct.lastX = global.cameraStruct.fixedX - camera_get_view_width(view_camera[_index]) * 0.5; }
				else { global.cameraStruct.lastX = lerp(global.cameraStruct.lastX, _camX, global.cameraStruct.cameraSpeed); }
				if global.cameraStruct.fixedY != noone { global.cameraStruct.lastY = global.cameraStruct.fixedY - camera_get_view_width(view_camera[_index]) * 0.5; }
				else { global.cameraStruct.lastY = lerp(global.cameraStruct.lastY, _camY, global.cameraStruct.cameraSpeed); }
				
				// Camera will follow the object, but slightly attracted by the cursor
				camera_set_view_pos(view_camera[_index],
				(global.cameraStruct.lastX + _cursorX) * 0.5,
				(global.cameraStruct.lastY + _cursorY) * 0.5);
			}//fi
			break;
		}
		case "scene":
		{
			if(global.cameraStruct.camX != noone)
			{
				global.cameraStruct.lastX = global.cameraStruct.camX - camera_get_view_width(view_camera[_index]) * 0.5;
				global.cameraStruct.lastY = global.cameraStruct.camY - camera_get_view_height(view_camera[_index]) * 0.5;
				
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
