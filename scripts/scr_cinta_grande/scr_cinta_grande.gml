function scr_cinta_grande(edificio = control.null_edificio){
	with control{
		if edificio.select >= 0 and not edificio.waiting_dron{
			var index = edificio.index
			if edificio.proceso++ >= edificio_proceso[index]{
				edificio.proceso -= edificio_proceso[index]
				if mover_carga(edificio)
					edificio.select = -1
			}
		}
	}
}