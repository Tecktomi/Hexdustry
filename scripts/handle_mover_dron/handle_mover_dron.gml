function handle_mover_dron(buffer){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var _x = real(buffer_read(buffer, buffer_f32))
		var _y = real(buffer_read(buffer, buffer_f32))
		var index = 0
		if online and servidor{
			index = real(buffer_read(buffer, buffer_u32))
			var flag = false
			for(var a = array_length(drones) - 1; a >= 0; a--)
				if drones[a].dron_counter = index{
					index = drones[a].punteros[ptrd_total]
					flag = true
					break
				}
			if not flag
				return false
		}
		else
			index = real(buffer_read(buffer, buffer_u16))
		if servidor{
			mover_dron(drones[index], _x, _y)
			server_mover_dron(_x, _y, drones[index])
		}
		else{
			var cambio = {
				step : _timer,
				tipo : cambio_mover_dron,
				data : {
					x : _x,
					y : _y,
					index : index
				}
			}
			array_push(cambios, cambio)
		}
		return true
	}
}