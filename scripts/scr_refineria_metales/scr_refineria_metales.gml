function scr_refineria_metales(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red, red_power = red.eficiencia
		if edificio_flujo[index]
			var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if flujo.liquido = 1 and (edificio.carga[9] > 2 or edificio.carga[10] > 2 or edificio.carga[17] > 0){
			//Apagar
			if red_power = 0{
				change_flujo(0, edificio)
				change_energia(0, edificio)
				continue
			}
			//Encender
			if edificio.proceso < 0{
				change_energia(edificio_energia_consumo[index], edificio)
				change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.proceso++
			}
			edificio.proceso += red_power * flujo_power
			sound_play_edificio(2, edificio.x, edificio.y)
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				edificio.proceso = -1
				if edificio.carga[17] > 0{
					repeat(edificio.carga[17]){
						if random(1) < 0.99
							edificio.carga[19]++
						else
							edificio.carga[18]++
					}
					edificio.carga[17] = 0
				}
				else if edificio.carga[10] > 2{
					edificio.carga[10] -= 3
					edificio.carga[3]++
				}
				else if edificio.carga[9] > 2{
					edificio.carga[9] -= 3
					edificio.carga[0]++
				}
				edificio.carga_total -= 2
				edificio.waiting = not mover(edificio.a, edificio.b)
				change_energia(0, edificio)
				change_flujo(0, edificio)
			}
		}
		else{
			change_flujo(0, edificio)
			change_energia(0, edificio)
		}
		//Vaciar interior
		if edificio.waiting and edificio.carga[18] > 0 or edificio.carga[19] > 0
			edificio.waiting = not mover(edificio.a, edificio.b)
	}
}