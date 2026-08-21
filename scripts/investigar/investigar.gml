function investigar(index, _server = false, _cheat = control.cheat){
	with control{
		var a, _next, flag, c, d
		if not edificio_tecnologia_desbloqueable[index]
			exit
		if online and not _server{
			server_investigar(index)
			if not servidor
				exit
		}
		if not _cheat
			for(a = 0; a < array_length(tecnologia_precio_id[index]); a++)
				jugador_recursos[0, tecnologia_precio_id[index, a]] -= tecnologia_precio_num[index, a]
		edificio_tecnologia_desbloqueable[index] = false
		edificio_tecnologia[index] = true
		tecnologias_estudiadas++
		//Tecnologías que desbloquea
		for(a = 0; a < array_length(tecnologia_next[index]); a++){
			_next = tecnologia_next[index, a]
			if not edificio_tecnologia[_next]{
				flag = true
				for(c = 0; c < array_length(tecnologia_prev[_next]); c++){
					d = tecnologia_prev[_next, c]
					if not edificio_tecnologia[d]{
						flag = false
						break
					}
				}
				if flag
					edificio_tecnologia_desbloqueable[_next] = true
			}
		}
	}
}