/// Returns the direction in a compass rose of one object relative to another
/// by Fhraze
//
global.compassRose =
{
	W:{
		xsp: -1,
		ysp: 0,
		hi: 155,
		lo: 205,
		center: 180,
		dir: "W" },
	NW:{
		xsp: -1,
		ysp: -1,
		hi: 109,
		lo: 156,
		center: 135,
		dir: "NW"},
	NE:{
		xsp: 1,
		ysp: -1,
		hi: 24,
		lo: 71,
		center: 45,
		dir: "NE"},
	SE:{
		xsp: 1,
		ysp: 1,
		hi: 289,
		lo: 336,
		center: 315,
		dir: "SE"},
	SW:{
		xsp: -1,
		ysp: 1,
		hi: 204,
		lo: 251,
		center: 225,
		dir: "SW"},
	N:{
		xsp: 0,
		ysp: -1,
		hi: 70,
		lo: 110,
		center: 90,
		dir: "N" },
	S:{
		xsp: 0,
		ysp: 1,
		hi: 250,
		lo: 290,
		center: 270,
		dir: "S" },
	E:{
		center: 0,
		xsp: 1,
		ysp: 0 }
}

function compass_raycast(_from, _to){
	var angle = point_direction(_from.x, _from.y, _to.x, _to.y);
	var dir = "E";
	var keys = variable_struct_get_names(global.compassRose);
	array_delete(keys, 7, 1)
	for (var i = array_length(keys)-1; i >= 0; --i)
	{
	    var k = keys[i];
		if (angle > global.compassRose[$ k].hi
			and angle < global.compassRose[$ k].lo)
			{ dir = global.compassRose[$ k].dir; }
	}
	return dir;
}

function increment_towards_object(_obj, _sp = 1)
{
	var _dir = compass_raycast(self, _obj)
	x += global.compassRose[$ _dir].xsp * _sp
	y += global.compassRose[$ _dir].ysp * _sp
}