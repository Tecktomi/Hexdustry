function draw_toggle(x, y, variable, input_layer){
	if draw_sprite_boton(spr_toggler, variable, x, y,,, input_layer)
		return not bool(variable)
	return bool(variable)
}