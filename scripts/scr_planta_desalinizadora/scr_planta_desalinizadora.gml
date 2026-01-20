function scr_planta_desalinizadora(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if flujo.liquido = idl_agua_salada and edificio.carga[idr_sal] < 10 and edificio.carga[idr_barril_agua] < 10 and red_power > 0 and flujo_power > 0{
			//Encender
			if not edificio.start{
				change_energia(edificio_energia_consumo[index], edificio)
				change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.start = true
				encender_luz(, edificio)
			}
			edificio.proceso += min(flujo_power, red_power)
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				edificio.carga[idr_sal] += 0.1 + 0.05 * edificio.modulo
				edificio.carga[idr_barril_agua]++
				edificio.carga_total += 1.1 + 0.05 * edificio.modulo
				edificio.proceso -= edificio_proceso[index]
				edificio.start = false
				edificio.waiting = not mover(edificio)
				change_energia(0, edificio)
				change_flujo(0, edificio)
				encender_luz(false, edificio)
			}
		}
		else{
			change_energia(0, edificio)
			change_flujo(0, edificio)
			encender_luz(false, edificio)
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}