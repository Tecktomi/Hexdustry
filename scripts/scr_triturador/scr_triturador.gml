function scr_triturador(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red, red_power = red.eficiencia
		if (edificio.carga[6] > 0 or edificio.carga[9] > 0 or edificio.carga[10] > 0 or edificio.carga[11] > 0) and edificio.carga[5] < 10{
			//Encender
			if edificio.proceso < 0{
				change_energia(edificio_energia_consumo[index], edificio)
				edificio.proceso++
			}
			edificio.proceso += red_power
			sound_play_edificio(1, edificio.x, edificio.y)
			//Producir / apagar
			if edificio.proceso >= edificio_proceso[index]{
				edificio.proceso = -1
				if edificio.carga[6] > 0
					edificio.carga[6]--
				else if edificio.carga[9] > 0
					edificio.carga[9]--
				else if edificio.carga[10] > 0
					edificio.carga[10]--
				else if edificio.carga[11] > 0
					edificio.carga[11]--
				edificio.carga[5]++
				edificio.waiting = not mover(edificio.a, edificio.b)
				change_energia(0, edificio)
			}
		}
	}
}