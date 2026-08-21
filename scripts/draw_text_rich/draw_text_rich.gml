function draw_text_rich(xx, yy, width = room_width - xx, arguments = []){
	//complex_text(0, 0, 200, ["Estes es un", #ff0000, " ejemplo", {}, function(){show_deubg_message("success")}, "\nDe uso.", spr_happy])
	var xpos = xx, ypos = yy, a, argumento, param, funcion, arg_string, parrafos, primera_linea, trozos, xxx, spos, flag, i, segunda_linea, ultima_linea, arg_sprite, arg_real
	for(a = 0; a < array_length(arguments); a++){
		argumento = arguments[a]
		//FUNCIONES
		if is_struct(argumento){
			param = argumento
			funcion = arguments[++a]
			argumento = arguments[++a]
			//DRAW_BOTON
			if is_string(argumento){
				arg_string = string(argumento)
				parrafos = string_split(arg_string, "\n")
				primera_linea = ""
				trozos = string_split(parrafos[0], " ")
				spos = 0
				xxx = xpos
				flag = (string_count("\n", arg_string) = 0)
				for(i = 0; i < array_length(trozos); i++){
					if xxx > width + xx{
						flag = false
						break
					}
					primera_linea += trozos[i] + " "
					xxx += string_width(trozos[i] + " ")
					spos += string_length(trozos[i]) + 1
				}
				if flag{
					if draw_boton(xpos, ypos, primera_linea,,,, false, input_layer)
						funcion(param)
					xpos += text_x
				}
				else{
					if draw_boton(xpos, ypos, primera_linea,,,, false, input_layer)
						funcion(param)
					ypos += text_y
					segunda_linea = text_wrap(string_delete(arg_string, 0, spos), width)
					ultima_linea = string_delete(segunda_linea, 0, string_last_pos("\n", segunda_linea))
					segunda_linea = string_delete(segunda_linea, string_last_pos("\n", segunda_linea), string_length(segunda_linea))
					if segunda_linea != ""{
						if draw_boton(xx, ypos, segunda_linea,,,, false, input_layer)
							funcion(param)
						ypos += text_y
					}
					if ultima_linea != ""{
						if draw_boton(xx, ypos, ultima_linea,,,, false, input_layer)
							funcion(param)
						xpos += text_x
					}
				}
			}
			//DRAW_BOTON_SPRITE
			else if sprite_exists(argumento){
				arg_sprite = argumento
				if draw_sprite_boton(arg_sprite, 0, xpos, ypos, 18, 18, input_layer)
					funcion(param)
				xpos += sprite_get_width(arg_sprite)
			}
		}
		//CONSTANTES
		else{
			//STRINGS
			if is_string(argumento){
				arg_string = string(argumento)
				parrafos = string_split(arg_string, "\n")
				primera_linea = ""
				trozos = string_split(parrafos[0], " ")
				spos = 0
				xxx = xpos
				flag = (string_count("\n", arg_string) = 0)
				for(i = 0; i < array_length(trozos); i++){
					if xxx > width + xx{
						flag = false
						break
					}
					primera_linea += trozos[i] + " "
					xxx += string_width(trozos[i] + " ")
					spos += string_length(trozos[i]) + 1
				}
				if flag
					xpos = draw_text_xpos(xpos, ypos, primera_linea)
				else{
					ypos = draw_text_ypos(xpos, ypos, primera_linea)
					segunda_linea = text_wrap(string_delete(arg_string, 0, spos), width)
					ultima_linea = string_delete(segunda_linea, 0, string_last_pos("\n", segunda_linea))
					segunda_linea = string_delete(segunda_linea, string_last_pos("\n", segunda_linea), string_length(segunda_linea))
					if segunda_linea != ""
						ypos = draw_text_ypos(xx, ypos, segunda_linea)
					if ultima_linea != ""
						xpos = draw_text_xpos(xx, ypos, ultima_linea)
				}
			}
			//SET_COLOR
			else if is_real(argumento){
				arg_real = real(argumento)
				draw_set_color(arg_real)
			}
			//SPRITES
			else if sprite_exists(argumento){
				arg_sprite = argumento
				draw_sprite_stretched(arg_sprite, 0, xpos, ypos, 18, 18)
				xpos += 20
			}
		}
	}
	return [xpos, ypos]
}