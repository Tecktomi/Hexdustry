function scr_laser(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red, red_power = red.eficiencia
		if (image_index mod 10 = 0 and edificio.target = null_enemigo) or edificio.target.vida <= 0{
			edificio.target = null_enemigo
			if array_length(enemigos) > 0
				turret_target(edificio)
		}
		var enemigo = edificio.target
		if enemigo != null_enemigo and distance_sqr(edificio.x, edificio.y, enemigo.a, enemigo.b) < edificio_alcance_sqr[edificio.index]{
			edificio.select = radtodeg(-arctan2(edificio.x - enemigo.a, enemigo.b - edificio.y)) - 90
			change_energia(edificio_energia_consumo[index], edificio)
			edificio.mode = true
			enemigo.vida -= 3 * red_power * vel
			draw_set_alpha(red_power)
			draw_set_color(c_red)
			draw_line_off(edificio.x + edificio.array_real[2], edificio.y + 14, enemigo.a, enemigo.b)
			draw_set_alpha(1)
			if enemigo.vida <= 0{
				destroy_dron(enemigo)
				change_energia(0, edificio)
				edificio.target = null_enemigo
				turret_target(edificio)
			}
		}
		else{
			change_energia(0, edificio)
			edificio.target = null_edificio
		}
	}
}