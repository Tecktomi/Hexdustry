function handle_construir(buffer){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var index = real(buffer_read(buffer, buffer_u8))
		var data = {}
		if in(index, id_tunel, id_tunel_salida){
			data.able = bool(buffer_read(buffer, buffer_bool))
			data.tunel_a = real(buffer_read(buffer, buffer_u16))
			data.tunel_b = real(buffer_read(buffer, buffer_u16))
		}
		else if in(index, id_fabrica_de_drones, id_cinta_grande, id_fabrica_de_drones_grande){
			data.agua = bool(buffer_read(buffer, buffer_bool))
			data.agua_x = real(buffer_read(buffer,buffer_u16))
			data.agua_y = real(buffer_read(buffer,buffer_u16))
		}
		if tag_edificio_tuberia[index]
			data.liquido = real(buffer_read(buffer, buffer_u8))
		var dir = real(buffer_read(buffer, buffer_u8))
		var a = real(buffer_read(buffer, buffer_u16))
		var b = real(buffer_read(buffer, buffer_u16))
		var _cheat = bool(buffer_read(buffer, buffer_bool))
		var _jugador = real(buffer_read(buffer, buffer_u8))
		if servidor{
			if in(index, id_tunel, id_tunel_salida){
				build_able = data.able
				if edificio_bool[# data.tunel_a, data.tunel_b]
					build_target = edificio_id[# data.tunel_a, data.tunel_b]
			}
			else if in(index, id_fabrica_de_drones, id_cinta_grande, id_fabrica_de_drones_grande){
				build_agua = bool(data.agua)
				build_agua_x = real(data.agua_x)
				build_agua_y = real(data.agua_y)
			}
			else if tag_edificio_tuberia[index]{
				liquido_choose_array = array_create(2, real(liquido))
				liquido_choose = 0
			}
			if construir(index, dir, a, b,, _cheat, _jugador) != null_edificio
				server_construir(index, dir, a, b, _cheat, _jugador)
		}
		else{
			data.index = index
			data.dir = dir
			data.a = a
			data.b = b
			data.cheat = _cheat
			data.jugador = _jugador
			var cambio = {
				step : _timer,
				tipo : cambio_construir,
				data : data
			}
			array_push(cambios, cambio)
		}
	}
}