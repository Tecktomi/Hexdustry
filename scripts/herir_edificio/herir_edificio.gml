function herir_edificio(dmg, edificio = control.null_edificio){
	if edificio.vida = edificio_vida[edificio.index]
		for(var a = array_length(edificio.reparadores_cercanos) - 1; a >= 0; a--){
			var temp_edificio = edificio.reparadores_cercanos[a]
			array_push(temp_edificio.edificios_cercanos_heridos, edificio)
		}
	if edificio.enemigo
		dmg_causado += min(edificio.vida, dmg)
	else
		dmg_recibido += min(edificio.vida, dmg)
	edificio.vida -= dmg
	if edificio.vida <= 0{
		delete_edificio(edificio, true)
		return true
	}
	return false
}