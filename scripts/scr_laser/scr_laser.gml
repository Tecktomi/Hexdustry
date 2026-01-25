function scr_laser(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		if ((image_index mod 10) = (edificio.a mod 10) and edificio.target = null_dron and edificio.target_edificio = null_edificio) or edificio.target.vida <= 0 or edificio.target_edificio.vida <= 0{
			edificio.target = null_dron
			edificio.target_edificio = null_edificio
			if (edificio.enemigo and array_length(drones_aliados) + array_length(edificios) > 0) or (not edificio.enemigo and array_length(enemigos) + array_length(edificios_enemigos) > 0)
				turret_target(edificio)
		}
		var enemigo = edificio.target, enemigo_edificio = edificio.target_edificio
		if enemigo != null_dron
			var target_x = enemigo.x, target_y = enemigo.y
		else if enemigo_edificio != null_edificio{
			target_x = enemigo_edificio.center_x
			target_y = enemigo_edificio.center_y
		}
		if (enemigo != null_dron or enemigo_edificio != null_edificio) and distance_sqr(edificio.center_x, edificio.center_y, target_x, target_y) < edificio_alcance_sqr[edificio.index]{
			edificio.select = radtodeg(-arctan2(edificio.center_x - target_x, target_y - edificio.center_y)) - 90
			change_energia(edificio_energia_consumo[index], edificio)
			edificio.mode = true
			var dmg = red_power * edificio.fuel, temp_vel = 75 - 25 * edificio.modulo
			edificio.fuel = ((temp_vel - 1) * edificio.fuel + 8) / temp_vel
			draw_set_alpha(dmg / 8)
			draw_set_color(c_red)
			draw_line_off(edificio.center_x, edificio.center_y, target_x, target_y)
			draw_set_alpha(1)
			if dmg > 6 and enemigo != null_dron
				aplicar_efecto(1, 60, enemigo)
			if (enemigo != null_dron and herir_dron(dmg, enemigo)) or (enemigo_edificio != null_edificio and herir_edificio(dmg, enemigo_edificio)){
				change_energia(0, edificio)
				edificio.fuel = 0
				edificio.target = null_dron
				edificio.target_edificio = null_edificio
				turret_target(edificio)
			}
		}
		else{
			change_energia(0, edificio)
			edificio.target = null_edificio
			edificio.target_edificio = null_edificio
			edificio.fuel = 0
		}
	}
}