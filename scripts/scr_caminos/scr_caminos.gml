function scr_caminos(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio.carga_total > 0 and not edificio.waiting and ++edificio.proceso >= edificio_proceso[index]{
			edificio.proceso = 0
			edificio.waiting = not mover(edificio.a, edificio.b)
		}
	}
}