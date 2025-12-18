function scr_fabrica_drones(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		if edificio.select >= 0 and array_length(drones_aliados) < 8{
			var flag = true
			for(var b = array_length(dron_precio_id[edificio.select]) - 1; b >= 0; b--)
				if edificio.carga[dron_precio_id[edificio.select, b]] < dron_precio_num[edificio.select, b]{
					flag = false
					break
				}
			if flag{
				//Encender
				if edificio.proceso < 0{
					change_energia(edificio_energia_consumo[index], edificio)
					edificio.proceso++
				}
				edificio.proceso += red_power
				//Producir / Apagar
				if edificio.proceso >= edificio_proceso[index]{
					edificio.proceso = -1
					for(var b = array_length(dron_precio_id[edificio.select]) - 1; b >= 0; b--){
						edificio.carga_total -= dron_precio_num[edificio.select, b]
						edificio.carga[dron_precio_id[edificio.select, b]] -= dron_precio_num[edificio.select, b]
					}
					var dron = add_dron(edificio.a + random(0.1), edificio.b + random(0.1), edificio.select, true)
					dron.pointer = array_length(drones_aliados)
					array_push(drones_aliados, dron)
					dron.a += random(5)
					dron.b += random(5)
					edificio.waiting = not mover_in(edificio)
					change_energia(0, edificio)
				}
			}
		}
		else
			change_energia(0, edificio)
	}
}