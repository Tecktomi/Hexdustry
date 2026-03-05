function save_game_buffer(buffer){
	with control{
		buffer_write(buffer, buffer_s8, mapa)
		if mapa = -1{
			buffer_write(buffer, buffer_u32, seed)
			buffer_write(buffer, buffer_u8, biome_seed)
		}
		buffer_write(buffer, buffer_u32, timer)
		buffer_write(buffer, buffer_u32, oleadas_timer)
		//Historial de cambios
		var len = array_length(historial)
		buffer_write(buffer, buffer_u16, len)
		for(var a = 0; a < len; a++){
			var log = historial[a], tipo = log.tipo
			buffer_write(buffer, buffer_u8, tipo)
			if tipo = 0{ //Construir
				buffer_write(buffer, buffer_u8, real(log.index))
				buffer_write(buffer, buffer_u8, real(log.dir))
				buffer_write(buffer, buffer_u16, real(log.a))
				buffer_write(buffer, buffer_u16, real(log.b))
				buffer_write(buffer, buffer_bool, bool(log.enemigo))
			}
			else if tipo = 1{ //Set edificio
				buffer_write(buffer, buffer_u16, real(log.a))
				buffer_write(buffer, buffer_u16, real(log.b))
				buffer_write(buffer, buffer_bool, bool(log.mode))
				buffer_write(buffer, buffer_u8, real(log.select))
			}
		}
		//Estado de los edificios
		len = array_length(edificios)
		for(var a = 0; a < len; a++){
			var edificio = edificios[a]
			if edificio.vivo
				save_edificio(buffer, edificio)
			else
				delete_edificio(edificio)
		}
		//Redes
		len = array_length(redes)
		buffer_write(buffer, buffer_u16, len)
		for(var a = 0; a < len; a++){
			var red = redes[a]
			buffer_write(buffer, buffer_u16, real(red.edificios[0].punteros[0]))
			buffer_write(buffer, buffer_f32, real(red.bateria))
		}
		//Flujos
		len = array_length(flujos)
		buffer_write(buffer, buffer_u16, len)
		for(var a = 0; a < len; a++){
			var flujo = flujos[a]
			buffer_write(buffer, buffer_u16, real(flujo.edificios[0].punteros[0]))
			buffer_write(buffer, buffer_f32, real(flujo.almacen))
			buffer_write(buffer, buffer_u8, real(flujo.liquido))
		}
	}
}