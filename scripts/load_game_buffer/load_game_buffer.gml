function load_game_buffer(buffer){
	with control{
		mapa = buffer_read(buffer, buffer_s8)
		if mapa = -1{
			seed = buffer_read(buffer, buffer_u32)
			biome_seed = buffer_read(buffer, buffer_u8)
			generar_bioma(biome_seed)
		}
		else
			var file = cargar_escenario($"{default_maps[mapa]}.txt", false)
		game_start()
		timer = buffer_read(buffer, buffer_u32)
		oleadas_timer = buffer_read(buffer, buffer_u32)
		var len = buffer_read(buffer, buffer_u16)
		repeat(len){
			var tipo = buffer_read(buffer, buffer_u8)
			if tipo = 0{ //Construir edificio
				var index = real(buffer_read(buffer, buffer_u8))
				var dir = real(buffer_read(buffer, buffer_u8))
				var a = real(buffer_read(buffer, buffer_u16))
				var b = real(buffer_read(buffer, buffer_u16))
				var enemigo = bool(buffer_read(buffer, buffer_bool))
				construir(index, dir, a, b, enemigo, true)
			}
			else if tipo = 1{ //Set edificio
				var a = real(buffer_read(buffer, buffer_u16))
				var b = real(buffer_read(buffer, buffer_u16))
				var mode = bool(buffer_read(buffer, buffer_bool))
				var select = real(buffer_read(buffer, buffer_u8))
				if edificio_bool[# a, b]
					set_edificio(mode, select, edificio_id[# a, b])
			}
		}
		//Carar el estado de los edifiicos
		len = array_length(edificios)
		for(var a = 0; a < len; a++)
			load_edificio(buffer, edificios[a])
		//Redes
		len = real(buffer_read(buffer, buffer_u16))
		for(var a = 0; a < len; a++){
			var b = real(buffer_read(buffer, buffer_u16)), c = real(buffer_read(buffer, buffer_f32))
			if b < 65535
				edificios[b].red.bateria = c
		}
		//Flujos
		len = real(buffer_read(buffer, buffer_u16))
		for(var a = 0; a < len; a++){
			var b = real(buffer_read(buffer, buffer_u16)), c = real(buffer_read(buffer, buffer_f32)), d = real(buffer_read(buffer, buffer_u8))
			if b < 65535{
				var flujo = edificios[b].flujo
				flujo.capacidad = c
				flujo.liquido = (d = 255) ? -1 : d
			}
		}
	}
}