function scr_planta_de_reciclaje(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if edificio.select >= 0 and flujo.liquido = idl_acido and edificio.carga_total < edificio_carga_max[index]{
			//Apagar
			if red_power = 0{
				edificio_encender(edificio, false)
				break
			}
			//Encender
			if not edificio.start{
				edificio_encender(edificio)
				edificio.start = true
			}
			edificio.proceso += min(flujo_power, red_power) * (1 + 0.3 * edificio.modulo)
			if edificio.mode
				var time_max = max(5, edificio_precio[edificio.select] * 5)
			else
				time_max = dron_time[edificio.select]
			//Producir / Apagar
			if edificio.proceso >= time_max{
				var a, b
				if edificio.mode{
					for(a = array_length(edificio_precio_id[edificio.select]) - 1; a >= 0; a--){
						b = round(edificio_precio_num[edificio.select, a] / 2)
						edificio.carga[edificio_precio_id[edificio.select, a]] += b
						edificio.carga_total += b
					}
				}
				else
					for(a = array_length(dron_precio_id[edificio.select]) - 1; a >= 0; a--){
						b = round(dron_precio_num[edificio.select, a] / 2)
						edificio.carga[dron_precio_id[edificio.select, a]] += b
						edificio.carga_total += b
					}
				edificio_encender(edificio, false)
				edificio.proceso -= time_max
				edificio.select = -1
				edificio.start = false
				edificio.waiting = not mover(edificio)
			}
		}
		else
			edificio_encender(edificio, false)
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}