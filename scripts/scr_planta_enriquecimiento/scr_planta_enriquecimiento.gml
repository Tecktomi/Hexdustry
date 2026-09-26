function scr_planta_enriquecimiento(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		var carga = edificio.carga
		if carga[idr_uranio_enriquecido] = 20 and carga[idr_uranio_empobrecido] = 1{
			if flujo.liquido = -1 or tag_liquido_agua[flujo.liquido]{
				//Encender
				if not edificio.start{
					edificio_encender(edificio)
					edificio.start = true
				}
				edificio.proceso = max(0, edificio.proceso + 4 * (red_power - 0.5) * (flujo_power - 0.5)) * (1 + 0.3 * edificio.modulo)
				sound_play_edificio(0, edificio.center_x, edificio.center_y)
				//Producir / apagar
				if edificio.proceso >= edificio_proceso[index]{
					edificio.proceso -= edificio_proceso[index]
					edificio.start = false
					carga[idr_uranio_enriquecido]++
					carga[idr_uranio_empobrecido]--
					edificio.waiting = not mover(edificio)
					edificio_encender(edificio, false)
				}
			}
			else
				edificio.proceso = max(0, edificio.proceso - 1)
		}
		else if carga[idr_uranio_enriquecido] > 20
			edificio.waiting = not mover(edificio)
	}
}