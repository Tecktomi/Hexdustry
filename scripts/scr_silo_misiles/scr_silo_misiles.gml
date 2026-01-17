function scr_silo_misiles(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if edificio.proceso < edificio_proceso[index]{
			var flag = true
			for(var b = 0; b < array_length(edificio_input_id[index]); b++)
				if edificio.carga[edificio_input_id[index, b]] < edificio_input_num[index, b]{
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
		if edificio.select >= 4000
			change_flujo(0, edificio)
		else{
			change_flujo(edificio_flujo_consumo[index], edificio)
			if edificio.flujo.liquido = 2
				edificio.select += 4 * flujo_power
		}
		if edificio.fuel = 0 and ((edificio.proceso >= edificio_proceso[index] and edificio.select >= 4000) or (cheat and string_ends_with(keyboard_string, "misil"))){
			audio_play_sound(snd_rocket, 0, false)
			edificio.fuel = 450
			edificio.select = 0
			for(var b = 0; b < array_length(edificio_input_id[index]); b++)
				edificio.carga[edificio_input_id[index, b]] = 0
			edificio.proceso = 0
			win = 1
			mision_camara_step = 60
			mision_actual = 0
			mision_camara_x[0] = edificio.x
			mision_camara_y[0] = edificio.y
			mision_camara_x_start = camx
			mision_camara_y_start = camy
			change_energia(0, edificio)
			change_flujo(0, edificio)
		}
		if edificio.fuel > 0{
			if --edificio.fuel > 300
				for(var a = 0; a < 2; a++){
					var dir = random_range(a * pi, (a + 1) * pi)
					array_push(humos, add_humo(edificio.x + 8, edificio.y + 14, edificio.a, edificio.b, cos(dir), sin(dir), irandom_range(120, 180)))
				}
			if edificio.fuel = 0{
				nuclear_x = -1
				nuclear_y = -1
				nuclear_step = 300
				audio_play_sound(snd_nuclear_explosion, 0, false)
			}
		}
	}
}