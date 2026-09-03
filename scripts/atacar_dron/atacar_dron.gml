function atacar_dron(dron = control.null_dron, edificio = control.null_edificio, target = control.null_dron){
	with control{
		var index = dron.index, _jugador = dron.jugador
		//Ataque Araña
		if index = idd_arana{
			if dron.step >= dron_step[index]{
				dron.step = 0
				if target != null_dron or edificio != null_edificio{
					var a = dron.x, b = dron.y, vel = 25
					if target != null_dron
						var target_x = target.x, target_y = target.y
					else{
						target_x = edificio.center_x
						target_y = edificio.center_y
					}
					var dis = point_distance(a, b, target_x, target_y)
					var municion = add_municion(a, b, vel * (target_x - a) / dis, vel * (target_y - b) / dis, municion_tipo_normal, dis / vel, 12,, target, edificio, dron.enemigo,,, _jugador)
					array_push(municiones, municion)
					sound_play(snd_disparo, a, b, 0.1)
				}
			}
			return false
		}
		//Ataque Explosivo
		else if dron.index = idd_kamikaze{
			explosion(dron.x, dron.y, edificio, 500, 2000,, _jugador)
			delete_dron(dron)
			return true
		}
		//Ataque Tanque
		else if index = idd_tanque{
			if dron.step = dron_step[index]{
				dron.step = 0
				if target != null_dron or edificio != null_edificio{
					var a = dron.x, b = dron.y, vel = 25
					if target != null_dron
						var target_x = target.x, target_y = target.y
					else{
						target_x = edificio.center_x
						target_y = edificio.center_y
					}
					var dis = point_distance(a, b, target_x, target_y)
					var municion = add_municion(a, b, vel * (target_x - a) / dis, vel * (target_y - b) / dis, municion_tipo_misil, dis / vel, 30, 60, target, edificio, dron.enemigo,,, _jugador)
					array_push(municiones, municion)
				}
			}
			return false
		}
		//Ataque Helicoptero
		else if index = idd_helicoptero{
			if in(dron.step - dron_step[index], 0, 30){
				if dron.step++ = dron_step[index] + 30
					dron.step = 0
				if target != null_dron or edificio != null_edificio{
					var a = dron.x, b = dron.y, vel = 10
					if target != null_dron
						var target_x = target.x, target_y = target.y
					else{
						target_x = edificio.center_x
						target_y = edificio.center_y
					}
					var dis = point_distance(a, b, target_x, target_y)
					var municion = add_municion(a, b, vel * (target_x - a) / dis, vel * (target_y - b) / dis, municion_tipo_misil, dis / vel, 25, 70, target, edificio, dron.enemigo, true, true, _jugador)
					array_push(municiones, municion)
				}
			}
			if dron.step > dron_step[index] + 30
				dron.step = 0
			return false
		}
		//Ataque Titán
		else if index = idd_titan{
			if in(dron.step - dron_step[index], 0, 15, 30, 45){
				if dron.step++ = dron_step[index] + 45
					dron.step = 0
				if target != null_dron or edificio != null_edificio{
					var a = dron.x, b = dron.y, vel = 10
					if target != null_dron
						var target_x = target.x, target_y = target.y
					else{
						target_x = edificio.center_x
						target_y = edificio.center_y
					}
					var dis = point_distance(a, b, target_x, target_y)
					var municion = add_municion(a, b, vel * (target_x - a) / dis, vel * (target_y - b) / dis, municion_tipo_misil, dis / vel, 100, 50, target, edificio, dron.enemigo, true,, _jugador)
					array_push(municiones, municion)
				}
			}
			if dron.step > dron_step[index] + 45
				dron.step = 0
			return false
		}
		//Ataque Bombardero
		else if index = idd_bombardero{
			if in(dron.step - dron_step[index], 0, 15, 30, 45, 60, 75){
				dron.step++
				explosion(dron.x + random_range(-5, 5), dron.y + random_range(-5, 5), edificio, 100, 500, true, _jugador)
			}
			if dron.step >= dron_step[index] + 75
				dron.step = 0
			return false
		}
		//Ataque Barco
		else if index = idd_barco{
			if dron.step = dron_step[index]{
				dron.step = 0
				if target != null_dron or edificio != null_edificio{
					var a = dron.x, b = dron.y, vel = 20
					if target != null_dron
						var target_x = target.x, target_y = target.y
					else{
						target_x = edificio.center_x
						target_y = edificio.center_y
					}
					var dis = point_distance(a, b, target_x, target_y)
					var municion = add_municion(a, b, vel * (target_x - a) / dis, vel * (target_y - b) / dis, municion_tipo_normal, dis / vel, 20,, target, edificio, dron.enemigo,,, _jugador)
					array_push(municiones, municion)
					sound_play(snd_disparo, a, b, 0.1)
				}
			}
			return false
		}
		//Ataque Destructor
		else if index = idd_destructor{
			if in(dron.step, 0, 20, 40, 60, 80){
				if target != null_dron or edificio != null_edificio{
					var a = dron.x, b = dron.y, vel = 20
					if target != null_dron
						var target_x = target.x, target_y = target.y
					else{
						target_x = edificio.center_x
						target_y = edificio.center_y
					}
					var dis = point_distance(a, b, target_x, target_y)
					var municion = add_municion(a, b, vel * (target_x + random_range(-25, 25) - a) / dis, vel * (target_y + random_range(-25, 25) - b) / dis, municion_tipo_misil, dis / vel, 50, 50, target, edificio, dron.enemigo,,, _jugador)
					array_push(municiones, municion)
				}
			}
			if dron.step >= dron_step[index]
				dron.step = 0
			return false
		}
		return false
	}
}