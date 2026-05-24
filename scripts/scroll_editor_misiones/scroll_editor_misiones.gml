function scroll_editor_misiones(a = 0, param = {xpos : 0, ypos : 0}){
	with control{
		if a > 0 and draw_sprite_boton(spr_flecha,, param.xpos, param.ypos){
			var temp_mision = misiones[a - 1]
			misiones[a - 1] = misiones[a]
			misiones[a] = temp_mision
		}
		if draw_boton(param.xpos + 20, param.ypos, $"'{misiones[a].nombre}'")
			mision_actual = a
		param.ypos += 30
	}
	return -1
}