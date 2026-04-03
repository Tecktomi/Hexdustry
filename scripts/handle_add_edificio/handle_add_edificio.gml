function handle_add_edificio(buffer){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var index = real(buffer_read(buffer, buffer_u8))
		var dir = real(buffer_read(buffer, buffer_u8))
		var a = real(buffer_read(buffer, buffer_u16))
		var b = real(buffer_read(buffer, buffer_u16))
		var enemigo = bool(buffer_read(buffer, buffer_bool))
		var _cheat = bool(buffer_read(buffer, buffer_bool))
		if server{
			construir(index, dir, a, b, enemigo, true, _cheat)
			server_add_edificio(index, dir, a, b, enemigo, _cheat)
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
					enemigo : enemigo,
					cheat : _cheat
				}
			}
			array_push(cambios, cambio)
		}
	}
}