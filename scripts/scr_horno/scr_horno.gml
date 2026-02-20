function scr_horno(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio.fuel > 0{
			edificio.fuel--
			sound_play_edificio(2, edificio.center_x, edificio.center_y)
		}
		if (edificio.carga[idr_cobre] > 1 or edificio.carga[idr_hierro] > 1 or edificio.carga[idr_arena] > 1) and
			(edificio.carga[idr_carbon] > 0 or edificio.carga[idr_compuesto_incendiario] > 0 or edificio.fuel > 0) and
			(edificio.carga[idr_bronce] < 10 and edificio.carga[idr_acero] < 10 and edificio.carga[idr_silicio] < 10){
			if edificio.fuel = 0
				if (edificio.carga[idr_carbon] > 0 or edificio.carga[idr_compuesto_incendiario] > 0){
					if edificio.carga[idr_compuesto_incendiario] > 0{
						edificio.fuel = recurso_combustion_time[idr_compuesto_incendiario]
						edificio.carga[idr_compuesto_incendiario]--
					}
					else if edificio.carga[idr_carbon] > 0{
						edificio.fuel = recurso_combustion_time[idr_carbon]
						edificio.carga[idr_carbon]--
					}
					encender_luz(, edificio)
					edificio.carga_total--
					mover_in(edificio)
				}
				else
					encender_luz(false, edificio)
			edificio.proceso++
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
					edificio.proceso  -= 1.5 * edificio_proceso[index]
				}
				else if edificio.carga[idr_cobre] > 1{
					edificio.carga[idr_cobre] -= 2
					edificio.carga[idr_bronce]++
					edificio.carga_total--
					edificio.proceso -= edificio_proceso[index]
				}
				edificio.waiting = not mover(edificio)
			}
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}