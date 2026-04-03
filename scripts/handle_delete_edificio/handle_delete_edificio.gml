function handle_delete_edificio(buffer){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var a = real(buffer_read(buffer, buffer_u16))
		var b = real(buffer_read(buffer, buffer_u16))
		var _cheat = bool(buffer_read(buffer, buffer_bool))
		if server{
			if edificio_bool[# a, b]{
				delete_edificio(edificio_id[# a, b], false, true, _cheat)
				server_delete_edificio(a, b, _cheat)
			}
		}
		else{
			var cambio = {
				step : _timer,
				tipo : 1,
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