function scr_refineria_petroleo(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if flujo.liquido = idl_petroleo and edificio.carga_total < edificio_carga_max[index]{
			//Apagar
			if edificio.energia_consumo_max > 0 and red_power = 0{
				change_flujo(0, edificio)
				change_energia(0, edificio)
				encender_luz(false, edificio)
				break
			}
			//Encender
			if not edificio.start{
				change_energia(edificio.energia_consumo_max * (1 - 0.25 * edificio.modulo), edificio)
				change_flujo(edificio.flujo_consumo_max, edificio)
				edificio.start = true
				if edificio.carga[idr_sal] > 0{
					edificio.carga[idr_sal] -= 0.1
					edificio.carga_total -= 0.1
					edificio.proceso += floor(edificio_proceso[index] / 4)
				}
				encender_luz(, edificio)
			}
			edificio.proceso += min(flujo_power, red_power)
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				var a = random(1)
				if a < edificio.select / 100
					edificio.carga[idr_compuesto_incendiario]++
				else{
					a = random(1)
					if a < sqr(1 - abs(edificio.select - 50) / 100)
						edificio.carga[idr_plastico]++
					else
						edificio.carga[idr_piedra_sulfatada]++
				}
				edificio.carga_total++
				change_flujo(0, edificio)
				change_energia(0, edificio)
				edificio.proceso -= edificio_proceso[index]
				edificio.start = false
				edificio.waiting = not mover(edificio)
				encender_luz(false, edificio)
			}
		}
		else{
			change_flujo(0, edificio)
			change_energia(0, edificio)
			encender_luz(false, edificio)
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}