function scr_ensambladora(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		if not edificio.mode{
			if edificio.carga[idr_cobre] > 0 and edificio.carga[idr_silicio] > 0 and edificio.carga[idr_electronico] < 10{
				//Encender
				if not edificio.start{
					change_energia(edificio_energia_consumo[index] * (1 - 0.25 * edificio.modulo), edificio)
					edificio.start = true
					encender_luz(, edificio)
				}
				edificio.proceso += red_power
				//Producir / Apagar
				if edificio.proceso >= edificio_proceso[index]{
					edificio.carga[idr_cobre]--
					edificio.carga[idr_silicio]--
					edificio.carga[idr_electronico]++
					edificio.carga_total--
					edificio.proceso -= edificio_proceso[index]
					edificio.start = false
					change_energia(0, edificio)
					encender_luz(false, edificio)
					edificio.waiting = not mover(edificio)
				}
			}
			else
				change_energia(0, edificio)
		}
		else{
			var temp_edificio = edificio.link
			if edificio.carga[idr_electronico] + temp_edificio.carga[idr_electronico] > 0 and
				edificio.carga[idr_plastico] + temp_edificio.carga[idr_plastico] > 0 and
				edificio.carga[idr_bateria] + temp_edificio.carga[idr_bateria] > 0 and
				edificio.carga[idr_modulo] + temp_edificio.carga[idr_modulo] < 10{
				//Encender
				if not edificio.start{
					change_energia(edificio_energia_consumo[index] * (1 - 0.25 * edificio.modulo), edificio)
					change_energia(edificio_energia_consumo[index] * (1 - 0.25 * temp_edificio.modulo), temp_edificio)
					edificio.start = true
					temp_edificio.start = true
					encender_luz(, edificio)
					encender_luz(, temp_edificio)
				}
				edificio.proceso += red_power / 2
				//Producir / Apagar
				if edificio.proceso >= edificio_proceso[index]{
					if edificio.carga[idr_electronico] > 0{
						edificio.carga[idr_electronico]--
						edificio.carga_total--
					}
					else{
						temp_edificio.carga[idr_electronico]--
						temp_edificio.carga_total--
					}
					if edificio.carga[idr_plastico] > 0{
						edificio.carga[idr_plastico]--
						edificio.carga_total--
					}
					else{
						temp_edificio.carga[idr_plastico]--
						temp_edificio.carga_total--
					}
					if edificio.carga[idr_bateria] > 0{
						edificio.carga[idr_bateria]--
						edificio.carga_total--
					}
					else{
						temp_edificio.carga[idr_bateria]--
						temp_edificio.carga_total--
					}
					if edificio.carga[idr_modulo] < temp_edificio.carga[idr_modulo]{
						edificio.carga[idr_modulo]++
						edificio.carga_total++
						edificio.waiting = not mover(edificio)
					}
					else{
						temp_edificio.carga[idr_modulo]++
						temp_edificio.carga_total++
						temp_edificio.waiting = not mover(temp_edificio)
					}
					edificio.proceso -= edificio_proceso[index]
					edificio.start = false
					temp_edificio.start = false
					change_energia(0, edificio)
					change_energia(0, temp_edificio)
					encender_luz(false, edificio)
					encender_luz(false, temp_edificio)
				}
				temp_edificio.proceso = edificio.proceso
			}
			else{
				change_energia(0, edificio)
				change_energia(0, temp_edificio)
			}
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}