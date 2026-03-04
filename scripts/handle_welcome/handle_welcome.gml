function handle_welcome(buffer){
	with control{
		online = true
		seed = buffer_read(buffer, buffer_u32)
		biome_seed = buffer_read(buffer, buffer_u8)
		var temp_timer = buffer_read(buffer, buffer_u32)
		var temp_timer_oleadas = buffer_read(buffer, buffer_u32)
		generar_bioma(biome_seed)
		game_start()
		timer = temp_timer
		oleadas_timer = temp_timer_oleadas
		var len = buffer_read(buffer, buffer_u16)
		repeat(len){
			var tipo = buffer_read(buffer, buffer_u8)
			if tipo = 0{
				var index = real(buffer_read(buffer, buffer_u8))
				var dir = real(buffer_read(buffer, buffer_u8))
				var a = real(buffer_read(buffer, buffer_u16))
				var b = real(buffer_read(buffer, buffer_u16))
				var enemigo = bool(buffer_read(buffer, buffer_bool))
				construir(index, dir, a, b, enemigo, true)
			}
			else if tipo = 1{
				var a = real(buffer_read(buffer, buffer_u16))
				var b = real(buffer_read(buffer, buffer_u16))
				var destruccion = bool(buffer_read(buffer, buffer_bool))
				if edificio_bool[# a, b]
					delete_edificio(edificio_id[# a, b], destruccion, true)
			}
		}
	}
}