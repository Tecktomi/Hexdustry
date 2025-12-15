function scr_planta_quimica(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red, red_power = red.eficiencia
		if edificio_flujo[index]
			var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		//Está entregando fluído
		if edificio.fuel > 0{
			edificio.fuel--
			if edificio.fuel = 0
				change_flujo(0, edificio)
		}
		if (edificio.select = 0 and edificio.carga[11] > 0 and in(flujo.liquido, -1, 1) and flujo.almacen < flujo.almacen_max) or
			(edificio.select = 1 and edificio.carga[5] > 0 and (edificio.carga[6] > 0 or edificio.carga[9] > 0 or edificio.carga[10] > 0 or edificio.carga[11] > 0) and edificio.carga[8] < 10 and flujo.liquido = 0) or
			(edificio.select = 2 and edificio.carga[1] > 0 and edificio.carga[11] > 0 and edificio.carga[13] < 10) or
			(edificio.select = 3 and flujo.liquido = 2 and edificio.carga[12] < 10) or
			(edificio.select = 4 and flujo.liquido = 2 and edificio.carga[11] < 10) or
			(edificio.select = 5 and flujo.liquido = 1 and edificio.carga[3] > 0 and edificio.carga[14] < 10) or
			(edificio.select = 6 and flujo.liquido = 2 and edificio.carga[15] < 10){
			//Apagar
			if edificio.energia_consumo_max > 0 and red_power = 0{
				change_flujo(0, edificio)
				change_energia(0, edificio)
				continue
			}
			//Encender
			if edificio.proceso < 0{
				change_energia(edificio.energia_consumo_max, edificio)
				if edificio.flujo_consumo_max > 0
					change_flujo(edificio.flujo_consumo_max, edificio)
				edificio.proceso++
			}
			var c = 1
			if edificio.flujo_consumo_max > 0
				c *= flujo_power
			if edificio.energia_consumo_max > 0
				c *= red_power
			edificio.proceso += c
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				if edificio.select = 0{
					edificio.carga[11]--
					edificio.carga_total -= 3
					flujo.liquido = 1
					edificio.fuel = 60
					mover_in(edificio)
				}
				else if edificio.select = 1{
					edificio.carga[5]--
					if edificio.carga[6] > 0
						edificio.carga[6]--
					else if edificio.carga[9] > 0
						edificio.carga[9]--
					else if edificio.carga[10] > 0
						edificio.carga[10]--
					else if edificio.carga[11] > 0
						edificio.carga[11]--
					edificio.carga[8]++
					edificio.carga_total--
				}
				else if edificio.select = 2{
					edificio.carga[1]--
					edificio.carga[11]--
					edificio.carga[13]++
					edificio.carga_total--
				}
				else if edificio.select = 3{
					edificio.carga[12]++
					edificio.carga_total++
				}
				else if edificio.select = 4{
					edificio.carga[11]++
					edificio.carga_total++
				}
				else if edificio.select = 5{
					edificio.carga[3]--
					edificio.carga[14]++
					edificio.carga_total--
				}
				else if edificio.select = 6{
					edificio.carga[15]++
					edificio.carga_total++
				}
				if edificio.flujo_consumo_max > 0
					change_flujo(0, edificio)
				else
					change_flujo(edificio.flujo_consumo_max, edificio)
				edificio.proceso = -1
				change_energia(0, edificio)
				edificio.waiting = not mover(edificio.a, edificio.b)
			}
		}
		else if edificio.fuel = 0{
			change_flujo(0, edificio)
			change_energia(0, edificio)
		}
	}
}