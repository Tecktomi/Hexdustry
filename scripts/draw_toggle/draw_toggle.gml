function draw_toggle(x, y, variable, input_layer){
	if draw_sprite_boton(spr_toggler, x, y,,,, input_layer, variable)
		return not bool(variable)
	return bool(variable)
}