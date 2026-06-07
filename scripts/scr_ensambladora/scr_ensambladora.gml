function scr_ensambladora(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		if not edificio.mode{
			if edificio.carga[idr_cobre] > 0 and edificio.carga[idr_silicio] > 0 and edificio.carga[idr_electronicos] < 10{
				//Encender
				if not edificio.start{
					edificio_encender(edificio,, false, false)
					change_energia(edificio_energia_consumo[index] * (1 - 0.25 * edificio.modulo), edificio)
					edificio.start = true
				}
				edificio.proceso += red_power
				//Producir / Apagar
				if edificio.proceso >= edificio_proceso[index]{
					edificio.carga[idr_cobre]--
					edificio.carga[idr_silicio]--
					edificio.carga[idr_electronicos]++
					edificio.carga_total--
					edificio.proceso -= edificio_proceso[index]
					edificio.start = false
					edificio_encender(edificio, false,, false)
					edificio.waiting = not mover(edificio)
				}
			}
			else
				edificio_encender(edificio, false,, false)
		}
		else{
			var temp_edificio = edificio.link
			if edificio.carga[idr_electronicos] + temp_edificio.carga[idr_electronicos] > 0 and
				edificio.carga[idr_plastico] + temp_edificio.carga[idr_plastico] > 0 and
				edificio.carga[idr_bateria] + temp_edificio.carga[idr_bateria] > 0 and
				edificio.carga[idr_modulos] + temp_edificio.carga[idr_modulos] < 10{
				//Encender
				if not edificio.start{
					change_energia(edificio_energia_consumo[index] * (1 - 0.25 * edificio.modulo), edificio)
					change_energia(edificio_energia_consumo[index] * (1 - 0.25 * temp_edificio.modulo), temp_edificio)
					edificio.start = true
					temp_edificio.start = true
					edificio_encender(edificio,, false, false)
					edificio_encender(temp_edificio,, false, false)
				}
				edificio.proceso += red_power / 2
				//Producir / Apagar
				if edificio.proceso >= edificio_proceso[index]{
					if edificio.carga[idr_electronicos] > 0{
						edificio.carga[idr_electronicos]--
						edificio.carga_total--
					}
					else{
						temp_edificio.carga[idr_electronicos]--
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
					if edificio.carga[idr_modulos] < temp_edificio.carga[idr_modulos]{
						edificio.carga[idr_modulos]++
						edificio.carga_total++
						edificio.waiting = not mover(edificio)
					}
					else{
						temp_edificio.carga[idr_modulos]++
						temp_edificio.carga_total++
						temp_edificio.waiting = not mover(temp_edificio)
					}
					edificio.proceso -= edificio_proceso[index]
					edificio.start = false
					temp_edificio.start = false
					edificio_encender(edificio, false,, false)
					edificio_encender(temp_edificio, false,, false)
				}
				temp_edificio.proceso = edificio.proceso
			}
			else{
				edificio_encender(edificio, false,, false)
				edificio_encender(temp_edificio, false,, false)
			}
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}