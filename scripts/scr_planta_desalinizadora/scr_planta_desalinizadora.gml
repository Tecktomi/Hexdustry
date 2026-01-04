function scr_planta_desalinizadora(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if flujo.liquido = 4 and edificio.carga[id_sal] < 10 and edificio.carga[id_barril_agua] < 10 and red_power > 0 and flujo_power > 0{
			//Encender
			if edificio.proceso < 0{
				change_energia(edificio_energia_consumo[index], edificio)
				change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.proceso++
			}
			edificio.proceso += min(flujo_power, red_power)
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				if random(1) < 0.1{
					edificio.carga[id_sal]++
					edificio.carga_total++
				}
				edificio.carga[id_barril_agua]++
				edificio.carga_total++
				edificio.proceso = -1
				edificio.waiting = not mover(edificio.a, edificio.b)
				change_energia(0, edificio)
				change_flujo(0, edificio)
			}
		}
		else{
			change_energia(0, edificio)
			change_flujo(0, edificio)
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio.a, edificio.b)
	}
}