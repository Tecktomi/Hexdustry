function scr_ensambladora(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red, red_power = red.eficiencia
		if edificio.carga[0] > 0 and edificio.carga[7] > 0{
			//Encender
			if edificio.proceso < 0{
				change_energia(edificio_energia_consumo[index], edificio)
				edificio.proceso++
			}
			edificio.proceso += red_power
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				edificio.carga[0]--
				edificio.carga[7]--
				edificio.carga[16]++
				edificio.carga_total--
				edificio.proceso = -1
				change_energia(0, edificio)
				edificio.waiting = not mover(edificio.a, edificio.b)
			}
		}
		else
			change_energia(0, edificio)
	}
}