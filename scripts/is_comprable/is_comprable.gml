function is_comprable(precio_id, precio_num){
	with control{
		if cheat
			return true
		var len = array_length(precio_id)
		for(var a = 0; a < len; a++)
			if jugador_recursos[0, precio_id[a]] < precio_num[a]
				return false
		return true
	}
}