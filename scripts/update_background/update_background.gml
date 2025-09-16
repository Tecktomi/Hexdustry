function update_background(a, b){
	with control{
		var aa = floor(a / chunk_width), bb = floor(b / chunk_height)
		if background[aa, bb] != spr_hexagono
			sprite_delete(background[aa, bb])
		array_set(background[aa], bb, spr_hexagono)
	}
}