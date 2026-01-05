function scr_refineria_petroleo(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if flujo.liquido = 2 and edificio.carga_total < edificio_carga_max[index]{
			//Apagar
			if edificio.energia_consumo_max > 0 and red_power = 0{
				change_flujo(0, edificio)
				change_energia(0, edificio)
				break
			}
			//Encender
			if edificio.proceso < 0{
				change_energia(edificio.energia_consumo_max, edificio)
				change_flujo(edificio.flujo_consumo_max, edificio)
				edificio.proceso++
				if edificio.carga[id_sal] > 0{
					edificio.carga[id_sal] -= 0.1
					edificio.carga_total -= 0.1
					edificio.proceso += floor(edificio_proceso[index] / 4)
				}
			}
			edificio.proceso += min(flujo_power, red_power)
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				var a = random(1)
				if a < 0.6
					edificio.carga[id_combustible]++
				else if a < 0.9
					edificio.carga[id_plastico]++
				else
					edificio.carga[id_piedra_sulfatada]++
				edificio.carga_total++
				change_flujo(0, edificio)
				change_energia(0, edificio)
				edificio.proceso = -1
				edificio.waiting = not mover(edificio.a, edificio.b)
			}
		}
		else{
			change_flujo(0, edificio)
			change_energia(0, edificio)
		}
	}
}