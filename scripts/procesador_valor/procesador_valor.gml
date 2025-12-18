function procesador_valor(xpos, ypos, pc, a, b, es_real = false){
	with control{
		if draw_boton(xpos, ypos, (pc[a] = 0 ? "VAR" : (pc[a] = 1 ? "int" : "str")),,,, false){
			if es_real
				pc[a] = ++pc[a] mod 2
			else
				pc[a] = ++pc[a] mod 3
			if pc[a] = 0{
				if is_real(pc[b])
					pc[b] = clamp(pc[b], 0, 15)
				else
					pc[b] = 0
			}
		}
		var var_text_x = text_x
		xpos = draw_text_xpos(xpos + var_text_x, ypos, pc[a] ? "_" : " ")
		var_text_x += text_x
		if pc[a] = 0
			pc[b] = procesador_var(xpos, ypos, pc, b)
		else
			pc[b] = draw_boton_text(xpos, ypos, pc[b], (pc[a] = 1))
		text_x += var_text_x
	}
}