function is_comprable(precio_id, precio_num){
	with control{
		if cheat
			return true
		var len = array_length(precio_id)
		for(var a = 0; a < len; a++)
			if nucleo.carga[precio_id[a]] < precio_num[a]
				return false
		return true
	}
}