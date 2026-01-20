function scr_planta_enriquecimiento(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if edificio.carga[idr_uranio_enriquecido] = 20 and edificio.carga[idr_uranio_empobrecido] = 1{
			if in(flujo.liquido, -1, idl_agua, idl_agua_salada){
				//Encender
				if not edificio.start{
					change_energia(edificio_energia_consumo[index], edificio)
					change_flujo(edificio_flujo_consumo[index], edificio)
					edificio.start = true
					encender_luz(, edificio)
				}
				edificio.proceso = max(0, edificio.proceso + 4 * (red_power - 0.5) * (flujo_power - 0.5)) * (1 + 0.3 * edificio.modulo)
				sound_play_edificio(0, edificio.center_x, edificio.center_y)
				//Producir / apagar
				if edificio.proceso >= edificio_proceso[index]{
					edificio.proceso -= edificio_proceso[index]
					edificio.start = false
					edificio.carga[idr_uranio_enriquecido]++
					edificio.carga[idr_uranio_empobrecido]--
					edificio.waiting = not mover(edificio)
					change_energia(0, edificio)
					change_flujo(0, edificio)
					encender_luz(false, edificio)
				}
			}
			else
				edificio.proceso = max(0, edificio.proceso - 1)
		}
		else if edificio.carga[idr_uranio_enriquecido] > 20
			edificio.waiting = not mover(edificio)
	}
}