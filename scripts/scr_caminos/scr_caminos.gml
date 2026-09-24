function scr_caminos(edificio = control.null_edificio){
	with control{
		if edificio.carga_total > 0 and not edificio.waiting and ++edificio.proceso >= edificio_proceso[edificio.index]{
			edificio.proceso = 0
			if tag_edificio_cinta[edificio.index]
				edificio.waiting = not mover_light(edificio)
			else
				edificio.waiting = not mover(edificio)
		}
	}
}