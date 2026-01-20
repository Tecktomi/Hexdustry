function scr_refineria_metales(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red, red_power = red.eficiencia
		if edificio_flujo[index]
			var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if flujo.liquido = idl_acido and (edificio.carga[idr_piedra_cuprica] > 2 or edificio.carga[idr_piedra_ferrica] > 2 or edificio.carga[idr_uranio_bruto] > 0){
			//Apagar
			if red_power = 0{
				change_flujo(0, edificio)
				change_energia(0, edificio)
				encender_luz(false, edificio)
				continue
			}
			//Encender
			if not edificio.start{
				change_energia(edificio_energia_consumo[index], edificio)
				change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.start = true
				encender_luz(, edificio)
			}
			edificio.proceso += min(red_power, flujo_power) * (1 + 0.3 * edificio.modulo)
			sound_play_edificio(2, edificio.center_x, edificio.center_y)
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				edificio.proceso -= edificio_proceso[index]
				edificio.start = false
				if edificio.carga[idr_uranio_bruto] > 0{
					repeat(edificio.carga[idr_uranio_bruto]){
						if random(1) < 0.99
							edificio.carga[idr_uranio_empobrecido]++
						else
							edificio.carga[idr_uranio_enriquecido]++
					}
					edificio.carga[idr_uranio_bruto] = 0
				}
				else if edificio.carga[idr_piedra_ferrica] > 2{
					edificio.carga[idr_piedra_ferrica] -= 3
					edificio.carga[idr_hierro]++
				}
				else if edificio.carga[idr_piedra_cuprica] > 2{
					edificio.carga[idr_piedra_cuprica] -= 3
					edificio.carga[idr_cobre]++
				}
				edificio.carga_total -= 2
				edificio.waiting = not mover(edificio)
				change_energia(0, edificio)
				change_flujo(0, edificio)
				encender_luz(false, edificio)
			}
		}
		else{
			change_flujo(0, edificio)
			change_energia(0, edificio)
			encender_luz(false, edificio)
		}
		//Vaciar interior
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}