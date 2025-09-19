function xytoab(x, y) {
    var temp_hexagono = instance_position(x, y, obj_hexagono)
	if temp_hexagono != noone
		return {a : temp_hexagono.a, b : temp_hexagono.b}
	return {a : 0, b : 0}
}