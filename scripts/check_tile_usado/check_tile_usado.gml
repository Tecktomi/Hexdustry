function check_tile_usado(a, b, _tiles_usados){
	var len = array_length(_tiles_usados), aa = 0, bb = 0
	for(var i = 0; i < len;){
		aa = _tiles_usados[i++]
		bb = _tiles_usados[i++]
		if a = aa and b = bb
			return true
	}
	return false
}