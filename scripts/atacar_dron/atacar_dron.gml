function atacar_dron(dron = control.null_dron, edificio = control.null_edificio, target = control.null_dron){
	with control{
		var aa = dron.x, bb = dron.y, enemigo = dron.enemigo
		if edificio != null_edificio
			var dis = distance(aa, bb, edificio.center_x, edificio.center_y)
		else if target != null_dron
			dis = distance(aa, bb, target.x, target.y)
		//Ataque araña
		if dron.index = idd_arana{
			draw_set_color(c_red)
			if edificio != null_edificio{
				draw_line_off(aa, bb, edificio.center_x, edificio.center_y)
				if edificio_herir(edificio, 1) and dron.a >= 0
					dron.target = edificio_cercano[# dron.a, dron.b]
			}
			else if target != null_dron{
				draw_line_off(aa, bb, target.x, target.y)
				dmg_recibido += min(1, target.vida)
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
				if edificio != null_edificio
					municion = add_municion(aa, bb, 25 * (edificio.center_x - aa) / dis, 25 * (edificio.center_y - bb) / dis, 3, dis / 25, 30,, edificio)
				else if target != null_dron
					municion = add_municion(aa, bb, 25 * (target.x - aa) / dis, 25 * (target.y - bb) / dis, 3, dis / 25, 30, target)
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
				if edificio != null_edificio
					municion = add_municion(aa, bb, 25 * (edificio.center_x - aa) / dis, 25 * (edificio.center_y - bb) / dis, 3, dis / 25, 25,, edificio)
				else if target != null_dron
					municion = add_municion(aa, bb, 25 * (target.a - aa) / dis, 25 * (target.b - bb) / dis, 3, dis / 25, 25, target)
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
				if edificio != null_edificio
					municion = add_municion(aa, bb, 15 * (edificio.center_x - aa) / dis, 15 * (edificio.center_y - bb) / dis, 3, dis / 15, 50,, edificio)
				else if target != null_dron
					municion = add_municion(aa, bb, 15 * (target.x - aa) / dis, 15 * (target.y - bb) / dis, 3, dis / 15, 50, target)
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