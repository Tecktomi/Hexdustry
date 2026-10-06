function procesador_valor(edificio = control.null_edificio, instruccion, xpos, ypos, pc, a = 0, b = 0, es_real = false){
	with control{
		if draw_boton(xpos, ypos, (pc[a] = 0 ? "VAR" : (pc[a] = 1 ? "int" : "str")),,,, false){
			var temp_val
			if es_real
				temp_val = (pc[a] + 1) mod 2
			else
				temp_val = (pc[a] + 1) mod 3
			set_edificio_instruccion(edificio, {cambio : cambio_instruccion_set, instruccion : instruccion, pos : a, valor : temp_val})
			if temp_val = 0{
				temp_val = is_real(pc[b]) ? clamp(pc[b], 0, 15) : 0
				set_edificio_instruccion(edificio, {cambio : cambio_instruccion_set, instruccion : instruccion, pos : b, valor : temp_val})
			}
		}
		var var_text_x = text_x, temp_val
		xpos = draw_text_xpos(xpos + var_text_x, ypos, (pc[a] = 0) ? "_" : " ")
		var_text_x += text_x
		temp_val = (pc[a] = 0) ? procesador_var(xpos, ypos, pc, b) : draw_boton_text(xpos, ypos, pc[b], (pc[a] = 1))
		if pc[b] != temp_val and ((pc[a] = 0) or prev_get_keyboard_string != get_keyboard_string)
			set_edificio_instruccion(edificio, {cambio : cambio_instruccion_set, instruccion : instruccion, pos : b, valor : temp_val})
		text_x += var_text_x
	}
}