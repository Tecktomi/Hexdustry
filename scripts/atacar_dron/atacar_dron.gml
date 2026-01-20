function atacar_dron(dron = control.null_enemigo, edificio = control.null_edificio, target = control.null_enemigo, target_enemigo = control.null_enemigo){
	with control{
		var aa = dron.a, bb = dron.b, enemigo = dron.enemigo
		//Ataque araña
		if dron.index = idd_arana{
			draw_set_color(c_red)
			if edificio != null_edificio{
				draw_line_off(aa, bb, edificio.center_x, edificio.center_y)
				if edificio_herir(edificio, 1){
					var temp_complex = xytoab(aa, bb)
					if temp_complex.a >= 0
						dron.target = edificio_cercano[# temp_complex.a, temp_complex.b]
				}
			}
			if target_enemigo != null_enemigo
				target = target_enemigo
			if target != null_enemigo{
				draw_line_off(aa, bb, target.a, target.b)
				if --target.vida <= 0
					delete_dron(target)
			}
			return false
		}
		//Ataque explosivo
		else if dron.index = idd_explosivo{
			explosion(aa, bb, edificio, enemigo, 25_000, 3000)
			delete_dron(dron)
			return true
		}
		//Ataque tanque
		else if dron.index = idd_tanque{
			if ++dron.step = 120{
				dron.step = 0
				var municion
				if edificio != null_edificio{
					var dis = distance(dron.a, dron.b, edificio.center_x, edificio.center_y)
					municion = add_municion(dron.a, dron.b, 25 * (edificio.center_x - dron.a) / dis, 25 * (edificio.center_y - dron.b) / dis, 3, dis / 25, 30,, edificio)
				}
				if target_enemigo != null_enemigo
					target = target_enemigo
				if target != null_enemigo{
					var dis = distance(dron.a, dron.b, target.a, target.b)
					municion = add_municion(dron.a, dron.b, 25 * (target.a - dron.a) / dis, 25 * (target.b - dron.b) / dis, 3, dis / 25, 30, target)
				}
				array_push(municiones, municion)
			}
			return false
		}
		//Ataque Helicoptero
		else if dron.index = idd_helicoptero{
			if in(++dron.step, 110, 120){
				if dron.step = 120
					dron.step = 0
				var municion
				if edificio != null_edificio{
					var dis = distance(dron.a, dron.b, edificio.center_x, edificio.center_y)
					municion = add_municion(dron.a, dron.b, 25 * (edificio.center_x - dron.a) / dis, 25 * (edificio.center_y - dron.b) / dis, 3, dis / 25, 25,, edificio)
				}
				if target_enemigo != null_enemigo
					target = target_enemigo
				if target != null_enemigo{
					var dis = distance(dron.a, dron.b, target.a, target.b)
					municion = add_municion(dron.a, dron.b, 25 * (target.a - dron.a) / dis, 25 * (target.b - dron.b) / dis, 3, dis / 25, 25, target)
				}
				array_push(municiones, municion)
			}
			return false
		}
		//Ataque Titán
		else if dron.index = idd_titan{
			if in(++dron.step, 75, 90, 105, 120){
				if dron.step = 120
					dron.step = 0
				var municion
				if edificio != null_edificio{
					var dis = distance(dron.a, dron.b, edificio.center_x, edificio.center_y)
					municion = add_municion(dron.a, dron.b, 15 * (edificio.center_x - dron.a) / dis, 15 * (edificio.center_y - dron.b) / dis, 3, dis / 15, 50,, edificio)
				}
				if target_enemigo != null_enemigo
					target = target_enemigo
				if target != null_enemigo{
					var dis = distance(dron.a, dron.b, target.a, target.b)
					municion = add_municion(dron.a, dron.b, 15 * (target.a - dron.a) / dis, 15 * (target.b - dron.b) / dis, 3, dis / 15, 50, target)
				}
				array_push(municiones, municion)
			}
			return false
		}
		//Ataque bombardero
		else if dron.index = idd_bombardero{
			if in(dron.step, 0, 80){
				explosion(aa + random_range(-5, 5), bb + random_range(-5, 5), edificio, enemigo, 25_000, 500)
				dron.step = 90
			}
			return false
		}
		return false
	}
}