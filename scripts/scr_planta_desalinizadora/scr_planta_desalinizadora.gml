function scr_planta_desalinizadora(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if flujo.liquido = idl_agua_salada and edificio.carga[idr_sal] < 10 and edificio.carga[idr_barril_con_agua] < 10 and red_power > 0 and flujo_power > 0{
			//Encender
			if not edificio.start{
				edificio_encender(edificio,,,, false)
				edificio.start = true
			}
			edificio.proceso += min(flujo_power, red_power)
			edificio.draw_rot += min(flujo_power, red_power)
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				edificio.carga[idr_sal] += 0.1 + 0.05 * edificio.modulo
				edificio.carga[idr_barril_con_agua]++
				edificio.carga_total += 1.1 + 0.05 * edificio.modulo
				edificio.proceso -= edificio_proceso[index]
				edificio.start = false
				edificio.waiting = not mover(edificio)
				edificio_encender(edificio, false,,, false)
			}
		}
		else{
			edificio_encender(edificio, false,,, false)
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}