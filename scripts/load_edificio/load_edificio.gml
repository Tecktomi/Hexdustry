function load_edificio(buffer, edificio = control.null_edificio){
	with control{
		edificio.input_index = real(buffer_read(buffer, buffer_u8))
		edificio.output_index = real(buffer_read(buffer, buffer_u8))
		edificio.proceso = real(buffer_read(buffer, buffer_f16))
		edificio.start = bool(buffer_read(buffer, buffer_bool))
		for(var a = 0; a < rss_max; a++)
			edificio.carga[a] = real(buffer_read(buffer, buffer_f16))
		edificio.carga_id = real(buffer_read(buffer, buffer_u8))
		edificio.carga_total = real(buffer_read(buffer, buffer_f16))
		edificio.fuel = real(buffer_read(buffer, buffer_u16))
		edificio.waiting = bool(buffer_read(buffer, buffer_bool))
		edificio.idle = bool(buffer_read(buffer, buffer_bool))
		var b = real(buffer_read(buffer, buffer_u16))
		if b < 65535
			edificio.link = edificios[b]
		edificio.vida = real(buffer_read(buffer, buffer_f16))
		var dis = edificio_vida[edificio.index] - edificio.vida
		if dis != 0{
			edificio.vida = edificio_vida[edificio.index]
			herir_edificio(dis, edificio)
		}
		b = real(buffer_read(buffer, buffer_u16))
		if b < 65535
			edificio.target = edificios[b]
		edificio.target_edificio.punteros[0] = real(buffer_read(buffer, buffer_u16))
		edificio.flujo_consumo = real(buffer_read(buffer, buffer_f16))
		edificio.flujo_consumo_max = real(buffer_read(buffer, buffer_f16))
		edificio.energia_consumo = real(buffer_read(buffer, buffer_f16))
		edificio.energia_consumo_max = real(buffer_read(buffer, buffer_f16))
		edificio.edificio_index = real(buffer_read(buffer, buffer_u16))
		edificio.luz = bool(buffer_read(buffer, buffer_bool))
		var len = real(buffer_read(buffer, buffer_u16))
		for(var a = 0; a < len; a++){
			b = real(buffer_read(buffer, buffer_u16))
			if b < 65535
				array_push(edificio.procesador_link, edificios[b])
		}
		edificio.eliminar = bool(buffer_read(buffer, buffer_bool))
		edificio.agregar = bool(buffer_read(buffer, buffer_bool))
		for(var a = 0; a < 13; a++)
			edificio.punteros[a] = real(buffer_read(buffer, buffer_u16))
		edificio.outputs_carga_index = real(buffer_read(buffer, buffer_u8))
	}
}