function scr_fabrica_de_concreto(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		var carga = edificio.carga
		if flujo.liquido = idl_agua and carga[idr_arena] > 1 and carga[idr_piedra] > 0 and carga[idr_concreto] < 10{
			//Encender
			if not edificio.start{
				change_flujo(edificio_flujo_consumo[index] * (1 - 0.25 * edificio.modulo), edificio)
				edificio.start = true
			}
			edificio.proceso += flujo_power
			edificio.draw_rot += flujo_power
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				carga[idr_arena] -= 2
				carga[idr_piedra]--
				carga[idr_concreto]++
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