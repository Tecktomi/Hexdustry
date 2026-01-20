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
				(in(flujo.liquido, -1, idl_agua) and edificio.carga[idr_barril_agua] > 0) or
				(in(flujo.liquido, -1, idl_acido) and edificio.carga[idr_barril_acido] > 0) or
				(in(flujo.liquido, -1, idl_petroleo) and edificio.carga[idr_barril_petroleo] > 0) or
				(in(flujo.liquido, -1, idl_lava) and edificio.carga[idr_barril_lava] > 0) or
				(in(flujo.liquido, -1, idl_agua_salada) and edificio.carga[idr_barril_agua_salada] > 0)){
				edificio.proceso++
				//Producir / apagar
				if edificio.proceso >= edificio_proceso[index]{
					edificio.proceso = 0
					if edificio.carga[idr_barril_agua] > 0{
						edificio.carga[idr_barril_agua]--
						flujo.liquido = idl_agua
					}
					else if edificio.carga[idr_barril_acido] > 0{
						edificio.carga[idr_barril_acido]--
						flujo.liquido = idl_acido
					}
					else if edificio.carga[idr_barril_petroleo] > 0{
						edificio.carga[idr_barril_petroleo]--
						flujo.liquido = idl_petroleo
					}
					else if edificio.carga[idr_barril_lava] > 0{
						edificio.carga[idr_barril_lava]--
						flujo.liquido = idl_lava
						if not edificio.luz
							encender_luz(, edificio)
					}
					else if edificio.carga[idr_barril_agua_salada] > 0{
						edificio.carga[idr_barril_agua_salada]--
						flujo.liquido = idl_agua_salada
					}
					edificio.carga_total--
					change_flujo(edificio.flujo_consumo_max, edificio)
					edificio.fuel = edificio_proceso[index]
					mover_in(edificio)
				}
			}
			//Llenar barriles
			if not edificio.mode{
				if (flujo.liquido = idl_agua and edificio.carga[idr_barril_agua] < 10) or
					(flujo.liquido = idl_acido and edificio.carga[idr_barril_acido] < 10) or
					(flujo.liquido = idl_petroleo and edificio.carga[idr_barril_petroleo] < 10) or
					(flujo.liquido = idl_lava and edificio.carga[idr_barril_lava] < 10) or
					(flujo.liquido = idl_agua_salada and edificio.carga[idr_barril_agua_salada] < 10){
					if not edificio.start{
						change_flujo(-edificio.flujo_consumo_max, edificio)
						edificio.start = true
					}
					edificio.proceso += flujo_power
					if edificio.proceso >= edificio_proceso[index]{
						if flujo.liquido = idl_agua
							edificio.carga[idr_barril_agua]++
						else if flujo.liquido = idl_acido
							edificio.carga[idr_barril_acido]++
						else if flujo.liquido = idl_petroleo
							edificio.carga[idr_barril_petroleo]++
						else if flujo.liquido = idl_lava
							edificio.carga[idr_barril_lava]++
						else if flujo.liquido = idl_agua_salada
							edificio.carga[idr_barril_agua_salada]++
						edificio.carga_total++
						edificio.proceso -= edificio_proceso[index]
						edificio.start = false
						change_flujo(0, edificio)
						edificio.waiting = not mover(edificio)
					}
				}
				if edificio.carga_total > 0
					edificio.waiting = not mover(edificio)
			}
		}
	}
}