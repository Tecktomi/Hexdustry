function scr_horno_lava(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if flujo.liquido = idl_lava and (edificio.carga[idr_cobre] > 1 or edificio.carga[idr_hierro] > 1 or edificio.carga[idr_arena] > 1) and edificio.carga[idt_bronce] < 10 and edificio.carga[idr_acero] < 10 and edificio.carga[idr_silicio] < 10{
			//Encender
			if not edificio.start{
				change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.start = true
				encender_luz(, edificio)
			}
			edificio.proceso += flujo_power
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				if edificio.carga[idr_arena] > 1{
					edificio.carga[idr_arena] -= 2
					edificio.carga[idr_silicio]++
					edificio.carga_total--
					edificio.proceso -= edificio_proceso[index]
					if edificio.carga[idr_sal] > 0{
						edificio.carga[idr_sal] -= 0.1
						edificio.carga_total -= 0.1
						edificio.proceso += floor(edificio_proceso[index] / 4)
					}
				}
				else if edificio.carga[idr_hierro] > 1{
					edificio.carga[idr_hierro] -= 2
					edificio.carga[idr_acero]++
					edificio.carga_total--
					edificio.proceso -= 1.5 * edificio_proceso[index]
				}
				else if edificio.carga[idr_cobre] > 1{
					edificio.carga[idr_cobre] -= 2
					edificio.carga[idt_bronce]++
					edificio.carga_total--
					edificio.proceso -= edificio_proceso[index]
				}
				edificio.start = false
				edificio.waiting = not mover(edificio)
				change_flujo(0, edificio)
				encender_luz(false, edificio)
			}
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}