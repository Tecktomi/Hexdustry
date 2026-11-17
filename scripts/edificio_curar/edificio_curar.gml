function edificio_curar(edificio = control.null_edificio, vida){
	with control{
		if edificio.jugador = jugador
			dmg_curado += min(vida, edificio_vida[edificio.index] - edificio.vida)
		edificio.vida += vida
		if edificio.vida >= edificio_vida[edificio.index]{
			edificio.vida = edificio_vida[edificio.index]
			var b, temp_edificio
			for(b = array_length(edificio.reparadores_cercanos) - 1; b >= 0; b--){
				temp_edificio = edificio.reparadores_cercanos[b]
				var _i = array_get_index(temp_edificio.edificios_cercanos_heridos, edificio)
				if _i >= 0
					array_delete(temp_edificio.edificios_cercanos_heridos, _i, 1)
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