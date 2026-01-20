function scr_laser(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		if (image_index mod 10 = 0 and edificio.target = null_enemigo) or edificio.target.vida <= 0{
			edificio.target = null_enemigo
			if (edificio.enemigo and array_length(drones_aliados) > 0) or (not edificio.enemigo and array_length(enemigos) > 0)
				turret_target(edificio)
		}
		var enemigo = edificio.target
		if enemigo != null_enemigo and distance_sqr(edificio.center_x, edificio.center_y, enemigo.a, enemigo.b) < edificio_alcance_sqr[edificio.index]{
			edificio.select = radtodeg(-arctan2(edificio.center_x - enemigo.a, enemigo.b - edificio.center_y)) - 90
			change_energia(edificio_energia_consumo[index], edificio)
			edificio.mode = true
			dmg_causado += min(red_power * edificio.fuel, enemigo.vida)
			enemigo.vida -= red_power * edificio.fuel
			var temp_vel = 75 - 25 * edificio.modulo
			edificio.fuel = ((temp_vel - 1) * edificio.fuel + 8) / temp_vel
			draw_set_alpha(red_power * edificio.fuel / 8)
			draw_set_color(c_red)
			draw_line_off(edificio.center_x, edificio.center_y, enemigo.a, enemigo.b)
			draw_set_alpha(1)
			if enemigo.vida <= 0{
				delete_dron(enemigo)
				change_energia(0, edificio)
				edificio.fuel = 1
				edificio.target = null_enemigo
				turret_target(edificio)
			}
		}
		else{
			change_energia(0, edificio)
			edificio.target = null_edificio
			edificio.fuel = 1
		}
	}
}