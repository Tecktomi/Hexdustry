function scr_ensambladora(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red, red_power = red.eficiencia
		if edificio.carga[id_cobre] > 0 and edificio.carga[id_silicio] > 0 and edificio.carga[id_electronico] < 10{
			//Encender
			if not edificio.start{
				change_energia(edificio_energia_consumo[index], edificio)
				edificio.start = true
			}
			edificio.proceso += red_power
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				edificio.carga[id_cobre]--
				edificio.carga[id_silicio]--
				edificio.carga[id_electronico]++
				edificio.carga_total--
				edificio.proceso -= edificio_proceso[index]
				edificio.start = false
				change_energia(0, edificio)
				edificio.waiting = not mover(edificio.a, edificio.b)
			}
		}
		else
			change_energia(0, edificio)
	}
}