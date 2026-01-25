function scr_torre_reparadora(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red, red_power = red.eficiencia
		if array_length(edificio.edificios_cercanos_heridos) = 0 or red_power = 0
			continue
		if edificio.link = null_edificio{
			edificio.link = edificio.edificios_cercanos_heridos[0]
			if edificio != edificio.link and edificio.link.vida >= edificio_vida[edificio.link.index] or distance_sqr(edificio.center_x, edificio.center_y, edificio.link.center_x, edificio.link.center_y) > edificio_alcance_sqr[index]{
				edificio.link = null_edificio
				change_energia(0, edificio)
			}
		}
		else{
			if edificio.link.vida <= 0 or edificio.link.vida >= edificio_vida[edificio.link.index]{
				edificio.link = null_edificio
				change_energia(0, edificio)
			}
			else{
				var target = edificio.link
				change_energia(edificio_energia_consumo[index], edificio)
				draw_set_color(c_green)
				draw_set_alpha(red_power)
				draw_line_off(edificio.center_x, edificio.center_y, target.center_x, target.center_y)
				edificio_curar(target, red_power * (1 + 0.2 * edificio.modulo))
				edificio.select = radtodeg(-arctan2(edificio.center_x - target.center_x, target.center_y - edificio.center_y)) - 90
				draw_set_alpha(1)
				draw_set_color(c_black)
			}
		}
	}
}