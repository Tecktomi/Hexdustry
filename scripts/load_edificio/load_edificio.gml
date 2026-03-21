function load_edificio(buffer, edificio = control.null_edificio){
	with control{
		var mask = buffer_read(buffer, buffer_u64), c = 0, temp_target_dron = -1, flag = false
		if mask & (1 << c++) edificio.input_index = real(buffer_read(buffer, buffer_u8))
		if mask & (1 << c++) edificio.output_index = real(buffer_read(buffer, buffer_u8))
		if mask & (1 << c++) edificio.proceso = real(buffer_read(buffer, buffer_f16))
		if mask & (1 << c++) edificio.start = true
		for(var a = 0; a < rss_max; a++)
			if mask & (1 << c++){
				edificio.carga[a] = real(buffer_read(buffer, buffer_f16))
				edificio.carga_total += edificio.carga[a]
			}
		if mask & (1 << c++) edificio.carga_id = real(buffer_read(buffer, buffer_u8))
		if mask & (1 << c++) edificio.fuel = real(buffer_read(buffer, buffer_u16))
		if mask & (1 << c++){
			edificio.select = real(buffer_read(buffer, buffer_s8))
			flag = true
		}
		if mask & (1 << c++){
			edificio.mode = true
			flag = true
		}
		if mask & (1 << c++) edificio.waiting = true
		if mask & (1 << c++) edificio.idle = true
		if mask & (1 << c++) edificio.link = edificios_totales[real(buffer_read(buffer, buffer_u16))]
		if mask & (1 << c++) herir_edificio(edificio_vida[edificio.index] - real(buffer_read(buffer, buffer_f16)), edificio)
		if mask & (1 << c++) temp_target_dron = real(buffer_read(buffer, buffer_u16))
		if mask & (1 << c++) edificio.target_edificio = edificios_totales[real(buffer_read(buffer, buffer_u16))]
		if mask & (1 << c++) edificio.flujo_consumo = real(buffer_read(buffer, buffer_f16))
		if mask & (1 << c++) edificio.flujo_consumo_max = real(buffer_read(buffer, buffer_f16))
		if mask & (1 << c++) edificio.energia_consumo = real(buffer_read(buffer, buffer_f16))
		if mask & (1 << c++) edificio.energia_consumo_max = real(buffer_read(buffer, buffer_f16))
		if mask & (1 << c++) edificio.edificio_index = real(buffer_read(buffer, buffer_u16))
		if mask & (1 << c++) encender_luz(edificio.luz)
		if mask & (1 << c++){
			var len = real(buffer_read(buffer, buffer_u16))
			for(var a = 0; a < len; a++)
				array_push(edificio.procesador_link, edificios_totales[real(buffer_read(buffer, buffer_u16))])
		}
		if mask & (1 << c++) edificio.eliminar = true
		if mask & (1 << c++) edificio.agregar = true
		if mask & (1 << c++) edificio.modulo = true
		if mask & (1 << c++) edificio.outputs_carga_index = real(buffer_read(buffer, buffer_u8))
		if flag and edificio_seteable[edificio.index]
			set_edificio(edificio.mode, edificio.select, edificio)
		return temp_target_dron
	}
}