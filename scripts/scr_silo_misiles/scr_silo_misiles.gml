function scr_silo_misiles(edificio = control.null_edificio){
	with control{
		if edificio.select = -1
			exit
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		var tiempo_max = edificio.array_real[1]
		if not edificio.mode{
			//Cargar materiales y energía
			if edificio.proceso < tiempo_max{
				var flag = true
				for(var b = 0; b < array_length(misiles_precio_id[edificio.select]); b++)
					if edificio.carga[misiles_precio_id[edificio.select, b]] < misiles_precio_num[edificio.select, b]{
						flag = false
						break
					}
				if flag{
					change_energia(edificio_energia_consumo[index], edificio)
					edificio.proceso += red_power
				}
				else
					change_energia(0, edificio)
			}
			else
				change_energia(0, edificio)
			//Cargar combustible
			if edificio.array_real[0] <= 0
				change_flujo(0, edificio)
			else{
				change_flujo(edificio_flujo_consumo[index], edificio)
				if edificio.flujo.liquido = idl_petroleo
					edificio.array_real[0] -= 4 * flujo_power
			}
			//Terminar misil
			if (edificio.proceso >= tiempo_max and edificio.array_real[0] <= 0) or (cheat and string_ends_with(keyboard_string, "misil")){
				keyboard_string = ""
				edificio.mode = true
				change_energia(0, edificio)
				change_flujo(0, edificio)
			}
		}
		if edificio.mode{
			//Misil de Crucero
			if edificio.select = 0 and edificio.array_real[2] != -1{
				if --edificio.fuel > 160
					for(var a = 0; a < 2; a++){
						var dir = random_range(a * pi, (a + 1) * pi)
						array_push(humos, add_humo(edificio.center_x, edificio.center_y, edificio.a, edificio.b, cos(dir), sin(dir), irandom_range(120, 180)))
					}
				if edificio.fuel = 0{
					explosion(edificio.array_real[2] + random_range(-10, 10), edificio.array_real[3] + random_range(-10, 10),, edificio.enemigo)
					clear_silo_de_misiles(edificio)
				}
			}
			//Misil de Racimo
			else if edificio.select = 1 and edificio.array_real[2] != -1{
				if --edificio.fuel > 140
					for(var a = 0; a < 2; a++){
						var dir = random_range(a * pi, (a + 1) * pi)
						array_push(humos, add_humo(edificio.center_x, edificio.center_y, edificio.a, edificio.b, cos(dir), sin(dir), irandom_range(120, 180)))
					}
				if edificio.fuel < 50 and edificio.fuel mod 10 = 0{
					explosion(edificio.array_real[2] + random_range(-50, 50), edificio.array_real[3] + random_range(-50, 50),, edificio.enemigo)
					if edificio.fuel = 0
						clear_silo_de_misiles(edificio)
				}
			}
			//Misil Nuclear
			else if edificio.select = 2{
				if edificio.fuel = 0{
					audio_play_sound(snd_rocket, 0, false)
					edificio.fuel = 450
					win = 1
					mision_camara_step = 60
					mision_actual = 0
					mision_camara_x[0] = edificio.center_x
					mision_camara_y[0] = edificio.center_y
					mision_camara_x_start = camx
					mision_camara_y_start = camy
				}
				else{
					if --edificio.fuel > 300
						for(var a = 0; a < 2; a++){
							var dir = random_range(a * pi, (a + 1) * pi)
							array_push(humos, add_humo(edificio.center_x, edificio.center_y, edificio.a, edificio.b, cos(dir), sin(dir), irandom_range(120, 180)))
						}
					if edificio.fuel = 0{
						nuclear_x = -1
						nuclear_y = -1
						nuclear_step = 300
						audio_play_sound(snd_nuclear_explosion, 0, false)
						clear_silo_de_misiles(edificio)
					}
				}
			}
		}
	}
}