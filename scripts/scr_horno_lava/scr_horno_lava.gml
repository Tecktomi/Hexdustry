function scr_horno_lava(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_flujo[index]
			var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if flujo.liquido = 3 and (edificio.carga[0] > 1 or edificio.carga[3] > 1 or edificio.carga[5] > 1) and edificio.carga[2] < 10 and edificio.carga[4] < 10 and edificio.carga[7] < 10{
			//Encender
			if edificio.proceso < 0{
				change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.proceso++
			}
			edificio.proceso += flujo_power
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				if edificio.carga[5] > 1{
					edificio.carga[5] -= 2
					edificio.carga[7]++
					edificio.carga_total--
					edificio.proceso = -1
				}
				else if edificio.carga[3] > 1{
					edificio.carga[3] -= 2
					edificio.carga[4]++
					edificio.carga_total--
					edificio.proceso = -edificio_proceso[index] / 2
				}
				else if edificio.carga[0] > 1{
					edificio.carga[0] -= 2
					edificio.carga[2]++
					edificio.carga_total--
					edificio.proceso = -1
				}
				edificio.waiting = not mover(edificio.a, edificio.b)
				change_flujo(0, edificio)
			}
		}
	}
}