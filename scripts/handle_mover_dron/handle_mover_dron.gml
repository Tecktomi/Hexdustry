function handle_mover_dron(buffer){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var _x = real(buffer_read(buffer, buffer_f32))
		var _y = real(buffer_read(buffer, buffer_f32))
		var index = real(buffer_read(buffer, buffer_u16))
		if server{
			mover_dron(drones[index], _x, _y, false)
			server_mover_dron(_x, _y, drones[index])
		}
		else{
			var cambio = {
				step : _timer,
				tipo : 3,
				data : {
					x : _x,
					y : _y,
					index : index
				}
			}
			array_push(cambios, cambio)
		}
	}
}