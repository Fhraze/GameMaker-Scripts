/// Returns the direction in a compass rose of one object relative to another
/// by Fhraze
//
global.compassRose =
{
	w:{
		hi: 155,
		lo: 205,
		dir: "W" },
	nw:{
		hi: 109,
		lo: 156,
		dir: "NW"},
	ne:{
		hi: 24,
		lo: 71,
		dir: "NE"},
	se:{
		hi: 289,
		lo: 336,
		dir: "SE"},
	sw:{
		
		hi: 204,
		lo: 251,
		dir: "SW"},
	n:{
		hi: 70,
		lo: 110,
		dir: "N" },
	s:{
		hi: 250,
		lo: 290,
		dir: "S" }
}

function raycast_8sides(_from, _to){
	var angle = point_direction(_from.x, _from.y, _to.x, _to.y);
	var dir = "E";
	var keys = variable_struct_get_names(global.compassRose);	
	for (var i = array_length(keys)-1; i >= 0; --i)
	{
	    var k = keys[i];
		if (angle > global.compassRose[$ k].hi
			and angle < global.compassRose[$ k].lo)
			{ dir = global.compassRose[$ k].dir; }
	}
	return dir;
}