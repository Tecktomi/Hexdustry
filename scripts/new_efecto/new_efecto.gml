function new_efecto(sprite = spr_hexagono, subsprite = 0, x = 0, y = 0, tiempo = 0, frame_speed = 1){
	var efecto = {
		sprite : sprite,
		subsprite : subsprite,
		x : x,
		y : y,
		tiempo : tiempo,
		frame_speed : frame_speed
	}
	return efecto
}