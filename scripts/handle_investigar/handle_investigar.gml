function handle_investigar(buffer){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var index = real(buffer_read(buffer, buffer_u8))
		var _cheat = bool(buffer_read(buffer, buffer_bool))
		var _jugador = real(buffer_read(buffer, buffer_u8))
		if servidor{
			investigar(index,, _cheat, _jugador)
			server_investigar(index, _cheat, _jugador)
		}
		else{
			var cambio = {
				step : _timer,
				tipo : 5,
				data : {
					index : index,
					cheat : _cheat,
					jugador : _jugador
				}
			}
			array_push(cambios, cambio)
		}
	}
}