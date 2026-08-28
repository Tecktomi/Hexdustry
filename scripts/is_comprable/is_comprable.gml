function is_comprable(precio_id, precio_num, _jugador = jugador){
	with control{
		if cheat
			return true
		var len = array_length(precio_id), a
		for(a = 0; a < len; a++)
			if jugador_recursos[_jugador, precio_id[a]] < precio_num[a]
				return false
		return true
	}
}