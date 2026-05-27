function scroll_editor_instrucciones(a, param = {xpos : 0, ypos : 0, ore_names : [""]}){
	with control{
		var xpos = param.xpos, ypos = param.ypos, ore_names = param.ore_names
		var instruccion = editor_instrucciones[a], tipo = instruccion[0], dat1 = instruccion[1], dat2 = instruccion[2], dat3 = instruccion[3]
		xpos = 140
		if draw_sprite_boton(spr_basura,, xpos, ypos, 20, 20){
			array_delete(editor_instrucciones, a, 1)
			size--
			a--
			continue
		}
		xpos += 20
		if draw_sprite_boton(spr_flecha,, xpos, ypos, 20, 20)
			procesador_move = a
		
		xpos += 20
		//Bloques de Terreno
		if tipo = 0{
			xpos = draw_text_xpos(xpos, ypos, $"{L.editor_add} ")
			instruccion[1] = draw_boton_text_list(xpos, ypos, dat1, terreno_nombre,, 10)
			xpos += text_x
			xpos = draw_text_xpos(xpos, ypos, $" {L.editor_size} ")
			instruccion[2] = draw_boton_text(xpos, ypos, dat2)
			xpos += text_x
			xpos = draw_text_xpos(xpos, ypos, ", ")
			instruccion[3] = draw_boton_text(xpos, ypos, dat3)
			xpos += text_x
			xpos = draw_text_xpos(xpos, ypos, $" {L.editor_veces}")
		}
		//Bordes de Terreno
		else if tipo = 1{
			var temp_text
			xpos = draw_text_xpos(xpos, ypos, $"{L.editor_al_rededor} ")
			instruccion[1] = draw_boton_text_list(xpos, ypos, dat1, terreno_nombre,, 10)
			xpos += text_x
			xpos = draw_text_xpos(xpos, ypos, $" {L.editor_reemplazar} ")
			if dat1 = dat2{
				temp_text = terreno_nombre[dat1]
				terreno_nombre[dat1] = L.editor_cualquiera
			}
			instruccion[2] = draw_boton_text_list(xpos, ypos, dat2, terreno_nombre,, 10)
			if dat1 = dat2
				terreno_nombre[dat1] = temp_text
			xpos += text_x
			xpos = draw_text_xpos(xpos, ypos, $" {L.editor_con} ")
			instruccion[3] = draw_boton_text_list(xpos, ypos, dat3, terreno_nombre,, 10)
		}
		//Ruido Aleatorio
		else if tipo = 2{
			xpos = draw_text_xpos(xpos, ypos, $"{L.editor_Reemplazar} ")
			instruccion[1] = draw_boton_text_list(xpos, ypos, dat1, terreno_nombre,, 10)
			xpos += text_x
			xpos = draw_text_xpos(xpos, ypos, $" {L.editor_con} ")
			instruccion[2] = draw_boton_text_list(xpos, ypos, dat2, terreno_nombre,, 10)
			xpos += text_x
			xpos = draw_text_xpos(xpos, ypos, $" {L.editor_el} ")
			instruccion[3] = draw_boton_text(xpos, ypos, dat3)
			xpos += text_x
			xpos = draw_text_xpos(xpos, ypos, $"% {L.editor_del_tiempo}")
		}
		//Menas de Recursos
		else if tipo = 3{
			xpos = draw_text_xpos(xpos, ypos, $"{L.editor_add} ")
			instruccion[1] = draw_boton_text_list(xpos, ypos, dat1, ore_names,, 10)
			xpos += text_x
			xpos = draw_text_xpos(xpos, ypos, $" {L.editor_size} ")
			instruccion[2] = draw_boton_text(xpos, ypos, dat2)
			xpos += text_x
			xpos = draw_text_xpos(xpos, ypos, ", ")
			instruccion[3] = draw_boton_text(xpos, ypos, dat3)
			xpos += text_x
			xpos = draw_text_xpos(xpos, ypos, $" {L.editor_veces}")
		}
		//Perlin
		else if tipo = 4{
			xpos = draw_text_xpos(xpos, ypos, $"Añadir manchas de ")
			instruccion[1] = draw_boton_text_list(xpos, ypos, dat1, terreno_nombre,, 10)
			xpos += text_x
			xpos = draw_text_xpos(xpos, ypos, $" sobre ")
			instruccion[2] = draw_boton_text_list(xpos, ypos, dat2, terreno_nombre,, 10)
			xpos += text_x
			xpos = draw_text_xpos(xpos, ypos, $" con tamaño mínimo de ")
			instruccion[3] = draw_boton_text(xpos, ypos, dat3)
		}
		if procesador_move >= 0 and mouse_y > ypos and mouse_y < ypos + text_y{
			draw_set_alpha(0.3)
			draw_rectangle(140, ypos, xpos + text_x, ypos + text_y, false)
			draw_set_alpha(1)
			if mouse_check_button_released(mb_left) and a != procesador_move{
				array_insert(editor_instrucciones, a, editor_instrucciones[procesador_move])
				array_delete(editor_instrucciones, procesador_move + (procesador_move > a), 1)
				procesador_move = -1
			}
		}
		param.ypos += text_y
	}
	return -1
}