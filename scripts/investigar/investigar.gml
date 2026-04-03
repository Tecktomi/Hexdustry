function investigar(index, server = false, _cheat = control.cheat){
	with control{
		if not edificio_tecnologia_desbloqueable[index]
			exit
		if online and not server{
			server_investigar(index)
			if not servidor
				exit
		}
		if not _cheat
			for(var a = 0; a < array_length(edificio_tecnologia_precio[index]); a++){
				var temp_precio = edificio_tecnologia_precio[index, a]
				nucleo.carga[temp_precio.id] -= temp_precio.num
			}
		edificio_tecnologia_desbloqueable[index] = false
		edificio_tecnologia[index] = true
		tecnologias_estudiadas++
		//Tecnologías que desbloquea
		for(var a = 0; a < array_length(edificio_tecnologia_next[index]); a++){
			var b = edificio_tecnologia_next[index, a]
			if not edificio_tecnologia[b]{
				var flag = true
				for(var c = 0; c < array_length(edificio_tecnologia_prev[b]); c++){
					var d = edificio_tecnologia_prev[b, c]
					if not edificio_tecnologia[d]{
						flag = false
						break
					}
				}
				if flag
					edificio_tecnologia_desbloqueable[b] = true
			}
		}
	}
}