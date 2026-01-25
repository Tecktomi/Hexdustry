function atacar_dron(dron = control.null_dron, edificio = control.null_edificio, target = control.null_dron){
	with control{
		//Ataque araña
		if dron.index = idd_arana{
			var aa = dron.x, bb = dron.y
			draw_set_color(c_red)
			if edificio != null_edificio{
				draw_line_off(aa, bb, edificio.center_x, edificio.center_y)
				if herir_edificio(1, edificio) and dron.a >= 0
					dron.target = edificio_cercano[# dron.a, dron.b]
			}
			else if target != null_dron{
				draw_line_off(aa, bb, target.x, target.y)
				if herir_dron(1, target)
					dron = null_dron
			}
			return false
		}
		//Ataque explosivo
		else if dron.index = idd_explosivo{
			explosion(dron.x, dron.y, edificio, dron.enemigo, 25_000, 2000)
			delete_dron(dron)
			return true
		}
		//Ataque tanque
		else if dron.index = idd_tanque{
			if ++dron.step = 120{
				dron.step = 0
				if target != null_dron or edificio != null_edificio{
					var aa = dron.x, bb = dron.y, vel = 25
					if target != null_dron
						var target_x = target.x, target_y = target.y
					else{
						target_x = edificio.center_x
						target_y = edificio.center_y
					}
					var dis = distance(aa, bb, target_x, target_y)
					var municion = add_municion(aa, bb, vel * (target_x - aa) / dis, vel * (target_y - bb) / dis, 1, dis / vel, 30, target, edificio, dron.enemigo)
					array_push(municiones, municion)
				}
			}
			return false
		}
		//Ataque Helicoptero
		else if dron.index = idd_helicoptero{
			if in(++dron.step, 110, 120){
				if dron.step = 120
					dron.step = 0
				if target != null_dron or edificio != null_edificio{
					var aa = dron.x, bb = dron.y, vel = 15
					if target != null_dron
						var target_x = target.x, target_y = target.y
					else{
						target_x = edificio.center_x
						target_y = edificio.center_y
					}
					var dis = distance(aa, bb, target_x, target_y)
					var municion = add_municion(aa, bb, vel * (target_x - aa) / dis, vel * (target_y - bb) / dis, 1, dis / vel, 25, target, edificio, dron.enemigo)
					array_push(municiones, municion)
				}
			}
			return false
		}
		//Ataque Titán
		else if dron.index = idd_titan{
			if in(++dron.step, 75, 90, 105, 120){
				if dron.step = 120
					dron.step = 0
				if target != null_dron or edificio != null_edificio{
					var aa = dron.x, bb = dron.y, vel = 25
					if target != null_dron
						var target_x = target.x, target_y = target.y
					else{
						target_x = edificio.center_x
						target_y = edificio.center_y
					}
					var dis = distance(aa, bb, target_x, target_y)
					var municion = add_municion(aa, bb, vel * (target_x - aa) / dis, vel * (target_y - bb) / dis, 1, dis / vel, 50, target, edificio, dron.enemigo)
					array_push(municiones, municion)
				}
			}
			return false
		}
		//Ataque bombardero
		else if dron.index = idd_bombardero{
			if in(dron.step, 0, 80){
				explosion(dron.x + random_range(-5, 5), dron.y + random_range(-5, 5), edificio, dron.enemigo, 25_000, 500, true)
				dron.step = 90
			}
			return false
		}
		return false
	}
}