function scr_planta_quimica(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		//Está entregando fluído
		if edificio.fuel > 0{
			edificio.fuel--
			if edificio.fuel = 0
				change_flujo(0, edificio)
		}
		if (edificio.select = 0 and edificio.carga[id_piedra_sulfatada] > 0 and in(flujo.liquido, -1, 1) and flujo.almacen < flujo.almacen_max) or
			(edificio.select = 1 and flujo.liquido = 1 and edificio.carga[id_combustible] > 0 and edificio.carga[id_explosivo] < 10) or
			(edificio.select = 2 and flujo.liquido = 1 and edificio.carga[id_cobre] > 0 and edificio.carga[id_baterias] < 10){
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
				if edificio.carga[id_sal] > 0{
					edificio.carga[id_sal] -= 0.1
					edificio.carga_total -= 0.1
					edificio.proceso += floor(edificio_proceso[index] / 4)
				}
			}
			if edificio.flujo_consumo_max > 0 and edificio.energia_consumo_max > 0
				edificio.proceso += min(flujo_power, red_power)
			else if edificio.flujo_consumo_max > 0
				edificio.proceso += flujo_power
			else if edificio.energia_consumo_max > 0
				edificio.proceso += red_power
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				//Ácido
				if edificio.select = 0{
					edificio.carga[id_piedra_sulfatada]--
					edificio.carga_total--
					flujo.liquido = 1
					edificio.fuel = 60
					mover_in(edificio)
				}
				//Explosivo
				else if edificio.select = 1{
					edificio.carga[id_combustible]--
					edificio.carga[id_explosivo]++
				}
				//Baterías
				else if edificio.select = 2{
					edificio.carga[id_cobre] -= 2
					edificio.carga[id_baterias]++
					edificio.carga_total--
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