function update_background(a, b){
	with control{
		var aa = floor(a / CHUNK_WIDTH), bb = floor(b / CHUNK_HEIGHT)
		if background[# aa, bb] != spr_hexagono
			sprite_delete(background[# aa, bb])
		background[# aa, bb] = spr_hexagono
		background_bool[# aa, bb] = false
	}
}