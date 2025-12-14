function scr_fabrica_drones(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red, red_power = red.eficiencia
		if edificio.select >= 0 and array_length(drones_aliados) < 8{
			var size = array_length(dron_precio_id[edificio.select]), flag = false
			for(var b = 0; b < size; b++)
				if edificio.carga[dron_precio_id[edificio.select, b]] < dron_precio_num[edificio.select, b]{
					flag = true
					break
				}
			if flag
				return
			//Encender
			if edificio.proceso < 0{
				change_energia(edificio_energia_consumo[index], edificio)
				edificio.proceso++
			}
			edificio.proceso += red_power
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				edificio.proceso -= edificio_proceso[index] + 1
				for(var b = 0; b < size; b++){
					edificio.carga_total -= dron_precio_num[edificio.select, b]
					edificio.carga[dron_precio_id[edificio.select, b]] -= dron_precio_num[edificio.select, b]
				}
				var dron = add_dron(edificio.a, edificio.b, edificio.select, true)
				dron.pointer = array_length(drones_aliados)
				array_push(drones_aliados, dron)
				edificio.waiting = not mover_in(edificio)
				change_energia(0, edificio)
			}
		}
		else
			change_energia(0, edificio)
	}
}