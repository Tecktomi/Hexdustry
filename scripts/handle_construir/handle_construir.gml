function handle_construir(buffer){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var index = real(buffer_read(buffer, buffer_u8))
		if index = id_tunel or index = id_tunel_salida{
			build_able = bool(buffer_read(buffer, buffer_bool))
			var a = real(buffer_read(buffer, buffer_u16))
			var b = real(buffer_read(buffer, buffer_u16))
			if edificio_bool[# a, b]
				build_target = edificio_id[# a, b]
		}
		else if in(index, id_fabrica_de_drones, id_cinta_grande, id_fabrica_de_drones_grande){
			build_agua = bool(buffer_read(buffer, buffer_bool))
			build_agua_x = real(buffer_read(buffer,buffer_u16))
			build_agua_y = real(buffer_read(buffer,buffer_u16))
		}
		var dir = real(buffer_read(buffer, buffer_u8))
		var a = real(buffer_read(buffer, buffer_u16))
		var b = real(buffer_read(buffer, buffer_u16))
		var _cheat = bool(buffer_read(buffer, buffer_bool))
		var _jugador = real(buffer_read(buffer, buffer_u8))
		if index = id_tuberia{
			liquido_choose_array = array_create(2, real(buffer_read(buffer, buffer_u8)))
			liquido_choose = 0
		}
		if servidor{
			if construir(index, dir, a, b,, _cheat, _jugador) != null_edificio
				server_construir(index, dir, a, b, _cheat, _jugador)
		}
		else{
			var cambio = {
				step : _timer,
				tipo : cambio_construir,
				data : {
					index : index,
					dir : dir,
					a : a,
					b : b,
					cheat : _cheat,
					jugador : _jugador
				}
			}
			array_push(cambios, cambio)
		}
	}
}