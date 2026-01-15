function scr_puerto_carga(edificio = control.null_edificio){
	with control{
		if edificio.link != null_edificio and edificio.emisor and not edificio.waiting
			edificio.waiting = mover(edificio)
	}
}