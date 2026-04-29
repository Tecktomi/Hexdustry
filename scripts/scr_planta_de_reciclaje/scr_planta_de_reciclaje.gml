function scr_planta_de_reciclaje(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if edificio.select >= 0 and flujo.liquido = idl_acido and edificio.carga_total < edificio_carga_max[index]{
			//Apagar
			if red_power = 0{
				change_flujo(0, edificio)
				change_energia(0, edificio)
				encender_luz(false, edificio)
				break
			}
			//Encender
			if not edificio.start{
				change_energia(edificio.energia_consumo_max, edificio)
				change_flujo(edificio.flujo_consumo_max, edificio)
				edificio.start = true
				encender_luz(, edificio)
			}
			edificio.proceso += min(flujo_power, red_power) * (1 + 0.3 * edificio.modulo)
			if edificio.mode
				var time_max = max(5, edificio_precio[edificio.select] * 5)
			else
				time_max = dron_time[edificio.select]
			//Producir / Apagar
			if edificio.proceso >= time_max{
				if edificio.mode{
					for(var a = array_length(edificio_precio_id[edificio.select]) - 1; a >= 0; a--){
						var b = round(edificio_precio_num[edificio.select, a] / 2)
						edificio.carga[edificio_precio_id[edificio.select, a]] += b
						edificio.carga_total += b
					}
				}
				else
					for(var a = array_length(dron_precio_id[edificio.select]) - 1; a >= 0; a--){
						var b = round(dron_precio_num[edificio.select, a] / 2)
						edificio.carga[dron_precio_id[edificio.select, a]] += b
						edificio.carga_total += b
					}
				change_flujo(0, edificio)
				change_energia(0, edificio)
				edificio.proceso -= time_max
				edificio.select = -1
				edificio.start = false
				edificio.waiting = not mover(edificio)
				encender_luz(false, edificio)
			}
		}
		else{
			change_flujo(0, edificio)
			change_energia(0, edificio)
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}