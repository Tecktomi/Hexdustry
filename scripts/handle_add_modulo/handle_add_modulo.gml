function handle_add_modulo(buffer){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var a = real(buffer_read(buffer, buffer_u16))
		var b = real(buffer_read(buffer, buffer_u16))
		var _cheat = bool(buffer_read(buffer, buffer_bool))
		if servidor{
			if edificio_bool[# a, b]{
				add_modulo(edificio_id[# a, b],, _cheat)
				server_add_modulo(a, b, _cheat)
			}
		}
		else{
			var cambio = {
				step : _timer,
				tipo : 4,
				data : {
					a : a,
					b : b,
					cheat : _cheat
				}
			}
			array_push(cambios, cambio)
		}
	}
}