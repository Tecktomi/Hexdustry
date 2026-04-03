function add_modulo(edificio = control.null_edificio, server = false, _cheat = control.cheat){
	with control{
		if edificio.modulo
			exit
		var b = edificio_modulo_tier[edificio.index]
		if b = -1
			exit
		if online and not server{
			server_add_modulo(edificio.a, edificio.b)
			if not servidor
				exit
		}
		if not _cheat and not build_enemigo
			for(var a = array_length(modulo_precio_id[b]) - 1; a >= 0; a--)
				nucleo.carga[modulo_precio_id[b, a]] -= modulo_precio_num[b, a]
		edificio.modulo = true
	}
}