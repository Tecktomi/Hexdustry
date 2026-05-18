function panel_enciclopedia_consejo(xpos = 0, ypos = 0, param = {_this_input_layer : 0}){
	with control{
		var ei = enciclopedia_item, _input_layer = param._this_input_layer, _consejos_texto = consejos_texto[ei]
		draw_set_font(font_titulo)
		ypos = draw_text_ypos(xpos + 10, ypos, consejos_nombre[ei])
		draw_set_font(font_normal)
		xpos += 20
		//Control de Cámara
		if ei = 0{
			for(var a = 0; a < 2; a++)
				ypos = draw_text_ypos(xpos, ypos, _consejos_texto[a])
			ypos += text_y
			for(var a = 2; a < 6; a++)
				ypos = draw_text_ypos(xpos, ypos, _consejos_texto[a])
		}
		//Construcción
		else if ei = 1{
			for(var a = 0; a < array_length(_consejos_texto); a++)
				ypos = draw_text_ypos(xpos, ypos, _consejos_texto[a])
			if draw_boton(xpos + text_x, ypos - text_y, $" {edificio_nombre[id_tunel]}",,,, false, _input_layer){
				enciclopedia_link(4, id_tunel)
				return [xpos, ypos]
			}
			ypos += text_y
		}
		//Redes eléctricas
		else if ei = 2{
			for(var a = 0; a < 2; a++)
				ypos = draw_text_ypos(xpos, ypos, _consejos_texto[a])
			for(var a = 0; a < edificio_max; a++){
				if edificio_energia[a] and edificio_energia_consumo[a] < 0{
					draw_sprite_stretched(edificio_sprite[a], 0, xpos, ypos, 18, 18)
					if draw_boton(xpos + 20, ypos, edificio_nombre[a],,,, false, _input_layer){
						enciclopedia_link(4, a)
						return [xpos, ypos]
					}
					ypos += text_y
				}
			}
			ypos = draw_text_ypos(xpos, ypos, _consejos_texto[2])
			var temp_array = [id_cable, id_torre_de_alta_tension]
			for(var a = 0; a < 2; a++){
				var aa = temp_array[a]
				draw_sprite_stretched(edificio_sprite[aa], 0, xpos, ypos, 18, 18)
				if draw_boton(xpos + 20, ypos, edificio_nombre[aa],,,, false, _input_layer){
					enciclopedia_link(4, aa)
					return [xpos, ypos]
				}
				ypos += text_y
			}
			ypos = draw_text_ypos(xpos, ypos, _consejos_texto[3])
			temp_array = [id_bateria]
			for(var a = 0; a < 1; a++){
				var aa = temp_array[a]
				draw_sprite_stretched(edificio_sprite[aa], 0, xpos, ypos, 18, 18)
				if draw_boton(xpos + 20, ypos, edificio_nombre[aa],,,, false, _input_layer){
					enciclopedia_link(4, aa)
					return [xpos, ypos]
				}
				ypos += text_y
			}
			ypos = draw_text_ypos(xpos, ypos, _consejos_texto[4])
			for(var a = 0; a < edificio_max; a++){
				if edificio_energia[a] and edificio_energia_consumo[a] > 0{
					draw_sprite_stretched(edificio_sprite[a], 0, xpos, ypos, 18, 18)
					if draw_boton(xpos + 20, ypos, edificio_nombre[a],,,, false, _input_layer){
						enciclopedia_link(4, a)
						return [xpos, ypos]
					}
					ypos += text_y
				}
			}
		}
		//Redes de líquidos
		else if ei = 3{
			ypos = draw_text_ypos(xpos, ypos, _consejos_texto[0])
			ypos = draw_text_ypos(xpos, ypos, _consejos_texto[1], true)
			if draw_boton(xpos + text_xpos, ypos - text_y + text_ypos, $" {edificio_nombre[id_bomba_hidraulica]}",,,, false, _input_layer){
				enciclopedia_link(4, id_bomba_hidraulica)
				return [xpos, ypos]
			}
			ypos = draw_text_ypos(xpos, ypos, _consejos_texto[2])
			if draw_boton(xpos + text_x, ypos - text_y, $" {edificio_nombre[id_tuberia]}",,,, false, _input_layer){
				enciclopedia_link(4, id_tuberia)
				return [xpos, ypos]
			}
			ypos = draw_text_ypos(xpos, ypos, _consejos_texto[3])
			if draw_boton(xpos + text_x, ypos - text_y, $" {edificio_nombre[id_deposito]}",,,, false, _input_layer){
				enciclopedia_link(4, id_deposito)
				return [xpos, ypos]
			}
			ypos = draw_text_ypos(xpos, ypos, _consejos_texto[4])
			for(var a = 0; a < array_length(liquido_nombre); a++){
				ypos = draw_text_ypos(xpos + 20, ypos, _consejos_texto[5] + " " + liquido_nombre[a])
				draw_sprite_stretched(liquido_sprite[a], 0, xpos + text_x + 20, ypos - text_y, 24, 24)
				for(var b = 0; b < edificio_max; b++)
					if array_contains(edificio_flujo_liquido[b], a){
						draw_sprite_stretched(edificio_sprite[b], 0, xpos + 20, ypos, 18, 18)
						if draw_boton(xpos + 40, ypos, edificio_nombre[b],,,, false, _input_layer){
							enciclopedia_link(4, b)
							return [xpos, ypos]
						}
						ypos += text_y
					}
			}
		}
		//Procesadores
		else if ei = 4{
			if draw_boton(xpos, ypos, $"{edificio_nombre[id_procesador]} ",,,, false, _input_layer){
				enciclopedia_link(4, id_procesador)
				return[xpos, ypos]
			}
			ypos = draw_text_ypos(xpos + text_x, ypos, _consejos_texto[0])
			ypos = draw_text_ypos(xpos + 10, ypos, _consejos_texto[1])
			if draw_boton(xpos, ypos, $"{edificio_nombre[id_mensaje]} ",,,, false, _input_layer){
				enciclopedia_link(4, id_mensaje)
				return[xpos, ypos]
			}
			ypos = draw_text_ypos(xpos + text_x, ypos, _consejos_texto[3])
			if draw_boton(xpos, ypos, $"{edificio_nombre[id_memoria]} ",,,,false, _input_layer){
				enciclopedia_link(4, id_memoria)
				return[xpos, ypos]
			}
			ypos = draw_text_ypos(xpos + text_x, ypos, _consejos_texto[4])
			if draw_boton(xpos, ypos, $"{edificio_nombre[id_pantalla]} ",,,, false, _input_layer){
				enciclopedia_link(4, id_pantalla)
				return[xpos, ypos]
			}
			ypos = draw_text_ypos(xpos + text_x, ypos, _consejos_texto[5])
			ypos = draw_text_ypos(xpos + 10, ypos, _consejos_texto[2])
			for(var a = 0; a < array_length(procesador_instrucciones_nombre); a++)
				ypos = draw_text_ypos(xpos + 20, ypos, $"-{procesador_instrucciones_nombre[a]}: {procesador_instrucciones_descripcion[a]}")
		}
		return [xpos, ypos]
	}
}