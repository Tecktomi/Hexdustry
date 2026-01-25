function edificio_curar(edificio = control.null_edificio, vida){
	with control{
		if not edificio.enemigo
			dmg_curado += min(vida, edificio_vida[edificio.index] - edificio.vida)
		edificio.vida += vida
		if edificio.vida >= edificio_vida[edificio.index]{
			edificio.vida = edificio_vida[edificio.index]
			for(var b = array_length(edificio.reparadores_cercanos) - 1; b >= 0; b--){
				var temp_edificio = edificio.reparadores_cercanos[b]
				array_remove(temp_edificio.edificios_cercanos_heridos, edificio)
				if temp_edificio.link = edificio{
					temp_edificio.link = null_edificio
					change_energia(0, temp_edificio)
				}
			}
			return true
		}
		return false
	}
}