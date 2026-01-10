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
		if edificio.proceso >= edificio_proceso[index] and edificio.select >= 4000{
			win = 1
			mision_camara_step = 90
			mision_actual = 0
			mision_camara_x[0] = edificio.x
			mision_camara_y[0] = edificio.y
			change_energia(0, edificio)
			change_flujo(0, edificio)
		}
	}
}