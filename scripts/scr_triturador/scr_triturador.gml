function scr_triturador(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo
		if edificio.carga[idr_piedra] > 0 and edificio.carga[idr_arena] < 10{
			//Encender
			if not edificio.start{
				edificio_encender(edificio,,, false)
				edificio.start = true
			}
			edificio.proceso += red_power * (1 + 0.3 * edificio.modulo)
			if flujo.liquido = idl_lubricante{
				change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.proceso += 0.6 * flujo.eficiencia
			}
			sound_play_edificio(1, edificio.center_x, edificio.center_y)
			//Producir / apagar
			if edificio.proceso >= edificio_proceso[index]{
				edificio.proceso -= edificio_proceso[index]
				edificio.start = false
				if edificio.carga[idr_piedra] > 0
					edificio.carga[idr_piedra]--
				edificio.carga[idr_arena]++
				edificio.waiting = not mover(edificio)
				edificio_encender(edificio, false,, false)
			}
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}