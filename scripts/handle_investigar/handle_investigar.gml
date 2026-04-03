function handle_investigar(buffer){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var index = real(buffer_read(buffer, buffer_u8))
		var _cheat = bool(buffer_read(buffer, buffer_bool))
		if servidor{
			investigar(index,, _cheat)
			server_investigar(index, _cheat)
		}
		else{
			var cambio = {
				step : _timer,
				tipo : 5,
				data : {
					index : index,
					cheat : _cheat
				}
			}
			array_push(cambios, cambio)
		}
	}
}