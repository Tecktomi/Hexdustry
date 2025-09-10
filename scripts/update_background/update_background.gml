function update_background(a, b){
	with control{
		if background[floor(a / chunk_width), floor(b / chunk_height)] != spr_hexagono
			sprite_delete(background[floor(a / chunk_width), floor(b / chunk_height)])
		array_set(background[floor(a / chunk_width)], floor(b / chunk_height), spr_hexagono)
	}
}