function new_efecto(sprite = spr_hexagono, subsprite = 0, x = 0, y = 0, tiempo = 0){
	var efecto = {
		sprite : sprite,
		subsprite : subsprite,
		x : x,
		y : y,
		tiempo : tiempo
	}
	return efecto
}