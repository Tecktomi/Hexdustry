function add_modulo(edificio = control.null_edificio, _server = false, _cheat = control.cheat){
	with control{
		var a, b, _jugador = edificio.jugador
		if edificio.modulo
			exit
		b = edificio_modulo_tier[edificio.index]
		if b = -1
			exit
		if online and not _server{
			server_add_modulo(edificio.a, edificio.b)
			if not servidor
				exit
		}
		if not _cheat and not build_enemigo
			for(a = array_length(modulo_precio_id[b]) - 1; a >= 0; a--)
				jugador_recursos[_jugador, modulo_precio_id[b, a]] -= modulo_precio_num[b, a]
		edificio.modulo = true
	}
}