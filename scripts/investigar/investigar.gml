function investigar(index, _server = false, _cheat = control.cheat, _jugador = jugador){
	with control{
		var a, _next, flag, c, d, _mio = (jugador = _jugador)
		if not edificio_tecnologia_desbloqueable[_jugador, index]
			exit
		if online and not _server{
			server_investigar(index, _cheat, _jugador)
			if not servidor
				exit
		}
		if not _cheat and (_mio or (online and servidor))
			for(a = 0; a < array_length(tecnologia_precio_id[index]); a++)
				jugador_recursos[_jugador, tecnologia_precio_id[index, a]] -= tecnologia_precio_num[index, a]
		array_set(edificio_tecnologia_desbloqueable[_jugador], index, false)
		array_set(edificio_tecnologia[_jugador], index, true)
		tecnologias_estudiadas++
		//Tecnologías que desbloquea
		for(a = 0; a < array_length(tecnologia_next[index]); a++){
			_next = tecnologia_next[index, a]
			if not edificio_tecnologia[_jugador, _next]{
				flag = true
				for(c = 0; c < array_length(tecnologia_prev[_next]); c++){
					d = tecnologia_prev[_next, c]
					if not edificio_tecnologia[_jugador, d]{
						flag = false
						break
					}
				}
				if flag
					array_set(edificio_tecnologia_desbloqueable[_jugador], _next,  true)
			}
		}
	}
}