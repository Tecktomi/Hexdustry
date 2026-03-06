function save_game_buffer(buffer){
	with control{
		buffer_write(buffer, buffer_s8, mapa)
		if mapa = -1{
			buffer_write(buffer, buffer_u32, seed)
			buffer_write(buffer, buffer_u8, biome_seed)
		}
		buffer_write(buffer, buffer_u32, timer)
		buffer_write(buffer, buffer_u32, oleadas_timer)
		//Filtrar Edificios
		var len = array_length(edificios_totales), b = 0
		for(var a = 0; a < len; a++){
			var edificio = edificios_totales[a]
			if not edificio.vivo or edificio.vida <= 0
				delete_edificio(edificio)
			else
				b++
		}
		buffer_write(buffer, buffer_u16, real(b))
		//Guardar Edificios
		for(var a = 0; a < b; a++){
			var edificio = edificios_totales[a]
			buffer_write(buffer, buffer_u8, real(edificio.index))
			buffer_write(buffer, buffer_u8, real(edificio.dir))
			buffer_write(buffer, buffer_u16, real(edificio.a))
			buffer_write(buffer, buffer_u16, real(edificio.b))
			buffer_write(buffer, buffer_bool, real(edificio.enemigo))
		}
		//Estado edificios
		for(var a = 0; a < len; a++)
			save_edificio(buffer, edificios_totales[a])
		//Historial de cambios
		len = array_length(historial)
		buffer_write(buffer, buffer_u16, len)
		for(var a = 0; a < len; a++){
			var log = historial[a], tipo = log.tipo
			buffer_write(buffer, buffer_u8, tipo)
			if tipo = 0{ //Set edificio
				buffer_write(buffer, buffer_u16, real(log.a))
				buffer_write(buffer, buffer_u16, real(log.b))
				buffer_write(buffer, buffer_bool, bool(log.mode))
				buffer_write(buffer, buffer_u8, real(log.select))
			}
		}
		//Redes
		len = array_length(redes)
		buffer_write(buffer, buffer_u16, len)
		for(var a = 0; a < len; a++){
			var red = redes[a]
			buffer_write(buffer, buffer_u16, real(red.edificios[0].punteros[12]))
			buffer_write(buffer, buffer_f32, real(red.bateria))
		}
		//Flujos
		len = array_length(flujos)
		buffer_write(buffer, buffer_u16, len)
		for(var a = 0; a < len; a++){
			var flujo = flujos[a]
			buffer_write(buffer, buffer_u16, real(flujo.edificios[0].punteros[12]))
			buffer_write(buffer, buffer_f32, real(flujo.almacen))
			buffer_write(buffer, buffer_u8, real(flujo.liquido))
		}
		//Filtrar drones
		len = array_length(drones)
		b = 0
		for(var a = 0; a < len; a++){
			var dron = drones[a]
			if dron.vida <= 0
				delete_dron(dron)
			else
				b++
		}
		len = b
		buffer_write(buffer, buffer_u16, real(len))
		//Guardar drones
		for(var a = 0; a < len; a++){
			var dron = drones[a]
			buffer_write(buffer, buffer_u16, real(dron.a))
			buffer_write(buffer, buffer_u16, real(dron.b))
			buffer_write(buffer, buffer_u8, real(dron.index))
			buffer_write(buffer, buffer_bool, bool(dron.enemigo))
		}
		//Estado drones
		for(var a = 0; a < len; a++){
			var dron = drones[a]
			var mask = 0, c = 0
			mask += (dron.vida_max != dron_vida_max[dron.index]) << c++
			mask += (dron.vida != dron.vida_max) << c++
			mask += (dron.target != null_edificio) << c++
			mask += (dron.temp_target != null_edificio) << c++
			mask += (dron.target_dron != null_dron) << c++
			for(var i = 0; i < rss_max; i++)
				mask += (dron.carga != 0) << c++
			mask += (dron.modo != 0) << c++
			mask += (dron.dir != 0) << c++
			mask += (dron.dir_move != 0) << c++
			mask += (dron.step != 0) << c++
			for(var i = 0; i < array_length(efectos); i++)
				mask += (dron.efecto[i] != 0) << c++
			mask += (dron.move_xmove != 0) << c++
			mask += (dron.move_ymove != 0) << c++
			mask += (dron.move_dis != 0) << c++
			mask += (dron.move_x != 0) << c++
			mask += (dron.move_y != 0) << c++
			mask += (dron.oleada != 0) << c++
			buffer_write(buffer, buffer_u64, real(mask))
			c = 0
			buffer_write(buffer, buffer_f16, real(dron.x))
			buffer_write(buffer, buffer_f16, real(dron.y))
			if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(dron.vida_max))
			if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(dron.vida))
			if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(dron.target.punteros[12]))
			if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(dron.temp_target.punteros[12]))
			if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(dron.target_dron.punteros[2]))
			for(var i = 0; i < rss_max; i++)
				if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(dron.carga[i]))
			if mask & (1 << c++) buffer_write(buffer, buffer_u8, real(dron.modo))
			if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(dron.dir))
			if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(dron.dir_move))
			if mask & (1 << c++) buffer_write(buffer, buffer_s16, real(dron.step))
			for(var i = 0; i < efectos_max; i++)
				if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(dron.efecto[i]))
			if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(dron.move_xmove))
			if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(dron.move_ymove))
			if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(dron.move_dis))
			if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(dron.move_x))
			if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(dron.move_y))
			if mask & (1 << c++) buffer_write(buffer, buffer_u8, real(dron.oleada))
		}
	}
}