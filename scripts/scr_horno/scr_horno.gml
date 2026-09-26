function scr_horno(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var carga = edificio.carga
		if edificio.fuel > 0{
			edificio.fuel--
			sound_play_edificio(2, edificio.center_x, edificio.center_y)
		}
		if (carga[idr_cobre] > 1 or carga[idr_hierro] > 1 or carga[idr_arena] > 1) and
			(carga[idr_carbon] > 0 or carga[idr_compuesto_incendiario] > 0 or edificio.fuel > 0) and
			(carga[idr_bronce] < 10 and carga[idr_acero] < 10 and carga[idr_vidrio] < 10){
			if edificio.fuel = 0{
				if (carga[idr_carbon] > 0 or carga[idr_compuesto_incendiario] > 0){
					if carga[idr_compuesto_incendiario] > 0{
						edificio.fuel = recurso_combustion_time[idr_compuesto_incendiario]
						carga[idr_compuesto_incendiario]--
					}
					else if carga[idr_carbon] > 0{
						edificio.fuel = recurso_combustion_time[idr_carbon]
						carga[idr_carbon]--
					}
					edificio_encender(edificio,, false, false)
					edificio.carga_total--
					mover_in(edificio)
				}
				else
					edificio_encender(edificio, false, false, false)
			}
			edificio.proceso++
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
					edificio.proceso  -= 1.5 * edificio_proceso[index]
				}
				else if carga[idr_cobre] > 1{
					carga[idr_cobre] -= 2
					carga[idr_bronce]++
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