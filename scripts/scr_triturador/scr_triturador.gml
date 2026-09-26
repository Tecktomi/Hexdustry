function scr_triturador(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo2 = edificio.flujo_2
		var carga = edificio.carga
		var _aluminio = (carga[idr_bauxita] > 0 and carga[idr_alumina] < 10 and flujo.liquido = idl_agua and flujo.eficiencia > 0)
		if (carga[idr_piedra] > 0 and carga[idr_arena] < 10) or _aluminio {
			//Encender
			var next_proceso = 0
			if _aluminio{
				change_flujo(edificio_flujo_consumo[index], edificio)
				next_proceso = red_power * (1 + 0.3 * edificio.modulo) * flujo.eficiencia
			}
			else
				next_proceso = red_power * (1 + 0.3 * edificio.modulo)
			if flujo2.liquido = idl_lubricante{
				change_flujo(edificio_flujo_2_consumo[index], edificio, flujo2)
				next_proceso *=  1 + 0.4 * flujo2.eficiencia
			}
			if next_proceso > 0 and not edificio.start{
				edificio_encender(edificio)
				edificio.start = true
			}
			edificio.proceso += next_proceso
			sound_play_edificio(1, edificio.center_x, edificio.center_y)
			//Producir / apagar
			if edificio.proceso >= edificio_proceso[index]{
				edificio.proceso -= edificio_proceso[index]
				edificio.start = false
				if carga[idr_bauxita] > 0{
					carga[idr_bauxita]--
					carga[idr_alumina]++
				}
				else if carga[idr_piedra] > 0{
					carga[idr_piedra]--
					carga[idr_arena]++
				}
				edificio.waiting = not mover(edificio)
				edificio_encender(edificio, false)
			}
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}