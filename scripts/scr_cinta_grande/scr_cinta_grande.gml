function scr_cinta_grande(edificio = control.null_edificio){
	with control{
		if edificio.select >= 0{
			var index = edificio.index
			if edificio.proceso++ >= edificio_proceso[index]{
				edificio.proceso -= edificio_proceso[index]
				edificio.waiting = not mover_carga(edificio)
				if not edificio.waiting
					edificio.select = -1
			}
		}
	}
}