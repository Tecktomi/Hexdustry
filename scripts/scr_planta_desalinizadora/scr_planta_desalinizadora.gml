function scr_planta_desalinizadora(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia, flujo_2 = edificio.flujo_2
		if flujo.liquido = idl_agua_salada and edificio.carga[idr_sal] < 10 and red_power > 0 and flujo_power > 0{
			var poder = min(flujo_power, red_power)
			//Encender
			if not edificio.start{
				edificio_encender(edificio,,,, false)
				edificio.start = true
				var a = -10 * poder - edificio.flujo_2_consumo
				edificio.flujo_2_consumo = -10 * poder
				flujo_2.generacion -= a
			}
			edificio.proceso += poder
			edificio.draw_rot += poder
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				edificio.carga[idr_sal] += 0.1 + 0.05 * edificio.modulo
				edificio.carga_total += 0.1 + 0.05 * edificio.modulo
				edificio.proceso -= edificio_proceso[index]
				edificio.start = false
				edificio.waiting = not mover(edificio)
				edificio_encender(edificio, false,,, false)
			}
		}
		//Apagar
		else{
			edificio_encender(edificio, false,,, false)
			var a = -edificio.flujo_2_consumo
			edificio.flujo_2_consumo = 0
			flujo_2.generacion -= a
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}