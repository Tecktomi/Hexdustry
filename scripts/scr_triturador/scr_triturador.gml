function scr_triturador(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		if edificio.carga[id_piedra] > 0 and edificio.carga[id_arena] < 10{
			//Encender
			if not edificio.start{
				change_energia(edificio_energia_consumo[index], edificio)
				edificio.start = true
			}
			edificio.proceso += red_power * (1 + 0.3 * edificio.modulo)
			sound_play_edificio(1, edificio.x, edificio.y)
			//Producir / apagar
			if edificio.proceso >= edificio_proceso[index]{
				edificio.proceso -= edificio_proceso[index]
				edificio.start = false
				if edificio.carga[id_piedra] > 0
					edificio.carga[id_piedra]--
				edificio.carga[id_arena]++
				edificio.waiting = not mover(edificio)
				change_energia(0, edificio)
			}
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}