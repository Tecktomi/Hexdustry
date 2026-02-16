function scr_fabrica_drones(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if edificio.select >= 0 and array_length(drones_aliados) < 8 + 2 * nucleo.modulo{
			var flag = true
			for(var b = array_length(dron_precio_id[edificio.select]) - 1; b >= 0; b--)
				if edificio.carga[dron_precio_id[edificio.select, b]] < dron_precio_num[edificio.select, b]{
					flag = false
					break
				}
			if flag and index = id_fabrica_de_drones_grande and flujo.liquido != idl_acido
				flag = false
			if flag{
				//Encender
				if not edificio.start{
					change_energia(edificio_energia_consumo[index], edificio)
					if index = id_fabrica_de_drones_grande
						change_flujo(edificio_flujo_consumo[index], edificio)
					encender_luz(, edificio)
					edificio.start = true
				}
				if index = id_fabrica_de_drones_grande
					edificio.proceso += red_power * flujo_power * (1 + 0.3 * edificio.modulo)
				else
					edificio.proceso += red_power * (1 + 0.3 * edificio.modulo)
				//Producir / Apagar
				if edificio.proceso >= dron_time[edificio.select]{
					edificio.proceso -= dron_time[edificio.select]
					edificio.start = false
					for(var b = array_length(dron_precio_id[edificio.select]) - 1; b >= 0; b--){
						var c = dron_precio_num[edificio.select, b]
						edificio.carga_total -= c
						edificio.carga[dron_precio_id[edificio.select, b]] -= c
					}
					edificio.waiting = mover_carga(edificio) and not mover_in(edificio)
					change_energia(0, edificio)
					if index = id_fabrica_de_drones_grande
						change_flujo(0, edificio)
					encender_luz(false, edificio)
				}
			}
		}
		else{
			change_energia(0, edificio)
			if index = id_fabrica_de_drones_grande
				change_flujo(0, edificio)
			encender_luz(false, edificio)
		}
	}
}