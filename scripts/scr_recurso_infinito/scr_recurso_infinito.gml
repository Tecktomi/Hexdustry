function scr_recurso_infinito(edificio = control.null_edificio){
	with control{
		if edificio.select != -1{
			edificio.carga[edificio.select] = 1
			edificio.waiting = not mover(edificio.a, edificio.b)
		}
	}
}