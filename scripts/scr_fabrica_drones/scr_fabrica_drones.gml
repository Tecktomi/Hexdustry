function scr_fabrica_drones(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		if edificio.select >= 0 and array_length(drones_aliados) < 8 + 2 * nucleo.modulo{
			var flag = true
			for(var b = array_length(dron_precio_id[edificio.select]) - 1; b >= 0; b--)
				if edificio.carga[dron_precio_id[edificio.select, b]] < dron_precio_num[edificio.select, b]{
					flag = false
					break
				}
			if flag{
				//Encender
				if not edificio.start{
					change_energia(edificio_energia_consumo[index], edificio)
					encender_luz(, edificio)
					edificio.start = true
				}
				edificio.proceso += red_power * (1 + 0.3 * edificio.modulo)
				//Producir / Apagar
				if edificio.proceso >= dron_time[edificio.select]{
					edificio.proceso -= dron_time[edificio.select]
					edificio.start = false
					for(var b = array_length(dron_precio_id[edificio.select]) - 1; b >= 0; b--){
						edificio.carga_total -= dron_precio_num[edificio.select, b]
						edificio.carga[dron_precio_id[edificio.select, b]] -= dron_precio_num[edificio.select, b]
					}
					var dron = add_dron(edificio.a + random(0.1), edificio.b + random(0.1), edificio.select, false)
					dron.a += random(5)
					dron.b += random(5)
					edificio.waiting = not mover_in(edificio)
					change_energia(0, edificio)
					encender_luz(false, edificio)
				}
			}
		}
		else{
			change_energia(0, edificio)
			encender_luz(false, edificio)
		}
	}
}