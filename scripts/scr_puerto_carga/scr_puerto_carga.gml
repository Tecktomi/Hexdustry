function scr_puerto_carga(edificio = control.null_edificio){
	with control{
		if edificio.link != null_edificio and edificio.emisor
			edificio.waiting = mover(edificio.a, edificio.b)
	}
}