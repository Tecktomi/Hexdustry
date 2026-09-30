function grabacion_read(){
	with control{
		grabacion_size = buffer_get_size(buffer_grabacion)
		buffer_seek(buffer_grabacion, buffer_seek_start, 0)
		if buffer_read(buffer_grabacion, buffer_u32) != GRABACION_VERSION{
			show_message(L.archivo_obsoleto)
			exit
		}
		REPRODUCIENDO = true
		GRABANDO = false
		servidor = false
		online = false
		sim_seed[0] = buffer_read(buffer_grabacion, buffer_u32)
		mapa = buffer_read(buffer_grabacion, buffer_s8)
		if mapa < 0{
			seed = buffer_read(buffer_grabacion, buffer_u32)
			biome_seed = buffer_read(buffer_grabacion, buffer_s8)
		}
		tutorial = buffer_read(buffer_grabacion, buffer_u8)
		oleadas = buffer_read(buffer_grabacion, buffer_u8)
		oleadas_tiempo = buffer_read(buffer_grabacion, buffer_u32)
		oleadas_tiempo_primera = buffer_read(buffer_grabacion, buffer_u32)
		multiplicador_vida_enemigos = buffer_read(buffer_grabacion, buffer_f64)
		dificultad = buffer_read(buffer_grabacion, buffer_s8)
		tecnologia = buffer_read(buffer_grabacion, buffer_bool)
		grabacion_pos = buffer_tell(buffer_grabacion)
	}
}