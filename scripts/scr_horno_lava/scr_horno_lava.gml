function scr_horno_lava(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_flujo[index]
			var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if flujo.liquido = 3 and (edificio.carga[id_cobre] > 1 or edificio.carga[id_hierro] > 1 or edificio.carga[id_arena] > 1) and edificio.carga[id_bronce] < 10 and edificio.carga[id_acero] < 10 and edificio.carga[id_silicio] < 10{
			//Encender
			if not edificio.start{
				change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.start = true
				encender_luz(1, edificio)
			}
			edificio.proceso += flujo_power
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				if edificio.carga[id_arena] > 1{
					edificio.carga[id_arena] -= 2
					edificio.carga[id_silicio]++
					edificio.carga_total--
					edificio.proceso -= edificio_proceso[index]
					if edificio.carga[id_sal] > 0{
						edificio.carga[id_sal] -= 0.1
						edificio.carga_total -= 0.1
						edificio.proceso += floor(edificio_proceso[index] / 4)
					}
				}
				else if edificio.carga[id_hierro] > 1{
					edificio.carga[id_hierro] -= 2
					edificio.carga[id_acero]++
					edificio.carga_total--
					edificio.proceso -= 1.5 * edificio_proceso[index]
				}
				else if edificio.carga[id_cobre] > 1{
					edificio.carga[id_cobre] -= 2
					edificio.carga[id_bronce]++
					edificio.carga_total--
					edificio.proceso -= edificio_proceso[index]
				}
				edificio.start = false
				edificio.waiting = not mover(edificio.a, edificio.b)
				change_flujo(0, edificio)
				encender_luz(-1, edificio)
			}
		}
	}
}