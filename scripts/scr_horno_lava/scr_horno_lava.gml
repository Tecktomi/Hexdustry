function scr_horno_lava(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		var carga = edificio.carga
		if flujo.liquido = idl_lava and (carga[idr_cobre] > 1 or carga[idr_hierro] > 1 or carga[idr_arena] > 1) and carga[idr_bronce] < 10 and carga[idr_acero] < 10 and carga[idr_vidrio] < 10{
			//Encender
			if not edificio.start{
				edificio_encender(edificio,, false)
				edificio.start = true
			}
			edificio.proceso += flujo_power
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				if carga[idr_arena] > 1{
					carga[idr_arena] -= 2
					carga[idr_vidrio]++
					edificio.carga_total--
					edificio.proceso -= edificio_proceso[index]
					if carga[idr_sal] > 0{
						carga[idr_sal] -= 0.1
						edificio.carga_total -= 0.1
						edificio.proceso += floor(edificio_proceso[index] / 4)
					}
				}
				else if carga[idr_hierro] > 1{
					carga[idr_hierro] -= 2
					carga[idr_acero]++
					edificio.carga_total--
					edificio.proceso -= 1.5 * edificio_proceso[index]
				}
				else if carga[idr_cobre] > 1{
					carga[idr_cobre] -= 2
					carga[idr_bronce]++
					edificio.carga_total--
					edificio.proceso -= edificio_proceso[index]
				}
				edificio.start = false
				edificio.waiting = not mover(edificio)
				edificio_encender(edificio, false, false)
			}
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}