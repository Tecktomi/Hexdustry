function scr_fabrica_drones(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if edificio.select >= 0 and not edificio.waiting_dron{
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
					edificio_encender(edificio,,, index = id_fabrica_de_drones_grande)
					edificio.start = true
				}
				if index = id_fabrica_de_drones_grande
					edificio.proceso += min(red_power, flujo_power) * (1 + 0.3 * edificio.modulo)
				else
					edificio.proceso += red_power * (1 + 0.3 * edificio.modulo)
				//Producir / Apagar
				if edificio.proceso >= dron_time[edificio.select]{
					edificio.start = false
					for(var b = array_length(dron_precio_id[edificio.select]) - 1; b >= 0; b--){
						var c = dron_precio_num[edificio.select, b]
						edificio.carga_total -= c
						edificio.carga[dron_precio_id[edificio.select, b]] -= c
					}
					edificio.waiting_dron = true
					if mover_carga(edificio)
						edificio.proceso -= dron_time[edificio.select]
					else
						edificio.proceso--
					edificio_encender(edificio, false,, index = id_fabrica_de_drones_grande)
				}
			}
		}
		else
			edificio_encender(edificio, false,, (index = id_fabrica_de_drones_grande))
	}
}