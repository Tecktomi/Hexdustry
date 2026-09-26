function scr_refineria_metales(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		var carga = edificio.carga
		var _aluminio = (carga[idr_alumina] > 2 and carga[idr_aluminio] < 10)
		if (flujo.liquido = idl_acido and ((carga[idr_piedra_cuprica] > 2 and carga[idr_cobre] < 10) or
			(carga[idr_piedra_ferrica] > 2 and carga[idr_hierro] < 10) or
			(carga[idr_uranio_bruto] > 0 and carga[idr_uranio_empobrecido] < 10 and carga[idr_uranio_enriquecido] < 10)))
			or _aluminio{
			//Apagar
			if red_power = 0{
				edificio_encender(edificio, false)
				continue
			}
			//Encender
			if not edificio.start{
				edificio_encender(edificio,, (1 + _aluminio) * edificio.energia_consumo_max, not _aluminio)
				edificio.start = true
			}
			if _aluminio
				edificio.proceso += red_power * (1 + 0.3 * edificio.modulo)
			else
				edificio.proceso += min(red_power, flujo_power) * (1 + 0.3 * edificio.modulo)
			sound_play_edificio(2, edificio.center_x, edificio.center_y)
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				if carga[idr_sal] > 0.1{
					carga[idr_sal] -= 0.1
					edificio.carga_total -= 0.1
					edificio.proceso += edificio_proceso[index] / 4
				}
				edificio.proceso -= edificio_proceso[index]
				edificio.start = false
				if _aluminio{
					carga[idr_alumina] -= 3
					carga[idr_aluminio]++
					edificio.carga_total -= 2
				}
				else if carga[idr_uranio_bruto] > 0{
					repeat(carga[idr_uranio_bruto]){
						if random(1) < 0.99
							carga[idr_uranio_empobrecido]++
						else
							carga[idr_uranio_enriquecido]++
					}
					carga[idr_uranio_bruto] = 0
				}
				else if carga[idr_piedra_ferrica] > 2{
					carga[idr_piedra_ferrica] -= 3
					carga[idr_hierro]++
					edificio.carga_total -= 2
				}
				else if carga[idr_piedra_cuprica] > 2{
					carga[idr_piedra_cuprica] -= 3
					carga[idr_cobre]++
					edificio.carga_total -= 2
				}
				edificio.waiting = not mover(edificio)
				edificio_encender(edificio, false)
			}
		}
		else
			edificio_encender(edificio, false)
		//Vaciar interior
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}