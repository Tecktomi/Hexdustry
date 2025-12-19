function scr_planta_de_reciclaje(edificio = control.null_edificio){
	if edificio.carga_total > 0
		edificio.waiting = not mover(edificio.a, edificio.b)
}