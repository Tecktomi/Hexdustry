function scr_bomba_hidraulica(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red, red_power = red.eficiencia
		if edificio_flujo[index]
			var flujo = edificio.flujo
		//Está encendido
		if in(flujo.liquido, -1, edificio.select) and red_power > 0{
			change_energia(edificio_energia_consumo[index], edificio)
			if edificio.select = 0
				change_flujo(red_power * edificio_flujo_consumo[index], edificio)
			else
				change_flujo(red_power * edificio_flujo_consumo[index] / 10, edificio)
			flujo.generacion -= edificio.proceso
			if flujo.almacen >= flujo.almacen_max and flujo.generacion >= flujo.consumo{
				change_energia(0, edificio)
				change_flujo(0, edificio)
			}
			if grafic_luz and flujo.liquido != 3 and edificio.select = 3 and not edificio.luz
				for(var b = ds_list_size(flujo.edificios) - 1; b >= 0; b--){
					var temp_edificio = flujo.edificios[b]
					if not temp_edificio.luz{
						temp_edificio.luz = true
						add_luz(temp_edificio.a, temp_edificio.b, 1)
					}
				}
			flujo.liquido = edificio.select
		}
		else{
			change_energia(0, edificio)
			change_flujo(0, edificio)
		}
	}
}