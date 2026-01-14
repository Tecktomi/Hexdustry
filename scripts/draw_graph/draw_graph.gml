function draw_graph(x, y, width = 400, height = 100, variables = array_create(0, array_create(0, 0)), variables_color = array_create(0, c_black), reverse = false){
	var tlen, vlen, altura = 0
	if reverse{
		//[v1[t1, t2, t3], v2[t1, t2, t3]]
		vlen = array_length(variables)
		tlen = array_length(variables[0])
		for(var a = 0; a < vlen; a++)
			for(var b = 0; b < tlen; b++)
				altura = max(altura, variables[a, b])
	}
	else{
		//[t1[v1, v2], t2[v1, v2], t3[v1, v2]]
		tlen = array_length(variables)
		vlen = array_length(variables[0])
		for(var a = 0; a < vlen; a++)
			for(var b = 0; b < tlen; b++)
				altura = max(altura, variables[b, a])
	}
	var ancho = width / tlen
	altura = height / altura
	draw_set_color(c_white)
	draw_line(x, y + height, x + width, y + height)
	draw_line(x, y + height, x, y)
	if reverse{
		for(var a = 0; a < vlen; a++){
			draw_set_color(variables_color[a])
			if variables[a, 0] != 0
				draw_line(x, y + height, x + ancho, y + height - altura * variables[a, 0])
			for(var b = 0; b < tlen - 1; b++)
				if variables[a, b] != 0 or variables[a, b + 1] != 0
					draw_line(	x + ancho * (b + 1),
								y + height - altura * variables[a, b],
								x + ancho * (b + 2),
								y + height - altura * variables[a, b + 1])
		}
	}
	else{
		for(var a = 0; a < vlen; a++){
			draw_set_color(variables_color[a])
			if variables[0, a] != 0
				draw_line(x, y + height, x + ancho, y + height - altura * variables[0, a])
			for(var b = 0; b < tlen - 1; b++)
				if variables[b, a] != 0 or variables[b + 1, a] != 0
					draw_line(	x + ancho * (b + 1),
								y + height - altura * variables[b, a],
								x + ancho * (b + 2),
								y + height - altura * variables[b + 1, a])
		}
	}
	draw_set_color(c_white)
	for(var a = 0; a <= tlen / 5; a++)
		draw_text(x + 5 * ancho * a, y + height, 5 * a)
}