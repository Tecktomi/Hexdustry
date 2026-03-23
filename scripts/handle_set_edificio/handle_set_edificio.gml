function handle_set_edificio(buffer){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var mode = bool(buffer_read(buffer, buffer_bool))
		var select = real(buffer_read(buffer, buffer_s8))
		var a = real(buffer_read(buffer, buffer_u16))
		var b = real(buffer_read(buffer, buffer_u16))
		if server{
			set_edificio(mode, select, edificio_id[# a, b], false)
			server_set_edificio(mode, select, edificio_id[# a, b])
		}
		else{
			var cambio = {
				step : _timer,
				tipo : 2,
				data : {
					mode : mode,
					select : select,
					a : a,
					b : b
				}
			}
			array_push(cambios, cambio)
		}
	}
}