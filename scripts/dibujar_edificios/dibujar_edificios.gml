function dibujar_edificios(){
	with control{
		var time = current_time
		for(var a = min_chunka; a < max_chunka; a++)
			for(var b = min_chunkb; b < max_chunkb; b++){
				var chunk = chunk_edificios[# a, b], len = array_length(chunk)
				for(var c = 0; c < len; c++){
					var edificio = chunk[c], aa = edificio.x, bb = edificio.y
					edificio_draw_function[edificio.index](edificio)
					//Dibujo estados
					if edificio.enemigo{
						draw_set_color(c_red)
						draw_circle_off(aa + 8, bb, 4, false)
					}
					if info and edificio.waiting{
						draw_set_color(c_yellow)
						draw_circle_off(aa, bb + 16, 4, false)
					}
					if edificio.idle{
						draw_set_color(c_red)
						draw_circle_off(aa, bb + 8, 4, false)
					}
				}
				chunk = chunk_edificios_enemigo[# a, b]
				len = array_length(chunk)
				for(var c = 0; c < len; c++){
					var edificio = chunk[c], aa = edificio.x, bb = edificio.y
					edificio_draw_function[edificio.index](edificio)
					//Dibujo estados
					if edificio.enemigo{
						draw_set_color(c_red)
						draw_circle_off(aa + 8, bb, 4, false)
					}
					if info and edificio.waiting{
						draw_set_color(c_yellow)
						draw_circle_off(aa, bb + 16, 4, false)
					}
					if edificio.idle{
						draw_set_color(c_red)
						draw_circle_off(aa, bb + 8, 4, false)
					}
				}
			}
		draw_set_color(c_white)
		show_debug_message(current_time - time)
	}
}