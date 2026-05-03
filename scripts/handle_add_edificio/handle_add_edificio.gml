function handle_add_edificio(buffer){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var index = real(buffer_read(buffer, buffer_u8))
		var dir = real(buffer_read(buffer, buffer_u8))
		var a = real(buffer_read(buffer, buffer_u16))
		var b = real(buffer_read(buffer, buffer_u16))
		var _cheat = bool(buffer_read(buffer, buffer_bool))
		var _jugador = real(buffer_read(buffer, buffer_u8))
		if server{
			construir(index, dir, a, b,, true, _cheat, _jugador)
			server_add_edificio(index, dir, a, b, _cheat, _jugador)
		}
		else{
			var cambio = {
				step : _timer,
				tipo : 0,
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