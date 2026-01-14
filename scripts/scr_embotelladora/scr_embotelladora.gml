function scr_embotelladora(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		//Está entregando flujo
		if edificio.fuel > 0{
			edificio.fuel--
			if edificio.fuel = 0
				change_flujo(0, edificio)
		}
		else{
			//Vaciar barriles
			if edificio.mode and flujo.almacen < flujo.almacen_max and (
				(in(flujo.liquido, -1, 0) and edificio.carga[id_barril_agua] > 0) or
				(in(flujo.liquido, -1, 1) and edificio.carga[id_barril_acido] > 0) or
				(in(flujo.liquido, -1, 2) and edificio.carga[id_barril_petroleo] > 0) or
				(in(flujo.liquido, -1, 3) and edificio.carga[id_barril_lava] > 0) or
				(in(flujo.liquido, -1, 4) and edificio.carga[id_barril_agua_salada] > 0)){
				edificio.proceso++
				//Producir / apagar
				if edificio.proceso >= edificio_proceso[index]{
					edificio.proceso = 0
					if edificio.carga[id_barril_agua] > 0{
						edificio.carga[id_barril_agua]--
						flujo.liquido = 0
					}
					else if edificio.carga[id_barril_acido] > 0{
						edificio.carga[id_barril_acido]--
						flujo.liquido = 1
					}
					else if edificio.carga[id_barril_petroleo] > 0{
						edificio.carga[id_barril_petroleo]--
						flujo.liquido = 2
					}
					else if edificio.carga[id_barril_lava] > 0{
						edificio.carga[id_barril_lava]--
						flujo.liquido = 3
						if not edificio.luz
							encender_luz(1, edificio)
					}
					else if edificio.carga[id_barril_agua_salada] > 0{
						edificio.carga[id_barril_agua_salada]--
						flujo.liquido = 4
					}
					edificio.carga_total--
					change_flujo(edificio.flujo_consumo_max, edificio)
					edificio.fuel = edificio_proceso[index]
					mover_in(edificio)
				}
			}
			//Llenar barriles
			if not edificio.mode{
				if (flujo.liquido = 0 and edificio.carga[id_barril_agua] < 10) or
					(flujo.liquido = 1 and edificio.carga[id_barril_acido] < 10) or
					(flujo.liquido = 2 and edificio.carga[id_barril_petroleo] < 10) or
					(flujo.liquido = 3 and edificio.carga[id_barril_lava] < 10) or
					(flujo.liquido = 4 and edificio.carga[id_barril_agua_salada] < 10){
					if not edificio.start{
						change_flujo(-edificio.flujo_consumo_max, edificio)
						edificio.start = true
					}
					edificio.proceso += flujo_power
					if edificio.proceso >= edificio_proceso[index]{
						if flujo.liquido = 0
							edificio.carga[id_barril_agua]++
						else if flujo.liquido = 1
							edificio.carga[id_barril_acido]++
						else if flujo.liquido = 2
							edificio.carga[id_barril_petroleo]++
						else if flujo.liquido = 3
							edificio.carga[id_barril_lava]++
						else if flujo.liquido = 4
							edificio.carga[id_barril_agua_salada]++
						edificio.carga_total++
						edificio.proceso -= edificio_proceso[index]
						edificio.start = false
						change_flujo(0, edificio)
						edificio.waiting = not mover(edificio.a, edificio.b)
					}
				}
				if edificio.carga_total > 0
					edificio.waiting = not mover(edificio.a, edificio.b)
			}
		}
	}
}