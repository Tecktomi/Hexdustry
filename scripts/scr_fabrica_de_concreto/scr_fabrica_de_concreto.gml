function scr_fabrica_de_concreto(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if flujo.liquido = idl_agua and edificio.carga[idr_arena] > 1 and edificio.carga[idr_piedra] > 0 and edificio.carga[idr_concreto] < 10{
			//Encender
			if not edificio.start{
				change_flujo(edificio_flujo_consumo[index] * (1 - 0.25 * edificio.modulo), edificio)
				edificio.start = true
			}
			edificio.proceso += flujo_power
			edificio.draw_rot += flujo_power
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				edificio.carga[idr_arena] -= 2
				edificio.carga[idr_piedra]--
				edificio.carga[idr_concreto]++
				edificio.carga_total -= 2
				edificio.proceso -= edificio_proceso[index]
				edificio.start = false
				edificio.waiting = not mover(edificio)
				change_flujo(0, edificio)
			}
		}
		else
			change_flujo(0, edificio)
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}