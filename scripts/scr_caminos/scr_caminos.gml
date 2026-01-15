function scr_caminos(edificio = control.null_edificio){
	if edificio.carga_total > 0 and not edificio.waiting and ++edificio.proceso >= control.edificio_proceso[edificio.index]{
		edificio.proceso = 0
		edificio.waiting = not mover(edificio)
	}
}