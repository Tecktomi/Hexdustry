function scr_planta_enriquecimiento(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if edificio.carga[18] = 20 and edificio.carga[19] = 1{
			if flujo.liquido = 0{
				//Encender
				if edificio.proceso < 0{
					change_energia(edificio_energia_consumo[index], edificio)
					change_flujo(edificio_flujo_consumo[index], edificio)
					edificio.proceso++
				}
				edificio.proceso = max(0, edificio.proceso + 4 * (red_power - 0.5) * (flujo_power - 0.5))
				sound_play_edificio(0, edificio.x, edificio.y)
				//Producir / apagar
				if edificio.proceso >= edificio_proceso[index]{
					edificio.proceso = -1
					edificio.carga[18]++
					edificio.carga[19]--
					edificio.waiting = not mover(edificio.a, edificio.b)
					change_energia(0, edificio)
					change_flujo(0, edificio)
				}
			}
			else
				edificio.proceso = max(0, edificio.proceso - 1)
		}
		else if edificio.carga[18] > 20
			edificio.waiting = not mover(edificio.a, edificio.b)
	}
}