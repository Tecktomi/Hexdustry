function update_background(a, b){
	with control{
		var aa = floor(a / CHUNK_WIDTH), bb = floor(b / CHUNK_HEIGHT)
		if background[# aa, bb] != spr_hexagono
			sprite_delete(background[# aa, bb])
		ds_grid_set(background, aa, bb, spr_hexagono)
		chunk_update = true
		ds_grid_set(background_bool, aa, bb, false)
	}
}