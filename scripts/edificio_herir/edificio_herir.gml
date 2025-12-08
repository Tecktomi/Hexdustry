function edificio_herir(edificio = control.null_edificio, dmg){
	if edificio.vida = edificio_vida[edificio.index]
		for(var a = array_length(edificio.reparadores_cercanos) - 1; a >= 0; a--){
			var temp_edificio = edificio.reparadores_cercanos[a]
			array_push(temp_edificio.edificios_cercanos_heridos, edificio)
		}
	edificio.vida -= dmg
	if edificio.vida <= 0{
		delete_edificio(edificio.a, edificio.b, true)
		return true
	}
	return false
}